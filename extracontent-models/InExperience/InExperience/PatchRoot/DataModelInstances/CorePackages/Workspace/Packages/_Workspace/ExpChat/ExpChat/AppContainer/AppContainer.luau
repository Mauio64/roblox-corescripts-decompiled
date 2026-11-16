local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Roact = require(parent.Roact)
local React = require(parent.React)
local RoactRodux = require(parent.RoactRodux)
local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local tutils = require(parent.tutils)
local SharedFlags = require(parent.SharedFlags)
local ExpChatShared = require(parent.ExpChatShared)
local FriendsChatTabName = require(parent.FriendsChat.FriendsChatTabName)

local ClientSettings = require(ExpChat.ClientSettings)

local mapStateToProps = require(script.Parent.mapStateToProps)
local mapDispatchToProps = require(script.Parent.mapDispatchToProps)

local BubbleChat = require(script.Parent.Parent.BubbleChat)
local AppLayout = require(script.Parent.Parent.AppLayout)
local isChatRegionLocked = require(ExpChat.isChatRegionLocked)
local TextChatService = game:GetService("TextChatService")

local getFFlagChatTranslationShowFTUX = require(ExpChat.Flags.getFFlagChatTranslationShowFTUX)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatNewInputBar = require(ExpChat.Flags.FFlagExpChatNewInputBar)
local getFFlagExpChatAlwaysRunTCS = SharedFlags.getFFlagExpChatAlwaysRunTCS
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local GetChannelTabsStore

if FFlagExpChatUseChannelTabsStore then
	GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
else
	GetChannelTabsStore = nil
end

function getChatWindowEnabled()
	local success, result = pcall(function()
		local chatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

		return chatWindowConfiguration ~= nil and chatWindowConfiguration.Enabled
	end)

	return success and result
end

function getChatTranslationEnabled()
	local success, result = pcall(function()
		return TextChatService.ChatTranslationEnabled
	end)

	return success and result
end

function getChatTranslationToggleEnabled()
	local success, result = pcall(function()
		return TextChatService.ChatTranslationToggleEnabled
	end)

	return success and result
end

function shouldShowChatTranslationFTUX(): boolean
	if not game:GetEngineFeature("TextChatServiceSettingsSaved") then
		return true
	end

	local success, result = pcall(function()
		return TextChatService.ChatTranslationFTUXShown
	end)

	return not (success and result)
end

local v = shouldShowChatTranslationFTUX()

local ChatTranslationFTUX = require(script.Parent.Parent.ChatTranslationFTUX)

local extended = Roact.PureComponent:extend("AppContainer")
extended.defaultProps = {
	isChatInputBarVisible = true,
	isChatWindowVisible = true,
	isChannelBarVisible = false,
	onSendChat = nil,
	onSendGlobalChat = nil,
	mutedUserIds = nil,
	textTimer = nil,
	timer = nil,
	textChatService = TextChatService,
	chat = game:GetService("Chat")
}

local changedConnection = nil

function extended.init(object)
	object:setState({ showTranslationButton = false, isTextChatServiceEnabled = false })
end

function extended.willUnmount(_)
	changedConnection:Disconnect()
end

function extended:didMount()
	self.migrationConnection = self.props.chat:GetPropertyChangedSignal("IsAutoMigrated"):Connect(function()
		if self.props.chat.IsAutoMigrated then
			self:setState({ isTextChatServiceEnabled = true })
		end
	end)

	local function onTextChatServicePropertyChanged(p)
		if p == "ChatTranslationEnabled" then
			local success, result = pcall(function()
				return TextChatService.ChatTranslationEnabled
			end)

			if success then
				self.props.onToggleTranslation(result)

				self:setState({
					showTranslationButton = getChatTranslationEnabled() and getChatTranslationToggleEnabled()
				})
			end
		elseif p == "ChatTranslationToggleEnabled" then
			local success, _ = pcall(function()
				return TextChatService.ChatTranslationToggleEnabled
			end)

			local success2, result = pcall(function()
				return TextChatService.ChatTranslationEnabled
			end)

			if success then
				if success2 then
					self.props.onToggleTranslation(result)
				end

				self:setState({
					showTranslationButton = getChatTranslationEnabled() and getChatTranslationToggleEnabled()
				})
			end
		end
	end

	if not changedConnection then
		changedConnection = TextChatService.Changed:Connect(onTextChatServicePropertyChanged)
	end

	self:setState({
		showTranslationButton = getChatTranslationEnabled() and getChatTranslationToggleEnabled(),
		isTextChatServiceEnabled = self.props.textChatService.ChatVersion == Enum.ChatVersion.TextChatService or getFFlagExpChatAlwaysRunTCS()
	})
