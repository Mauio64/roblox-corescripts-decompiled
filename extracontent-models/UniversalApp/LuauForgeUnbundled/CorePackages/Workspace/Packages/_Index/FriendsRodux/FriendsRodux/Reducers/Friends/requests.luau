local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")

local module2 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/requests/receivedCount")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/requests/byUserId")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/requests/mutualFriends")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/requests/sourceUniverseIds")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/requests/nextPageCursor")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/requests/sentAt")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/requests/originSourceType")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/requests/order")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/requests/senderNickname")
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/requests/isUnseen")
local module12 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/requests/newFriendRequestsCount")

return function(p2)
	return Rodux.combineReducers({
		receivedCount = module2(p2),
		byUserId = module3(p2),
		mutualFriends = module4(p2),
		sourceUniverseIds = module5(p2),
		nextPageCursor = module6(p2),
		sentAt = module7(p2),
		originSourceType = module8(p2),
		order = module9(p2),
		senderNickname = module10(p2),
		isUnseen = module11(p2),
		newFriendRequestsCount = module12(p2)
	})
end
