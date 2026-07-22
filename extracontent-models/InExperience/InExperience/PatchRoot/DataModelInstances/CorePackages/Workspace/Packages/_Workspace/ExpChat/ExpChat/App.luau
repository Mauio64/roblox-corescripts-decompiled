local TextChatService = game:GetService("TextChatService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Roact = require(ExpChatParent.Roact)
local RoactRodux = require(ExpChatParent.RoactRodux)
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Localization = require(script.Parent.Localization)
local GameLocalization = require(script.Parent.GameLocalization)
local AppContainer = require(script.Parent.AppContainer)
local createStore = require(script.Parent.createStore)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local Constants = require(ExpChat.PresetChat.Constants)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatUniverseChatPresetEnabled = require(ExpChat.Flags.FFlagExpChatUniverseChatPresetEnabled)
local v15 = game:DefineFastInt("ExpChatPresetChatLoadAnalyticsTimeoutMs", 20000)
local v16 = game:DefineFastFlag("ExpChatReconcileOnAgeVerifiedChange", false)
local v17 = if not v16 then nil else require(script.Parent.ExpChatEventReceiver)
local FFlagExpChatEnableFriendsTab = require(ExpChatParent.SharedFlags).FFlagExpChatEnableFriendsTab
local v19 = if not FFlagExpChatEnableFriendsTab then nil else require(script.Parent.FriendsChatEventReceiverConnector)
local getFFlagExpChatTelemetryEventTrigger = require(ExpChat.Flags.getFFlagExpChatTelemetryEventTrigger)

local function computePresetBitmap(p1) -- line: 36
	-- upvalues: GetPresetChatStore (copy), Constants (copy), FFlagExpChatUniverseChatPresetEnabled (copy), TextChatService (copy)
	local v25 = GetPresetChatStore(false)

	if not v25.getIsEnabled() or v25.getAccessLevel() ~= Constants.AccessLevel.Enabled then
		return 0
	end

	local n1 = 0

	for k in pairs(p1) do
		if k ~= "RBXSystem" then
			n1 = if k ~= "RBXGeneral" then bit32.bor(n1, 4) else bit32.bor(n1, 1)
		end
	end

	if FFlagExpChatUniverseChatPresetEnabled and TextChatService:HasAllocatedUniverseChatContext("global") then
		n1 = bit32.bor(n1, 2)
	end

	return n1
end

local v22 = Roact.Component:extend("App")
local v23 = createStore()

v22.defaultProps = {
	isChatWindowVisible = true,
	isChatInputBarVisible = true,
	isChannelBarVisible = false,
	isDefaultChatEnabled = true,
	isSpatialUIEnabled = false,
	store = v23,
	translator = {
		FormatByKey = function(_, p3) -- line: 77
			return (tostring(p3))
		end
	},
	gameTranslator = {
		TranslateGameText = function(_, _, p6) -- line: 82
			return p6
		end
	}
}

function v22.render(p7) -- line: 87
	-- upvalues: Roact (copy), RoactRodux (copy), Localization (copy), GameLocalization (copy), v16 (copy), v17 (copy), FFlagExpChatEnableFriendsTab (copy), v19 (copy), AppContainer (copy)
	return p7.props.isDefaultChatEnabled and Roact.createElement(RoactRodux.StoreProvider, {
		store = p7.props.store
	}, {
		localization = Roact.createElement(Localization.Provider, {
			value = p7.props.translator
		}, {
			gameLocalization = Roact.createElement(GameLocalization.Provider, {
				value = p7.props.gameTranslator
			}, {
				eventReceiver = if not v16 then nil else Roact.createElement(v17),
				friendsChatEventReceiver = if not FFlagExpChatEnableFriendsTab then nil else Roact.createElement(v19),
				container = Roact.createElement(AppContainer, {
					isChatInputBarVisible = p7.props.isChatInputBarVisible,
					isChatWindowVisible = p7.props.isChatWindowVisible,
					isChannelBarVisible = p7.props.isChannelBarVisible,
					getIconVoiceIndicator = p7.props.getIconVoiceIndicator,
					onClickedVoiceIndicator = p7.props.onClickedVoiceIndicator,
					onClickedCameraIndicator = p7.props.onClickedCameraIndicator,
					selfViewListenerChanged = p7.props.selfViewListenerChanged,
					getPermissions = p7.props.getPermissions,
					displayCameraDeniedToast = p7.props.displayCameraDeniedToast,
					isCamEnabledForUserAndPlace = p7.props.isCamEnabledForUserAndPlace,
					isCameraOnlyUser = p7.props.isCameraOnlyUser,
					isVoiceServiceInitialized = p7.props.isVoiceServiceInitialized,
					isSpatialUIEnabled = p7.props.isSpatialUIEnabled
				})
			})
		})
	})
end

if getFFlagExpChatTelemetryEventTrigger() then
	function v22.didMount(p8) -- line: 125
		-- upvalues: FFlagExpChatPresetChatEnabled (copy), GetPresetChatStore (copy), v15 (copy), TextChatService (copy), computePresetBitmap (copy)
		local expChatLoadStartTime = p8.props.expChatLoadStartTime

		if expChatLoadStartTime then
			if FFlagExpChatPresetChatEnabled then
				local v36 = os.clock() - expChatLoadStartTime
				local v37 = GetPresetChatStore(false)

				task.spawn(function() -- line: 134
					-- upvalues: v37 (copy), v15 (copy), p8 (copy), TextChatService (copy), v36 (copy), computePresetBitmap (copy)
					local elapsed = os.clock()

					while v37.getIsLoading() and os.clock() - elapsed < v15 / 1000 do
						task.wait()
					end

					local v39 = p8.props.store:getState()
					local v40 = v39.TextChannels and v39.TextChannels.allTextChannels or {}

					TextChatService:SendExpChatLoadSuccess(v36, {
						preset_bitmap = computePresetBitmap(v40)
					})
				end)

				return
			end

			TextChatService:SendExpChatLoadSuccess(os.clock() - expChatLoadStartTime)
		end
	end
end

return v22
