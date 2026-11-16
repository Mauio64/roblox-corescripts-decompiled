local module = require("@game/CorePackages/Workspace/Packages/_Index/UserBlockingRodux/UserBlockingRodux/Reducers/UserBlocking/isBlockedByMe")

local v5 = { isBlockedByMe = {} }

return function(p2)
	local v6 = module(p2)

	return function(p3, p4)
		return {
			isBlockedByMe = v6((p3 or v5).isBlockedByMe, p4)
		}
	end
end
