local _script = script
local _scriptParent = _script.Parent
local Cryo = require(_scriptParent.Cryo)
local RoduxNetworking = require(_scriptParent.RoduxNetworking)
local UserBlockingNetworking = require(_scriptParent.UserBlockingNetworking)
local UserBlockingReducer = require(_script.Reducers.UserBlockingReducer)

return {
	["jest.config"] = script["jest.config"],
	config = function(p1) -- line: 11
		-- upvalues: Cryo (copy), UserBlockingNetworking (copy), RoduxNetworking (copy), UserBlockingReducer (copy)
		local u8 = Cryo.Dictionary.join(p1, {
			userBlockingNetworking = UserBlockingNetworking.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function() -- line: 19
				-- upvalues: UserBlockingReducer (copy), u8 (ref)
				return UserBlockingReducer(u8)
			end
		}
	end
}
