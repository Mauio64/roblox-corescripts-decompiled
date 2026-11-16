local UserBlockingRodux = script:FindFirstAncestor("UserBlockingRodux")

local isBlockedByMe = require(UserBlockingRodux.Reducers.UserBlocking.isBlockedByMe)

local v = { isBlockedByMe = {} }

return function(p)
	local blockedByMe = isBlockedByMe(p)

	return function(p2, p3)
		return {
			isBlockedByMe = blockedByMe((p2 or v).isBlockedByMe, p3)
		}
	end
end
