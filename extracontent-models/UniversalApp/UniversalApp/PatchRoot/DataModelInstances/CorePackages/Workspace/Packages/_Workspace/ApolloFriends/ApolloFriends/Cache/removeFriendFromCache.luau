local function removeFriendFromCache(p1, t1: {[any]: any}) -- line: 6
	local v4 = p1.cache:identify({
		__typename = "Friend",
		id = t1.userId,
		targetUserId = t1.targetUserId
	})

	p1.cache:evict({
		id = v4
	})
	p1.cache:gc()
end

return removeFriendFromCache
