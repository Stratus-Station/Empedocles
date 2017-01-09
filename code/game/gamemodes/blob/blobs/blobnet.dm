/*
This is effectively the controller of the blobnet, and is what actually tracks blobs under its command.
*/
/datum/blobnet
	var/list/blobs=list()
	var/list/corelinks=list()

	var/maxrange=10
	var/dirty=TRUE // Update
	var/core=FALSE // Pulse even with no connected cores.

	// If this dies, we die.
	var/obj/effect/blob/blob=null

/datum/blobnet/New(var/obj/effect/blob/owner)
	..()
	blob=owner
	core = istype(blob, /obj/effect/blob/core)
	find_subjects()

/datum/blobnet/Destroy()
	for(var/obj/effect/blob/B in blobs)
		B.unsubscribe_from_pulser(blob)
	blobs.Cut()
	corelinks.Cut()
	..()

/datum/blobnet/proc/send_pulse()
	if(dirty)
		dirty=FALSE
		find_subjects()
	if(core || corelinks.len>0)
		var/list/newblobs=list()
		for(var/obj/effect/blob/B in blobs)
			if(B)
				newblobs += B
				B.Pulse()
		blobs=newblobs

/datum/blobnet/proc/add_core(var/obj/effect/blob/core/C)
	if(!(C in corelinks)
		corelinks += C


/datum/blobnet/proc/find_subjects()
	// All connected blobs
	var/list/connected=list()
	// Blobs that need searched still
	var/list/to_search=list(blob)
	// cursor
	var/turf/T=null
	// blob cursor
	var/obj/effect/blob/B=null
	// range squared (get_dist_squared doesn't need sqrt)
	var/maxrangesqr=maxrange ** 2

	// Delink all cores from this node.
	corelinks.Cut()

	// Loop until to_search is empty
	var/iloopchk=1000
	while(to_search.len > 0)
		// Infinite loop check
		if((--iloopchk) == 0)
			world.log << "Infinite loop detected in find_subjects()!"
			break
		// Pop blob off the top of the stack
		B=to_search[to_search.len]
		to_search.len--
		if(!B) continue
		T=get_turf(B)
		// For every direction, step and add to searchlist...
		for(var/i = 1; i < 8; i += i)
			var/turf/NewT=get_step(T,i)
			//world.log << "find_subjects(): Scanning <[NewT.x],[NewT.y],[NewT.z]>..."
			B = locate() in NewT
			// If not null, the parent blob, already in connected blob list, or outside our range.
			if(isnull(B) || B == blob || B in connected || get_dist_squared(B,blob) > maxrangesqr)
				continue
			connected += B
			to_search += B
			if(B.blobnet)
				for(var/obj/effect/blob/core/C in B.blobnet.get_cores())
					add_core(C)

	// Blobs in blobs but not connected (disconnected)
	for(var/obj/effect/blob/dead in blobs-connected)
		if(dead)
			dead.unsubscribe_from_pulser(src)

	// Blobs in connected but not blobs (newly connected)
	for(var/obj/effect/blob/newB in connected-blobs)
		if(newB)
			newB.subscribe_to_pulser(src, get_dist(newB,blob))

	// Update connected list.
	blobs=connected