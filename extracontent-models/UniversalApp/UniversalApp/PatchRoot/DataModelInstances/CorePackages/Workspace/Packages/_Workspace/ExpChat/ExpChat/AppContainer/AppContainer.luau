local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Roact = require(ExpChatParent.Roact)
local RoactRodux = require(ExpChatParent.RoactRodux)
local SharedFlags = require(ExpChatParent.SharedFlags)
local ExpChatShared = require(ExpChatParent.ExpChatShared)
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
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore

function getChatWindowEnabled() -- line: 25
	-- upvalues: TextChatService (copy)
	local ok, result = pcall(function() -- line: 26
		-- upvalues: TextChatService (copy)
		local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

		if ChatWindowConfiguration ~= nil then
			return ChatWindowConfiguration.Enabled
		end

		return false
	end)

	return ok and result
end
function getChatTranslationEnabled() -- line: 38
	-- upvalues: TextChatService (copy)
	local ok, result = pcall(function() -- line: 39
		-- upvalues: TextChatService (copy)
		return TextChatService.ChatTranslationEnabled
	end)

	return ok and result
end
function getChatTranslationToggleEnabled() -- line: 46
	-- upvalues: TextChatService (copy)
	local ok, result = pcall(function() -- line: 47
		-- upvalues: TextChatService (copy)
		return TextChatService.ChatTranslationToggleEnabled
	end)

	return ok and result
end
function shouldShowChatTranslationFTUX() -- line: 54
	-- upvalues: TextChatService (copy)
	if game:GetEngineFeature("TextChatServiceSettingsSaved") then
		local ok, result = pcall(function() -- line: 56
			-- upvalues: TextChatService (copy)
			return TextChatService.ChatTranslationFTUXShown
		end)

		return not (ok and result)
	end

	return true
end

local v19 = shouldShowChatTranslationFTUX()
local ChatTranslationFTUX = require(script.Parent.Parent.ChatTranslationFTUX)
local v21 = Roact.PureComponent:extend("AppContainer")

