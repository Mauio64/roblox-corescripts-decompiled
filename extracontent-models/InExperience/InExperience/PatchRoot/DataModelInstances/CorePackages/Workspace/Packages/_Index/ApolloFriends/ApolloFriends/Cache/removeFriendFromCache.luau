local function removeFriendFromCache(p, p2)
	local identify = p.cache:identify({
		__typename = "Friend",
		id = p2.userId,
		targetUserId = p2.targetUserId
	})

	p.cache:evict({ id = identify })
	p.cache:gc()
end

return removeFriendFromCache
