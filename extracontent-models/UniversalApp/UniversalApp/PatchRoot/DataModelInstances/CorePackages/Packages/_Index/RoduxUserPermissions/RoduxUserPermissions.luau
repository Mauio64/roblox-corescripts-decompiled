local parent = script.Parent
local Dash = require(parent.Dash)
local RoduxNetworking = require(parent.RoduxNetworking)
local NetworkingUserSettings = require(parent.NetworkingUserSettings)
local NetworkingAccountInformation = require(parent.NetworkingAccountInformation)
local UserPermissionsReducer = require(script.Reducers.UserPermissionsReducer)

return {
	config = function(p)
		local joined = Dash.join(p, {
			networkingUserSettings = NetworkingUserSettings.config({
				roduxNetworking = RoduxNetworking.mock()
			}),
			networkingAccountInformation = NetworkingAccountInformation.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function()
				return UserPermissionsReducer(joined)
			end
		}
	end
}
