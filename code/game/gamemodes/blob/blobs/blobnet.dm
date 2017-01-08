/*
This is effectively the controller of the blobnet, and is what actually tracks blobs under its command.
*/
/datum/blobnet
	var/list/blobs=list()
	var/maxrange=10

	// If this dies, we die.
	var/obj/effect/blob/blob=null

/datum/blobnet/New(var/obj/effect/blob/owner)
	..()
	blob=owner
	find_subjects()

/datum/blobnet/Destroy()
	for(var/obj/effect/blob/B in blobs)
		B.unsubscribe_from_pulser(blob)
	blobs.Cut()
	..()

/datum/blobnet/proc/send_pulse()
	var/list/newblobs=list()
	for(var/obj/effect/blob/B in blobs)
		if(B)
			newblobs += B
			B.Pulse()
	blobs=newblobs

/datum/blobnet/proc/find_subjects()
	/// Sign up with all pulser blobs within MAX_PULSER_RANGE
	for(var/b in orange(src, MAX_PULSER_RANGE))
		if(istype(b, /obj/effect/blob))
			var/obj/effect/blob/B = b
			B.subscribe_to_pulser(src, get_dist(src, B))