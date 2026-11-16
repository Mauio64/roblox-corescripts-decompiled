local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")
local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/RoduxNetworking")
local networkingBlocking = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/LuaSocialLibrariesDeps").NetworkingBlocking
local UserBlockingNetworking = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/UserBlockingNetworking")

local FriendsReducer = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/FriendsReducer")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Selectors")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Models")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Enums")

return {
	config = function(p2)
		local joined = llama.Dictionary.join(p2, {
			friendsNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/NetworkingFriends").config({
				roduxNetworking = RoduxNetworking.mock()
			}),
			networkingBlocking = networkingBlocking.config({
				roduxNetworking = RoduxNetworking.mock()
			}),
			userBlockingNetworking = UserBlockingNetworking.config({ roduxNetworking = RoduxNetworking.mock() })
		})

		return {
			installReducer = function()
				return FriendsReducer(joined)
			end,
			Actions = module5(joined),
			Selectors = module6(joined),
			Models = module7,
			Enums = module8
		}
	end
}
