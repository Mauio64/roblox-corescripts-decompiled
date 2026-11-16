local module = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions/AddUser")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions/AddUsers")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions/ClearUserSpecificData")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions/ReceivedDisplayName")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions/RemoveUser")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions/SetUserIsFriend")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions/SetUserMembershipType")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions/ReceivedUserPresence")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions/SetUserPresence")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions/SetLocalUserId")
local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions/SetLocalUserUnder13")
return {
	AddUser = module,
	AddUsers = module2,
	ClearUserSpecificData = module3,
	ReceivedDisplayName = module4,
	RemoveUser = module5,
	SetUserIsFriend = module6,
	SetUserMembershipType = module7,
	SetUserHasRobloxSubscription = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions/SetUserHasRobloxSubscription"),
	ReceivedUserPresence = module8,
	SetUserPresence = module9,
	SetLocalUserId = module10,
	SetLocalUserUnder13 = module11
}
