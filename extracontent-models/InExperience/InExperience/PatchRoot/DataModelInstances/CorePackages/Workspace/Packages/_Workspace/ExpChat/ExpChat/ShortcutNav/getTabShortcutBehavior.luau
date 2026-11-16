local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local ExpChatShared = require(parent.ExpChatShared)
local FriendsChatFocus = require(parent.FriendsChat.FriendsChatFocus)
local GetFocusNavigationStore = require(ExpChat.Stores.GetFocusNavigationStore)
local TabTypes = ExpChatShared.TabTypes

local function neverOpen(): boolean
	return false
end

local v = {
	canOpenChat = neverOpen,
	focus = function(_)
		GetFocusNavigationStore(false).requestChatInputBarFocus()
		return Enum.ContextActionResult.Sink
	end
}

local v2 = {
	canOpenChat = FriendsChatFocus.canFocus,
	focus = function(p)
		return FriendsChatFocus.focus(p.keyCode)
	end
}

local function getTabShortcutBehavior(p)
	if p == "FriendsChat" then
		return v2
	elseif p == "TextChat" then
		return v
	elseif p == "UniverseChat" then
		return v
	end

	return TabTypes.unreachable(p)
end

return getTabShortcutBehavior
