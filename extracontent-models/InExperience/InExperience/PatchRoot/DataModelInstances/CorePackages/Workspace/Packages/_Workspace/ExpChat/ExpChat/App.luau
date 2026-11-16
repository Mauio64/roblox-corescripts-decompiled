local TextChatService = game:GetService("TextChatService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Roact = require(parent.Roact)
local RoactRodux = require(parent.RoactRodux)
local ExpChatShared = require(parent.ExpChatShared)

local Localization = require(script.Parent.Localization)
local GameLocalization = require(script.Parent.GameLocalization)
local AppContainer = require(script.Parent.AppContainer)
local createStore = require(script.Parent.createStore)

local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local Constants = require(ExpChat.PresetChat.Constants)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatUniverseChatPresetEnabled = require(ExpChat.Flags.FFlagExpChatUniverseChatPresetEnabled)
local defineFastInt = game:DefineFastInt("ExpChatPresetChatLoadAnalyticsTimeoutMs", 20000)

local defineFastFlag = game:DefineFastFlag("ExpChatReconcileOnAgeVerifiedChange", false)
local ExpChatEventReceiver

if defineFastFlag then
	ExpChatEventReceiver = require(script.Parent.ExpChatEventReceiver)
else
	ExpChatEventReceiver = nil
end

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local FriendsChatEventReceiverConnector

if FFlagExpChatEnableFriendsTab then
	FriendsChatEventReceiverConnector = require(script.Parent.FriendsChatEventReceiverConnector)
else
	FriendsChatEventReceiverConnector = nil
end

local ShortcutNavReceiver = require(script.Parent.ShortcutNav.ShortcutNavReceiver)

local SocialExperiments = require(parent.SocialExperiments)
local ExpChatPresetChatEmojiTabExperimentation = SocialExperiments.ExpChatPresetChatEmojiTabExperimentation
local PresetChatEmojiTabExposureLogger

if ExpChatPresetChatEmojiTabExperimentation.isExperimentEnabled then
	PresetChatEmojiTabExposureLogger = require(script.Parent.PresetChat.PresetChatEmojiTabExposureLogger)
else
	PresetChatEmojiTabExposureLogger = nil
end

local getFFlagExpChatTelemetryEventTrigger = require(ExpChat.Flags.getFFlagExpChatTelemetryEventTrigger)

local function computePresetBitmap(allTextChannels)
	local presetChatStore = GetPresetChatStore(false)

	if not presetChatStore.getIsEnabled() or presetChatStore.getAccessLevel() ~= Constants.AccessLevel.Enabled then
		return 0
	end

	local v = 0

	for k in pairs(allTextChannels) do
		if k == "RBXSystem" then
			continue
		end

		if k == "RBXGeneral" then
			v = bit32.bor(v, 1)
		else
			v = bit32.bor(v, 4)
		end
	end

	if FFlagExpChatUniverseChatPresetEnabled and TextChatService:HasAllocatedUniverseChatContext("global") then
		return (bit32.bor(v, 2))
	end

	return v
end

local extended = Roact.Component:extend("App")

extended.defaultProps = {
	isChatWindowVisible = true,
	isChatInputBarVisible = true,
	isChannelBarVisible = false,
	isDefaultChatEnabled = true,
	isSpatialUIEnabled = false,
	store = createStore(),
	translator = {
		FormatByKey = function(_, p)
			return (tostring(p))
		end
	},
	gameTranslator = {
		TranslateGameText = function(_, _, p)
			return p
		end
	}
}

function extended.render(p)
	local isDefaultChatEnabled = p.props.isDefaultChatEnabled

	if not isDefaultChatEnabled then
		return isDefaultChatEnabled
	end

	local createElement = Roact.createElement
	local storeProvider = RoactRodux.StoreProvider
	local v = { store = p.props.store }

	local createElement2 = Roact.createElement
	local provider = Localization.Provider
	local v2 = { value = p.props.translator }

	local createElement3 = Roact.createElement
	local provider2 = GameLocalization.Provider
	local v3 = { value = p.props.gameTranslator }
	local eventReceiver

	if defineFastFlag then
		eventReceiver = Roact.createElement(ExpChatEventReceiver)
	end

	local friendsChatEventReceiver

	if FFlagExpChatEnableFriendsTab then
		friendsChatEventReceiver = Roact.createElement(FriendsChatEventReceiverConnector)
	end

	local shortcutNavReceiver

	if FFlagExpChatEnableFriendsTab then
		shortcutNavReceiver = Roact.createElement(ShortcutNavReceiver)
	end

	local presetChatEmojiTabExposureLogger

	if ExpChatPresetChatEmojiTabExperimentation.isExperimentEnabled then
		presetChatEmojiTabExposureLogger = Roact.createElement(PresetChatEmojiTabExposureLogger)
	end

	return (createElement(storeProvider, v, {
		localization = createElement2(provider, v2, {
			gameLocalization = createElement3(provider2, v3, {
				eventReceiver = eventReceiver,
				friendsChatEventReceiver = friendsChatEventReceiver,
				shortcutNavReceiver = shortcutNavReceiver,
				presetChatEmojiTabExposureLogger = presetChatEmojiTabExposureLogger,
				container = Roact.createElement(AppContainer, {
					isChatInputBarVisible = p.props.isChatInputBarVisible,
					isChatWindowVisible = p.props.isChatWindowVisible,
					isChannelBarVisible = p.props.isChannelBarVisible,
					getIconVoiceIndicator = p.props.getIconVoiceIndicator,
					onClickedVoiceIndicator = p.props.onClickedVoiceIndicator,
					onClickedCameraIndicator = p.props.onClickedCameraIndicator,
					selfViewListenerChanged = p.props.selfViewListenerChanged,
					getPermissions = p.props.getPermissions,
					displayCameraDeniedToast = p.props.displayCameraDeniedToast,
					isCamEnabledForUserAndPlace = p.props.isCamEnabledForUserAndPlace,
					isCameraOnlyUser = p.props.isCameraOnlyUser,
					isVoiceServiceInitialized = p.props.isVoiceServiceInitialized,
					isSpatialUIEnabled = p.props.isSpatialUIEnabled
				})
			})
		})
	}))
end

if getFFlagExpChatTelemetryEventTrigger() then
	function extended.didMount(p)
		local expChatLoadStartTime = p.props.expChatLoadStartTime

		if expChatLoadStartTime then
			if FFlagExpChatPresetChatEnabled then
				local v = os.clock() - expChatLoadStartTime
				local presetChatStore = GetPresetChatStore(false)
				task.spawn(function()
					local lastTime = os.clock()

					while presetChatStore.getIsLoading() and os.clock() - lastTime < defineFastInt / 1000 do
						task.wait()
					end

					local state = p.props.store:getState()
					TextChatService:SendExpChatLoadSuccess(v, {
						preset_bitmap = computePresetBitmap(state.TextChannels and state.TextChannels.allTextChannels or {})
					})
				end)
			else
				TextChatService:SendExpChatLoadSuccess(os.clock() - expChatLoadStartTime)
			end
		end
	end
end

return extended
