local function removeFriendFromCache(p2, p3)
	local identify = p2.cache:identify({
		__typename = "Friend",
		id = p3.userId,
		targetUserId = p3.targetUserId
	})

	p2.cache:evict({ id = identify })
	p2.cache:gc()
end

return removeFriendFromCache
