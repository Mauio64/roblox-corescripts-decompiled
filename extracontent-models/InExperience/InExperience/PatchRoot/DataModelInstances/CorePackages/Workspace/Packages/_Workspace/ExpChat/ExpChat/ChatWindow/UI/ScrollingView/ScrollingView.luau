local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Roact = require(parent.Roact)
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local ExpChatShared = require(parent.ExpChatShared)
local FFlagExpChatEnableV2ChatWindow = require(ExpChat.Flags.FFlagExpChatEnableV2ChatWindow)
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
	return Roact.createElement("ImageButton", {
		BackgroundTransparency = 1,
		Selectable = false,
		Size = p.props.size
	}, {
		bottomLockedScrollView = Roact.createElement(BottomLockedScrollViewV3, dictionary.join({
			Size = UDim2.fromScale(1, 1),
			isChannelBarVisible = p.props.isChannelBarVisible,
			scrollResetKey = p.props.scrollResetKey,
			scrollToTopOnReset = p.props.scrollToTopOnReset,
			onCanvasPositionChanged = p.props.onCanvasPositionChanged,
			contentTopPadding = p.props.contentTopPadding
		}, v))
	})
end

return extended
