local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local ExpChatShared = require(parent.ExpChatShared)

local useCursor = UIBlox.App.SelectionCursor.useCursor

local Config = require(ExpChat.Config)

local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs

return function(props)
	local selectionImageObject = useCursor()
	local v = (props.targetTextChannelDisplayName or "") ~= ""
	local v2 = GetFFlagTextChatEnableUniverseChatTabs() and not props.developerChannelTabsEnabled
	local visible = v and (not props.isChannelBarVisible or v2)

	return React.createElement("TextButton", {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Font = Config.ChatInputBarFont,
		SelectionImageObject = selectionImageObject,
		Size = UDim2.fromScale(0, 1),
		Text = props.targetTextChannelDisplayName or "",
		TextColor3 = Config.ChatInputBarTextColor3,
		TextSize = Config.ChatInputBarTextSize,
		TextTransparency = props.transparency or 1,
		TextWrapped = true,
		Visible = visible,
		[React.Change.AbsoluteSize] = props.onAbsoluteSizeChanged,
		[React.Event.Activated] = props.onChannelChipActivated
	})
end
