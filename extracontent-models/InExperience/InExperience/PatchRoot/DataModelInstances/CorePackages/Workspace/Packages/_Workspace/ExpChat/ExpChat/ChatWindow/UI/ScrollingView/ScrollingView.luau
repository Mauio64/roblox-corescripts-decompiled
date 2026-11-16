local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Roact = require(parent.Roact)
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local ExpChatShared = require(parent.ExpChatShared)
local FFlagExpChatEnableV2ChatWindow = require(ExpChat.Flags.FFlagExpChatEnableV2ChatWindow)
local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs

local BottomLockedScrollViewV3 = require(ExpChat.ChatWindow.UI.BottomLockedScrollViewV3)

local extended = Roact.PureComponent:extend("ScrollingView")
extended.defaultProps = {}

function extended.render(p)
	local v

	if FFlagExpChatEnableV2ChatWindow then
		v = {
			showTranslationButton = p.props.showTranslationButton,
			chatWindowSettings = p.props.chatWindowSettings,
			textTransparency = p.props.textTransparency,
			onTextMessageLabelButtonActivated = p.props.onTextMessageLabelButtonActivated,
			isSpatialUIEnabled = p.props.isSpatialUIEnabled,
			chatWindowTransparencyBindable = p.props.chatWindowTransparencyBindable,
			visible = p.props.visible,
			selectedChannelName = 0,
			historicalMessageCountSignal = 0
		}
		local selectedChannelName

		if GetFFlagTextChatEnableUniverseChatTabs() then
			selectedChannelName = p.props.selectedChannelName
		end

		v.selectedChannelName = selectedChannelName

		v.historicalMessageCountSignal = p.props.historicalMessageCountSignal
	else
		v = {}
	end

	v.messageComponentsSignal = p.props.messageComponentsSignal
	local createElement = Roact.createElement
	local v2 = { BackgroundTransparency = 1, Selectable = false, Size = p.props.size }

	local createElement2 = Roact.createElement

	local join = dictionary.join
	local v3 = {
		Size = UDim2.fromScale(1, 1),
		isChannelBarVisible = p.props.isChannelBarVisible,
		scrollResetKey = p.props.scrollResetKey,
		scrollToTopOnReset = 0,
		onCanvasPositionChanged = 0,
		contentTopPadding = 0
	}
	local scrollToTopOnReset

	if FFlagExpChatEnableFriendsTab then
		scrollToTopOnReset = p.props.scrollToTopOnReset
	end

	v3.scrollToTopOnReset = scrollToTopOnReset
	local onCanvasPositionChanged

	if FFlagExpChatEnableFriendsTab then
		onCanvasPositionChanged = p.props.onCanvasPositionChanged
	end

	v3.onCanvasPositionChanged = onCanvasPositionChanged
	local contentTopPadding

	if FFlagExpChatEnableFriendsTab then
		contentTopPadding = p.props.contentTopPadding
	end

	v3.contentTopPadding = contentTopPadding
	return createElement("ImageButton", v2, {
		bottomLockedScrollView = createElement2(BottomLockedScrollViewV3, join(v3, v))
	})
end

return extended
