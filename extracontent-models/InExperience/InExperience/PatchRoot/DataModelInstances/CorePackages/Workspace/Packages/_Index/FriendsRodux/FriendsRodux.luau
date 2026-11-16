local parent = script.Parent
local llama = require(parent.llama)
local RoduxNetworking = require(parent.RoduxNetworking)
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local NetworkingBlocking = LuaSocialLibrariesDeps.NetworkingBlocking
local UserBlockingNetworking = require(parent.UserBlockingNetworking)

local FriendsReducer = require(script.Reducers.FriendsReducer)
local Actions = require(script.Actions)
local Selectors = require(script.Selectors)
local Models = require(script.Models)
local Enums = require(script.Enums)

return {
	["jest.config"] = script["jest.config"],
	config = function(p)
		local join = llama.Dictionary.join
		local FriendsNetworking = require(parent.FriendsNetworking)
		local v = join(p, {
			friendsNetworking = FriendsNetworking.config({
				roduxNetworking = RoduxNetworking.mock()
			}),
			networkingBlocking = NetworkingBlocking.config({
				roduxNetworking = RoduxNetworking.mock()
			}),
			userBlockingNetworking = UserBlockingNetworking.config({
				roduxNetworking = RoduxNetworking.mock()
			})
		})

		return {
			installReducer = function()
				return FriendsReducer(v)
			end,
			Actions = Actions(v),
			Selectors = Selectors(v),
			Models = Models,
			Enums = Enums
		}
	end
}
