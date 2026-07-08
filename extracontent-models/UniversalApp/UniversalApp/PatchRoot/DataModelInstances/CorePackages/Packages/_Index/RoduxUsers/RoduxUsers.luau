local Reducers = require(script.Reducers)
local Actions = require(script.Actions)
local Models = require(script.Models)
local scriptParent = script.Parent
local Cryo = require(scriptParent.Cryo)
local RoduxNetworking = require(scriptParent.RoduxNetworking)
local FriendsNetworking = require(scriptParent.FriendsNetworking)
local UsersNetworking = require(scriptParent.UsersNetworking)
local roduxUsersTypes = require(script.roduxUsersTypes)

return {
	config = function(p1) -- line: 13
		-- upvalues: Cryo (copy), UsersNetworking (copy), RoduxNetworking (copy), FriendsNetworking (copy), Reducers (copy), Actions (copy), Models (copy), roduxUsersTypes (copy)
		local u11 = Cryo.Dictionary.join(p1, {
			usersNetworking = UsersNetworking.config({
				roduxNetworking = RoduxNetworking.mock()
			}),
			friendsNetworking = FriendsNetworking.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function() -- line: 24
				-- upvalues: Reducers (copy), u11 (ref)
				return Reducers(u11)
			end,
			Actions = Actions,
			Models = Models,
			roduxUsersTypes = roduxUsersTypes
		}
	end
}
