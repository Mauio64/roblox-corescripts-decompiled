local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local UIBlox = require(ExpChatParent.UIBlox)
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local useCursor = UIBlox.App.SelectionCursor.useCursor
local Config = require(ExpChat.Config)
local FFlagExpChatEnableFocusNavigation = require(ExpChat.Flags.FFlagExpChatEnableFocusNavigation)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs

return function(p1) -- line: 14
	-- upvalues: FFlagExpChatEnableFocusNavigation (copy), useCursor (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), React (copy), Config (copy)
	local v11 = if not FFlagExpChatEnableFocusNavigation then nil else useCursor()
	local v12 = (p1.targetTextChannelDisplayName or "") ~= ""
	local v13 = GetFFlagTextChatEnableUniverseChatTabs() and not p1.developerChannelTabsEnabled
	local v14 = v12 and (not p1.isChannelBarVisible or v13)

	return React.createElement("TextButton", {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Font = Config.ChatInputBarFont,
		SelectionImageObject = v11,
		Size = UDim2.fromScale(0, 1),
		Text = p1.targetTextChannelDisplayName or "",
		TextColor3 = Config.ChatInputBarTextColor3,
		TextSize = Config.ChatInputBarTextSize,
		TextTransparency = p1.transparency or 1,
		TextWrapped = true,
		Visible = v14,
		[React.Change.AbsoluteSize] = p1.onAbsoluteSizeChanged,
		[React.Event.Activated] = p1.onChannelChipActivated
	})
end
