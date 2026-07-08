local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Roact = require(ExpChatParent.Roact)
local Dictionary = require(ExpChatParent.llama).Dictionary
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local FFlagExpChatEnableFocusNavigation = require(ExpChat.Flags.FFlagExpChatEnableFocusNavigation)
local FFlagExpChatEnableV2ChatWindow = require(ExpChat.Flags.FFlagExpChatEnableV2ChatWindow)
local FFlagExpChatWindowMessageSourceRefactor = require(ExpChatParent.SharedFlags).FFlagExpChatWindowMessageSourceRefactor
local FFlagExpChatChannelTabRefactor = require(ExpChatParent.SharedFlags).FFlagExpChatChannelTabRefactor
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local BottomLockedScrollViewV3 = require(ExpChat.ChatWindow.UI.BottomLockedScrollViewV3)
local v12 = Roact.PureComponent:extend("ScrollingView")

v12.defaultProps = {}

function v12.render(p1) -- line: 18
	-- upvalues: FFlagExpChatEnableV2ChatWindow (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatWindowMessageSourceRefactor (copy), Roact (copy), FFlagExpChatEnableFocusNavigation (copy), BottomLockedScrollViewV3 (copy), Dictionary (copy), FFlagExpChatChannelTabRefactor (copy)
	local t1 = {}

	if FFlagExpChatEnableV2ChatWindow then
		t1 = {
			showTranslationButton = p1.props.showTranslationButton,
			chatWindowSettings = p1.props.chatWindowSettings,
			textTransparency = p1.props.textTransparency,
			onTextMessageLabelButtonActivated = p1.props.onTextMessageLabelButtonActivated,
			isSpatialUIEnabled = p1.props.isSpatialUIEnabled,
			chatWindowTransparencyBindable = p1.props.chatWindowTransparencyBindable,
			visible = p1.props.visible,
			selectedChannelName = if not GetFFlagTextChatEnableUniverseChatTabs() then nil else p1.props.selectedChannelName
		}
	end

	if FFlagExpChatWindowMessageSourceRefactor then
		t1.messageComponentsSignal = p1.props.messageComponentsSignal
	end

	return Roact.createElement("ImageButton", {
		BackgroundTransparency = 1,
		Selectable = not FFlagExpChatEnableFocusNavigation and nil,
		Size = p1.props.size
	}, {
		bottomLockedScrollView = Roact.createElement(BottomLockedScrollViewV3, Dictionary.join({
			Size = UDim2.fromScale(1, 1),
			targetTextChannel = p1.props.targetTextChannel,
			isChannelBarVisible = p1.props.isChannelBarVisible,
			scrollResetKey = if not FFlagExpChatChannelTabRefactor then nil else p1.props.scrollResetKey
		}, t1), if not FFlagExpChatEnableV2ChatWindow and not FFlagExpChatWindowMessageSourceRefactor then p1.props[Roact.Children] else nil)
	})
end

return v12
