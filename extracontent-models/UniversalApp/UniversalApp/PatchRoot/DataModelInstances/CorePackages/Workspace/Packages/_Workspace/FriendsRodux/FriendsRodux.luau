local scriptParent = script.Parent
local llama = require(scriptParent.llama)
local RoduxNetworking = require(scriptParent.RoduxNetworking)
local NetworkingBlocking = require(scriptParent.LuaSocialLibrariesDeps).NetworkingBlocking
local UserBlockingNetworking = require(scriptParent.UserBlockingNetworking)
local FriendsReducer = require(script.Reducers.FriendsReducer)
local Actions = require(script.Actions)
local Selectors = require(script.Selectors)
local Models = require(script.Models)
local Enums = require(script.Enums)

return {
	["jest.config"] = script["jest.config"],
	config = function(p1) -- line: 16
		-- upvalues: llama (copy), scriptParent (copy), RoduxNetworking (copy), NetworkingBlocking (copy), UserBlockingNetworking (copy), FriendsReducer (copy), Actions (copy), Selectors (copy), Models (copy), Enums (copy)
		local u12 = llama.Dictionary.join(p1, {
			friendsNetworking = require(scriptParent.FriendsNetworking).config({
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
			installReducer = function() -- line: 30
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
