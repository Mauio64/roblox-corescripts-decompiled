local parent = script:FindFirstAncestor("UserRelationshipModals").Parent

local AppCommonLib = require(parent.AppCommonLib)
local MockLocalization = {}

function MockLocalization.Format(_, p: string)
	if
		p == "InGame.FriendPlayerPrompt.Title.SendFriendRequest"
		or p == "InGame.FriendPlayerPrompt.Title.SendFriendRequest.FriendsRename"
	then
		return "Send Friend Request"
	end

	if p == "InGame.FriendPlayerPrompt.Action.Send" then
		return "Send"
	elseif p == "Feature.Friends.Action.FriendRequestSent" then
		return "Friend Request Sent"
	elseif p == "CommonUI.Messages.Response.SomethingWentWrong" then
		return "Something Went Wrong"
	end

	return p
end

function MockLocalization.GetLocale(): string
	return "en-us"
end

MockLocalization.changed = AppCommonLib.Signal.new()
return MockLocalization
