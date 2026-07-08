local scriptParent = script.Parent
local Dash = require(scriptParent.Dash)
local RoduxNetworking = require(scriptParent.RoduxNetworking)
local NetworkingUserSettings = require(scriptParent.NetworkingUserSettings)
local NetworkingAccountInformation = require(scriptParent.NetworkingAccountInformation)
local UserPermissionsReducer = require(script.Reducers.UserPermissionsReducer)

return {
	config = function(p1) -- line: 9
		-- upvalues: Dash (copy), NetworkingUserSettings (copy), RoduxNetworking (copy), NetworkingAccountInformation (copy), UserPermissionsReducer (copy)
		local u8 = Dash.join(p1, {
			networkingUserSettings = NetworkingUserSettings.config({
				roduxNetworking = RoduxNetworking.mock()
			}),
			networkingAccountInformation = NetworkingAccountInformation.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function() -- line: 20
				-- upvalues: UserPermissionsReducer (copy), u8 (ref)
				return UserPermissionsReducer(u8)
			end
		}
	end
}
