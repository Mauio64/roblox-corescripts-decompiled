local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UserBlockingRodux/Cryo")
local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/UserBlockingRodux/RoduxNetworking")
local UserBlockingNetworking = require("@game/CorePackages/Workspace/Packages/_Index/UserBlockingRodux/UserBlockingNetworking")

local UserBlockingReducer = require("@game/CorePackages/Workspace/Packages/_Index/UserBlockingRodux/UserBlockingRodux/Reducers/UserBlockingReducer")

return {
	config = function(p2)
		local joined = Cryo.Dictionary.join(p2, {
			userBlockingNetworking = UserBlockingNetworking.config({ roduxNetworking = RoduxNetworking.mock() })
		})

		return {
			installReducer = function()
				return UserBlockingReducer(joined)
			end
		}
	end
}
