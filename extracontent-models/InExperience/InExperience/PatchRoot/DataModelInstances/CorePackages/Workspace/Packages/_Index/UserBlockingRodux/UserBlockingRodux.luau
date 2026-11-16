local script2 = script
local parent = script2.Parent
local Cryo = require(parent.Cryo)
local RoduxNetworking = require(parent.RoduxNetworking)
local UserBlockingNetworking = require(parent.UserBlockingNetworking)

local UserBlockingReducer = require(script2.Reducers.UserBlockingReducer)

return {
	["jest.config"] = script["jest.config"],
	config = function(p)
		local joined = Cryo.Dictionary.join(p, {
			userBlockingNetworking = UserBlockingNetworking.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function()
				return UserBlockingReducer(joined)
			end
		}
	end
}
