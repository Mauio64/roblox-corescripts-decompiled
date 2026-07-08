local scriptParent = script.Parent
local llama = require(scriptParent.llama)
local RoduxNetworking = require(scriptParent.RoduxNetworking)
local FriendsNetworking = require(scriptParent.FriendsNetworking)
local NetworkingBlocking = require(scriptParent.NetworkingBlocking)
local FriendsReducer = require(script.Reducers.FriendsReducer)
local Actions = require(script.Actions)
local Selectors = require(script.Selectors)
local Models = require(script.Models)
local Enums = require(script.Enums)

return {
	config = function(p1) -- line: 14
		-- upvalues: llama (copy), FriendsNetworking (copy), RoduxNetworking (copy), NetworkingBlocking (copy), FriendsReducer (copy), Actions (copy), Selectors (copy), Models (copy), Enums (copy)
		local u12 = llama.Dictionary.join(p1, {
			friendsNetworking = FriendsNetworking.config({
				roduxNetworking = RoduxNetworking.mock()
			}),
			networkingBlocking = NetworkingBlocking.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function() -- line: 25
				-- upvalues: FriendsReducer (copy), u12 (ref)
				return FriendsReducer(u12)
			end,
			Actions = Actions(u12),
			Selectors = Selectors(u12),
			Models = Models,
			Enums = Enums
		}
	end
}