end

function extended.render(p)
	local isTextChatServiceEnabled = p.state.isTextChatServiceEnabled

	local element = Roact.createElement(BubbleChat, {
		getIconVoiceIndicator = p.props.getIconVoiceIndicator,
		onClickedVoiceIndicator = p.props.onClickedVoiceIndicator,
		onClickedCameraIndicator = p.props.onClickedCameraIndicator,
		selfViewListenerChanged = p.props.selfViewListenerChanged,
		getPermissions = p.props.getPermissions,
		displayCameraDeniedToast = p.props.displayCameraDeniedToast,
		isCamEnabledForUserAndPlace = p.props.isCamEnabledForUserAndPlace,
		isCameraOnlyUser = p.props.isCameraOnlyUser,
		isTextChatServiceOn = isTextChatServiceEnabled,
		isVoiceServiceInitialized = p.props.isVoiceServiceInitialized
	})

	if not isTextChatServiceEnabled then
		return Roact.createElement(ClientSettings.Provider, { value = p.props.clientSettings }, {
			bubbleChat = element
		})
	end

	local createElement = Roact.createElement
	local provider = ClientSettings.Provider
	local v2 = { value = p.props.clientSettings }

	local createFragment = Roact.createFragment
	local createElement2 = Roact.createElement
	local v3 = {
		isChatInputBarVisible = not isChatRegionLocked() and p.props.isChatInputBarVisible,
		isChatWindowVisible = p.props.isChatWindowVisible,
		isChannelBarVisible = p.props.isChannelBarVisible,
		chatTopBarVisibility = p.props.chatTopBarVisibility,
		mutedUserIds = p.props.mutedUserIds,
		onSendChat = p.props.onSendChat,
		onSendGlobalChat = p.props.onSendGlobalChat,
		timer = p.props.timer,
		textTimer = p.props.textTimer,
		activateWhisperMode = p.props.activateWhisperMode,
		resetTargetChannel = p.props.resetTargetChannel,
		isTextBoxFocused = p.props.isTextBoxFocused,
		onHovered = p.props.onHovered,
		onUnhovered = p.props.onUnhovered,
		chatLayoutAlignment = p.props.chatLayoutAlignment,
		chatWindowSettings = p.props.chatWindowSettings,
		clientSettings = p.props.clientSettings,
		selectedTabType = p.props.selectedTabType,
		renderingFriends = p.props.renderingFriends,
		isExperienceChatRendered = p.props.isExperienceChatRendered,
		showTranslationButton = p.state.showTranslationButton,
		isSpatialUIEnabled = p.props.isSpatialUIEnabled,
		targetTextChannel = 0
	}
	local targetTextChannel

	if FFlagExpChatPresetChatEnabled or FFlagExpChatNewInputBar then
		targetTextChannel = p.props.targetTextChannel
	end

	v3.targetTextChannel = targetTextChannel
	local v4 = {
		appLayout = createElement2(AppLayout, v3),
		bubbleChat = element,
		ChatTranslationFTUX = 0
	}
	local chatTranslationFTUX

	if getFFlagChatTranslationShowFTUX() and v and getChatTranslationEnabled() and getChatWindowEnabled() then
		chatTranslationFTUX = Roact.createElement(ChatTranslationFTUX, {})
	end

	v4.ChatTranslationFTUX = chatTranslationFTUX
	return createElement(provider, v2, { app = createFragment(v4) })
end

local v2 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)

local function AppContainerWithSignals(p)
	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			local channelTabsState = GetChannelTabsStore(false).getChannelTabsState(p2)
			local v3

			if channelTabsState.selectedTabName then
				v3 = channelTabsState.allChannelTabs[channelTabsState.selectedTabName]
			end

			return {
				isGlobalTabSelected = channelTabsState.selectedTabName == "RBXGlobal",
				selectedTabType = v3 and v3.type or nil,
				hasGlobalChannelTab = channelTabsState.allChannelTabs.RBXGlobal ~= nil,
				hasFriendsChannelTab = channelTabsState.allChannelTabs[FriendsChatTabName] ~= nil
			}
		end, tutils.deepEqual)
	end, {})
	local v4 = SignalsReact.useSignalState(v3)
	return React.createElement(v2, Cryo.Dictionary.union(p, v4))
end

if FFlagExpChatUseChannelTabsStore then
	return AppContainerWithSignals
end

return v2
