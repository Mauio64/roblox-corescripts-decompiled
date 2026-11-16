local AddUser = require(script.AddUser)
local AddUsers = require(script.AddUsers)
local ClearUserSpecificData = require(script.ClearUserSpecificData)
local ReceivedDisplayName = require(script.ReceivedDisplayName)
local RemoveUser = require(script.RemoveUser)
local SetUserIsFriend = require(script.SetUserIsFriend)
local SetUserMembershipType = require(script.SetUserMembershipType)
local ReceivedUserPresence = require(script.ReceivedUserPresence)
local SetUserPresence = require(script.SetUserPresence)
local SetLocalUserId = require(script.SetLocalUserId)
local SetLocalUserUnder13 = require(script.SetLocalUserUnder13)
return {
	AddUser = AddUser,
	AddUsers = AddUsers,
	ClearUserSpecificData = ClearUserSpecificData,
	ReceivedDisplayName = ReceivedDisplayName,
	RemoveUser = RemoveUser,
	SetUserIsFriend = SetUserIsFriend,
	SetUserMembershipType = SetUserMembershipType,
	SetUserHasRobloxSubscription = require(script.SetUserHasRobloxSubscription),
	ReceivedUserPresence = ReceivedUserPresence,
	SetUserPresence = SetUserPresence,
	SetLocalUserId = SetLocalUserId,
	SetLocalUserUnder13 = SetLocalUserUnder13
}
