local parent = script.Parent
local llama = require(parent.llama)
local RoduxNetworking = require(parent.RoduxNetworking)
local FriendsNetworking = require(parent.FriendsNetworking)
local NetworkingBlocking = require(parent.NetworkingBlocking)

local FriendsReducer = require(script.Reducers.FriendsReducer)
local Actions = require(script.Actions)
local Selectors = require(script.Selectors)
local Models = require(script.Models)
local Enums = require(script.Enums)

return {
	config = function(p)
		local joined = llama.Dictionary.join(p, {
			friendsNetworking = FriendsNetworking.config({
				roduxNetworking = RoduxNetworking.mock()
			}),
			networkingBlocking = NetworkingBlocking.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function()
				return FriendsReducer(joined)
			end,
			Actions = Actions(joined),
			Selectors = Selectors(joined),
			Models = Models,
			Enums = Enums
		}
	end
}
