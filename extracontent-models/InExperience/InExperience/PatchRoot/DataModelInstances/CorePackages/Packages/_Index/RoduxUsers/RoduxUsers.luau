local Reducers = require(script.Reducers)
local Actions = require(script.Actions)
local Models = require(script.Models)

local parent = script.Parent
local Cryo = require(parent.Cryo)
local RoduxNetworking = require(parent.RoduxNetworking)
local FriendsNetworking = require(parent.FriendsNetworking)
local UsersNetworking = require(parent.UsersNetworking)
local roduxUsersTypes = require(script.roduxUsersTypes)

return {
	config = function(p)
		local joined = Cryo.Dictionary.join(p, {
			usersNetworking = UsersNetworking.config({ roduxNetworking = RoduxNetworking.mock() }),
			friendsNetworking = FriendsNetworking.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function()
				return Reducers(joined)
			end,
			Actions = Actions,
			Models = Models,
			roduxUsersTypes = roduxUsersTypes
		}
	end
}