v21.defaultProps = {
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

local connection = nil

function v21.init(p1) -- line: 86
	p1:setState({
		showTranslationButton = false,
		isTextChatServiceEnabled = false
	})
end
function v21.willUnmount(_) -- line: 93
	-- upvalues: connection (ref)
	connection:Disconnect()
end
function v21.didMount(p3) -- line: 97
	-- upvalues: TextChatService (copy), connection (ref), getFFlagExpChatAlwaysRunTCS (copy)
	p3.migrationConnection = p3.props.chat:GetPropertyChangedSignal("IsAutoMigrated"):Connect(function() -- line: 98
		-- upvalues: p3 (copy)
		if p3.props.chat.IsAutoMigrated then
			p3:setState({
				isTextChatServiceEnabled = true
			})
		end
	end)

	local function onTextChatServicePropertyChanged(p4) -- line: 106
		-- upvalues: TextChatService (copy), p3 (copy)
		if p4 == "ChatTranslationEnabled" then
			local ok, result = pcall(function() -- line: 108
				-- upvalues: TextChatService (copy)
				return TextChatService.ChatTranslationEnabled
			end)

			if ok then
				p3.props.onToggleTranslation(result)
				p3:setState({
					showTranslationButton = getChatTranslationEnabled() and getChatTranslationToggleEnabled()
				})

				return
			end
		elseif p4 == "ChatTranslationToggleEnabled" then
			local ok, _ = pcall(function() -- line: 120
				-- upvalues: TextChatService (copy)
				return TextChatService.ChatTranslationToggleEnabled
			end)
			local ok2, result = pcall(function() -- line: 124
				-- upvalues: TextChatService (copy)
				return TextChatService.ChatTranslationEnabled
			end)

			if ok then
				if ok2 then
					p3.props.onToggleTranslation(result)
				end

				p3:setState({
					showTranslationButton = getChatTranslationEnabled() and getChatTranslationToggleEnabled()
				})
			end
		end
	end

	if not connection then
		connection = TextChatService.Changed:Connect(onTextChatServicePropertyChanged)
	end

	p3:setState({
		showTranslationButton = getChatTranslationEnabled() and getChatTranslationToggleEnabled(),
		isTextChatServiceEnabled = p3.props.textChatService.ChatVersion == Enum.ChatVersion.TextChatService or getFFlagExpChatAlwaysRunTCS()
	})
end
function v21.render(p5) -- line: 152
	-- upvalues: Roact (copy), BubbleChat (copy), ClientSettings (copy), AppLayout (copy), FFlagExpChatUseMessagesStore (copy), isChatRegionLocked (copy), FFlagExpChatPresetChatEnabled (copy), FFlagExpChatNewInputBar (copy), getFFlagChatTranslationShowFTUX (copy), v19 (copy), ChatTranslationFTUX (copy)
	local isTextChatServiceEnabled = p5.state.isTextChatServiceEnabled
	local v37 = Roact.createElement(BubbleChat, {
		getIconVoiceIndicator = p5.props.getIconVoiceIndicator,
		onClickedVoiceIndicator = p5.props.onClickedVoiceIndicator,
		onClickedCameraIndicator = p5.props.onClickedCameraIndicator,
		selfViewListenerChanged = p5.props.selfViewListenerChanged,
		getPermissions = p5.props.getPermissions,
		displayCameraDeniedToast = p5.props.displayCameraDeniedToast,
		isCamEnabledForUserAndPlace = p5.props.isCamEnabledForUserAndPlace,
		isCameraOnlyUser = p5.props.isCameraOnlyUser,
		isTextChatServiceOn = isTextChatServiceEnabled,
		isVoiceServiceInitialized = p5.props.isVoiceServiceInitialized
	})

	if isTextChatServiceEnabled then
		return Roact.createElement(ClientSettings.Provider, {
			value = p5.props.clientSettings
		}, {
			app = Roact.createFragment({
				appLayout = Roact.createElement(AppLayout, {
					canLocalUserChat = if not FFlagExpChatUseMessagesStore then p5.props.canLocalUserChat else nil,
					isChatInputBarVisible = not isChatRegionLocked() and p5.props.isChatInputBarVisible,
					isChatWindowVisible = p5.props.isChatWindowVisible,
					isChannelBarVisible = p5.props.isChannelBarVisible,
					chatTopBarVisibility = p5.props.chatTopBarVisibility,
					mutedUserIds = p5.props.mutedUserIds,
					onSendChat = p5.props.onSendChat,
					onSendGlobalChat = p5.props.onSendGlobalChat,
					timer = p5.props.timer,
					textTimer = p5.props.textTimer,
					activateWhisperMode = p5.props.activateWhisperMode,
					resetTargetChannel = p5.props.resetTargetChannel,
					isTextBoxFocused = p5.props.isTextBoxFocused,
					onHovered = p5.props.onHovered,
					onUnhovered = p5.props.onUnhovered,
					chatLayoutAlignment = p5.props.chatLayoutAlignment,
					chatWindowSettings = p5.props.chatWindowSettings,
					clientSettings = p5.props.clientSettings,
					selectedTabType = p5.props.selectedTabType,
					showTranslationButton = p5.state.showTranslationButton,
					isSpatialUIEnabled = p5.props.isSpatialUIEnabled,
					targetTextChannel = if not FFlagExpChatPresetChatEnabled and not FFlagExpChatNewInputBar then nil else p5.props.targetTextChannel
				}),
				bubbleChat = v37,
				ChatTranslationFTUX = if not getFFlagChatTranslationShowFTUX() or (not v19 or (not getChatTranslationEnabled() or not getChatWindowEnabled())) then nil else Roact.createElement(ChatTranslationFTUX, {})
			})
		})
	end

	return Roact.createElement(ClientSettings.Provider, {
		value = p5.props.clientSettings
	}, {
		bubbleChat = v37
	})
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v21)
