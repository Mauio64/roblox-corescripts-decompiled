local Parent = script:FindFirstAncestor("UserRelationshipModals").Parent
local Signal = require(Parent.AppCommonLib).Signal

return {
	Format = function(_, s1: string) -- line: 8
		if s1 == "InGame.FriendPlayerPrompt.Title.SendFriendRequest" or s1 == "InGame.FriendPlayerPrompt.Title.SendFriendRequest.FriendsRename" then
			return "Send Friend Request"
		end

		if s1 == "InGame.FriendPlayerPrompt.Action.Send" then
			return "Send"
		end

		if s1 == "Feature.Friends.Action.FriendRequestSent" then
			return "Friend Request Sent"
		end

		if s1 == "CommonUI.Messages.Response.SomethingWentWrong" then
			return "Something Went Wrong"
		end

		return s1
	end,
	GetLocale = function() -- line: 26
		return "en-us"
	end,
	changed = Signal.new()
}
