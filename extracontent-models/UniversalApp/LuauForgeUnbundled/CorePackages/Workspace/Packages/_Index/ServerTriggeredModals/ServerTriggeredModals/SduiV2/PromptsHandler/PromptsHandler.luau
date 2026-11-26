local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/React")
local AppNavBar = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/AppNavBar")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/Foundation")
local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/CentralOverlay")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RobloxAppEnums")
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/LocalUserIdStore").LocalUserIdStore
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SignalsReact")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SduiSharedUtilities")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags")

local fFlagPushNotificationsUpsellPassClientAttributesToPrompts = SharedFlags.FFlagPushNotificationsUpsellPassClientAttributesToPrompts
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RoactUtils").Hooks.RoactRodux.useDispatch
local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RoactUtils").Hooks.RoactRodux.useStore

local centralOverlayType = RobloxAppEnums.CentralOverlayType
local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local sduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local sduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local view = Foundation.View

local Logger = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Logger")
local reportPromptImpression = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/reportPromptImpression")
local logPromptModalSkipped = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/logPromptModalSkipped")
local sendModalImpressionEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/ServerTriggeredModalImpressions").sendModalImpressionEvent
local fetchPrompts = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/fetchPrompts")
local PromptsEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsEntryPoint")
local PromptStyle = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptStyle")
local usePromptEntries = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/usePromptEntries")
local useModalSignalStore = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SignalStores/useModalSignalStore")
local FFlagPromptsActionEventLogging = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Flags/FFlagPromptsActionEventLogging")
local FFlagPromptsModalSkipTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Flags/FFlagPromptsModalSkipTelemetry")
local FFlagPlusUpsellSheetHomePrompt = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Flags/FFlagPlusUpsellSheetHomePrompt")

local v5 = if FFlagPlusUpsellSheetHomePrompt then require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PlusUpsellSheetPrompt") else nil

local getEntryPointSurfaceConfig = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsHandler/getEntryPointSurfaceConfig")
local getHomepagePromptsClientAttributes = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/getHomepagePromptsClientAttributes")
local CoachmarkRenderer = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsHandler/CoachmarkRenderer")
local module23 = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsHandler/SurfaceBanner")

local fFlagSduiAllowNoConfigsBuilt = SharedFlags.FFlagSduiAllowNoConfigsBuilt
local fFlagPromptsImpressionUsesTitle = SharedFlags.FFlagPromptsImpressionUsesTitle
local fFlagPromptsHandlerCoachmarkEnabled = SharedFlags.FFlagPromptsHandlerCoachmarkEnabled
local fFlagEdpGameLeavePromptsHandlerEnabled = SharedFlags.FFlagEdpGameLeavePromptsHandlerEnabled
local fFlagEdpOpenPromptsHandlerEnabled = SharedFlags.FFlagEdpOpenPromptsHandlerEnabled
local fFlagNotificationStreamPromptsHandlerEnabled = SharedFlags.FFlagNotificationStreamPromptsHandlerEnabled
local fFlagSduiSystemBannerComponent = SharedFlags.FFlagSduiSystemBannerComponent
local fFlagSduiSurfaceBannerScrollAwaySticky = SharedFlags.FFlagSduiSurfaceBannerScrollAwaySticky
local fFlagSduiSurfaceBannerAlwaysMounted = SharedFlags.FFlagSduiSurfaceBannerAlwaysMounted
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagSduiDismissPromptAction = SharedFlags.FFlagSduiDismissPromptAction
local fFlagHomepagePromptsPaddingFix = SharedFlags.FFlagHomepagePromptsPaddingFix
local fFlagHomepagePromptsHandlerPassClientAttributes = SharedFlags.FFlagHomepagePromptsHandlerPassClientAttributes
local fFlagPromptsEdpOpenReplaceOnFetch = SharedFlags.FFlagPromptsEdpOpenReplaceOnFetch
local fFlagPromptsHandlerFetchOncePerSession = SharedFlags.FFlagPromptsHandlerFetchOncePerSession
local fIntPromptsHandlerSessionTimeoutMs = SharedFlags.FIntPromptsHandlerSessionTimeoutMs
local fFlagChatPushUpsellPromptsEnabled = SharedFlags.FFlagChatPushUpsellPromptsEnabled

local v6 = {}

local currentUserIds = {}

local function parsePromptStyles(fStringHomePromptsHandlerPromptStyles)
	local result = {}

	for k in string.gmatch(fStringHomePromptsHandlerPromptStyles, "[^,%s]+") do
		table.insert(result, k)
	end

	if #result == 0 then
		return nil
	end

	return result
end

local function claimAppSessionRequest(p2, p3): boolean
	if not fFlagChatPushUpsellPromptsEnabled or p2 ~= PromptsEntryPoint.ChatLandingOpen then
		return true
	end

	local currentUserId = localUserIdStore.getCurrentUserId(false)

	if currentUserIds[p3] == currentUserId then
		return false
	end

	currentUserIds[p3] = currentUserId
	return true
end

local function forwardsClientAttributes(p2)
	if fFlagEdpGameLeavePromptsHandlerEnabled or fFlagEdpOpenPromptsHandlerEnabled then
		return true
	end

	return fFlagChatPushUpsellPromptsEnabled and p2 == PromptsEntryPoint.ChatLandingOpen
end

local function getHomepagePromptStyles(p2)
	if p2 == PromptsEntryPoint.HomepageLaunch then
		return parsePromptStyles(SharedFlags.FStringHomePromptsHandlerPromptStyles)
	end

	return nil
end

local function PromptsHandler(props)
	local entryPoint = props.entryPoint

	local v7 = fFlagNotificationStreamPromptsHandlerEnabled
		and entryPoint == PromptsEntryPoint.NotificationStreamOpen
	local promptStyle = props.promptStyle

	local fFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagHomePromptsHandlerRestrictPromptStyles
		and SharedFlags.FFlagLuaAppEnableSduiHomePage
	local v8 = useDispatch()
	local v9 = if fFlagSduiDismissPromptAction then useStore() else nil
	local v10 = useModalSignalStore()
	local universeId

	if
		(fFlagEdpGameLeavePromptsHandlerEnabled or fFlagEdpOpenPromptsHandlerEnabled)
		and props.clientAttributes ~= nil
	then
		universeId = props.clientAttributes.universeId
	else
		universeId = nil
	end

	local replaceOnFetch = if fFlagPromptsEdpOpenReplaceOnFetch then props.replaceOnFetch else nil
	local v11

	if fFlagPushNotificationsUpsellPassClientAttributesToPrompts then
		v11 = getHomepagePromptsClientAttributes.use(entryPoint, props.clientAttributes)
	else
		v11 = nil
	end

	local v12 = React.useMemo(function()
		if fFlagEdpGameLeavePromptsHandlerEnabled or fFlagEdpOpenPromptsHandlerEnabled then
			return getEntryPointSurfaceConfig(entryPoint, universeId)
		end

		return getEntryPointSurfaceConfig(entryPoint)
	end, (fFlagEdpGameLeavePromptsHandlerEnabled or fFlagEdpOpenPromptsHandlerEnabled) and {
		entryPoint,
		universeId
	} or { entryPoint })

	local v13 = SignalsReact.useSignalState(v10.getHasShownGetter(entryPoint))
	local v14 = SignalsReact.useSignalState(v10.getMetadataGetter(entryPoint))

	local v15 = nil
	local v16

	if fFlagHomepagePromptsHandlerPassClientAttributes then
		v15 = React.useMemo(function()
			if v7 then
				return props.clientAttributes
			end

			if
				fFlagPushNotificationsUpsellPassClientAttributesToPrompts
				and entryPoint == PromptsEntryPoint.HomepageLaunch
				and (not (fFlagEdpGameLeavePromptsHandlerEnabled or fFlagEdpOpenPromptsHandlerEnabled) or props.clientAttributes == nil)
			then
				return v11
			end

			if
				(fFlagEdpGameLeavePromptsHandlerEnabled or fFlagEdpOpenPromptsHandlerEnabled or fFlagChatPushUpsellPromptsEnabled and entryPoint == PromptsEntryPoint.ChatLandingOpen)
				and props.clientAttributes ~= nil
			then
				return props.clientAttributes
			end

			if entryPoint == PromptsEntryPoint.HomepageLaunch then
				return getHomepagePromptsClientAttributes.get()
			end

			return nil
		end, { entryPoint, v11, props.clientAttributes, v7 })

		local useMemo = React.useMemo
		local function fn()
			local v17 = {
				entryPoint = entryPoint,
				surfaceKey = v12.surfaceKey,
				configKey = v12.configKey,
				clearOnEmptyResponse = true,
				allowNoConfigsBuilt = fFlagSduiAllowNoConfigsBuilt and true or nil,
				loadTimer = sduiLoadTimer.createLoadTimer(v12.configKey),
				clientAttributes = v15,
				replaceOnFetch = if fFlagPromptsEdpOpenReplaceOnFetch then replaceOnFetch else nil,
				promptStyles = 0
			}
			local v19 = if fFlagLuaAppEnableSduiHomePage and entryPoint == PromptsEntryPoint.HomepageLaunch then parsePromptStyles(SharedFlags.FStringHomePromptsHandlerPromptStyles) else nil

			v17.promptStyles = v19
			return v17
		end

		v16 = useMemo(fn, {
			entryPoint,
			v12,
			v15,
			fFlagLuaAppEnableSduiHomePage,
			if fFlagPromptsEdpOpenReplaceOnFetch then replaceOnFetch else nil
		})
	else
		local useMemo = React.useMemo
		local function fn()
			local v17 = {
				entryPoint = entryPoint,
				surfaceKey = v12.surfaceKey,
				configKey = v12.configKey,
				clearOnEmptyResponse = true,
				allowNoConfigsBuilt = fFlagSduiAllowNoConfigsBuilt and true or nil,
				loadTimer = sduiLoadTimer.createLoadTimer(v12.configKey),
				clientAttributes = 0,
				replaceOnFetch = 0,
				promptStyles = 0
			}
			local v19 = if (fFlagEdpGameLeavePromptsHandlerEnabled or fFlagEdpOpenPromptsHandlerEnabled) and true or fFlagChatPushUpsellPromptsEnabled and entryPoint == PromptsEntryPoint.ChatLandingOpen or v7 then props.clientAttributes else nil
			v17.clientAttributes = v19

			v17.replaceOnFetch = if fFlagPromptsEdpOpenReplaceOnFetch then replaceOnFetch else nil
			local v21 = if fFlagLuaAppEnableSduiHomePage and entryPoint == PromptsEntryPoint.HomepageLaunch then parsePromptStyles(SharedFlags.FStringHomePromptsHandlerPromptStyles) else nil

			v17.promptStyles = v21
			return v17
		end

		local v17

		if
			fFlagEdpGameLeavePromptsHandlerEnabled
			or fFlagEdpOpenPromptsHandlerEnabled
			or fFlagChatPushUpsellPromptsEnabled
			or fFlagNotificationStreamPromptsHandlerEnabled
		then
			v17 = { nil, nil, nil, nil, nil, nil }

			v17[1], v17[2], v17[3], v17[4], v17[5], v17[6] = entryPoint, v12, props.clientAttributes, fFlagLuaAppEnableSduiHomePage, if fFlagPromptsEdpOpenReplaceOnFetch then replaceOnFetch else nil, v7
		else
			v17 = { nil, nil, nil, nil }

			v17[1], v17[2], v17[3], v17[4] = entryPoint, v12, fFlagLuaAppEnableSduiHomePage, if fFlagPromptsEdpOpenReplaceOnFetch then replaceOnFetch else nil
		end

		v16 = useMemo(fn, v17)
	end

	local ref = React.useRef(os.clock() + fIntPromptsHandlerSessionTimeoutMs / 1000)

	if fFlagPushNotificationsUpsellPassClientAttributesToPrompts then
		React.useEffect(function()
			local v17

			if entryPoint == PromptsEntryPoint.HomepageLaunch then
				v17 = not (fFlagEdpGameLeavePromptsHandlerEnabled or fFlagEdpOpenPromptsHandlerEnabled)
					or props.clientAttributes == nil
			else
				v17 = false
			end

			local sessionClientAttribute = if v17 then getHomepagePromptsClientAttributes.sessionClientAttribute else nil

			if
				v17
				and v15 == nil
				and (not fFlagPromptsHandlerFetchOncePerSession or sessionClientAttribute == nil)
			then
				return
			end

			if fFlagPromptsHandlerFetchOncePerSession and sessionClientAttribute ~= nil then
				local configKey = v16.configKey

				local v18 = if v15 then v15[sessionClientAttribute] else nil

				if v18 == nil then
					if v6[configKey] ~= nil then
						return
					end

					local thread = task.delay(math.max(0, ref.current - os.clock()), function()
						if v6[configKey] == nil then
							v6[configKey] = false
							fetchPrompts(v16, true)
						end
					end)
					return function()
						task.cancel(thread)
					end
				end

				if v6[configKey] == false then
					v6[configKey] = v18
					return
				end

				if v6[configKey] == v18 then
					return
				end

				v6[configKey] = v18
				fetchPrompts(v16, true)
			else
				local configKey = v16.configKey
				local v19

				if fFlagChatPushUpsellPromptsEnabled and entryPoint == PromptsEntryPoint.ChatLandingOpen then
					local currentUserId = localUserIdStore.getCurrentUserId(false)

					if currentUserIds[configKey] == currentUserId then
						v19 = false
					else
						currentUserIds[configKey] = currentUserId
						v19 = true
					end
				else
					v19 = true
				end

				if not v19 then
					return
				end

				local v20

				if fFlagEdpOpenPromptsHandlerEnabled then
					v20 = v17 or entryPoint == PromptsEntryPoint.ExperienceDetailsPageOpen
				end

				if
					v7
					or not fFlagEdpOpenPromptsHandlerEnabled and v17
					or fFlagEdpOpenPromptsHandlerEnabled and v20
				then
					fetchPrompts(v16, true)
				else
					fetchPrompts(v16)
				end
			end
		end, { entryPoint, v16, props.clientAttributes, v15, v7 })
	else
		local function fn()
			local configKey = v16.configKey
			local v18

			if fFlagChatPushUpsellPromptsEnabled and entryPoint == PromptsEntryPoint.ChatLandingOpen then
				local currentUserId = localUserIdStore.getCurrentUserId(false)

				if currentUserIds[configKey] == currentUserId then
					v18 = false
				else
					currentUserIds[configKey] = currentUserId
					v18 = true
				end
			else
				v18 = true
			end

			if not v18 then
				return
			end

			local v19 = if fFlagEdpOpenPromptsHandlerEnabled then entryPoint == PromptsEntryPoint.ExperienceDetailsPageOpen else nil

			fetchPrompts(v16, (v7 or fFlagEdpOpenPromptsHandlerEnabled and v19) and true or nil)
		end

		local v19 = if fFlagEdpOpenPromptsHandlerEnabled or fFlagChatPushUpsellPromptsEnabled then entryPoint else nil
		React.useEffect(fn, { v16, v19, v7 })
	end

	local v17 = usePromptEntries(v12.configKey, PromptStyle.Modal)
	local v18 = v17[1]

	local ref2 = if fFlagSduiDismissPromptAction then React.useRef(nil) else nil
	local ref3 = if fFlagSduiDismissPromptAction then React.useRef(nil) else nil

	local function fn()
		if v13 then
			if FFlagPromptsModalSkipTelemetry then
				logPromptModalSkipped.logAll(logPromptModalSkipped.Reason.AlreadyShown, entryPoint, v17)
			end
		elseif v14 then
			if FFlagPromptsModalSkipTelemetry then
				logPromptModalSkipped.logAll(logPromptModalSkipped.Reason.LegacyMetadata, entryPoint, v17)
			end
		elseif
			v18 == nil
			or v18.config == nil
			or v18.identifier == nil
			or v18.robloxComponentType == nil
			or v18.title == nil
		then
			if FFlagPromptsModalSkipTelemetry and v18 ~= nil then
				logPromptModalSkipped.log(logPromptModalSkipped.Reason.IncompleteEntry, entryPoint, v18)
			end
		else
			v10.setHasShown(entryPoint, true)

			if FFlagPromptsModalSkipTelemetry then
				logPromptModalSkipped.markShown(entryPoint, v18)
			end

			local sduiPromptModal = centralOverlayType.SduiPromptModal
			local v21 = {
				configKey = v12.configKey,
				appPage = v12.appPage,
				modalId = v18.identifier,
				modalType = 0
			}

			local v22 = if fFlagPromptsImpressionUsesTitle then v18.title else v18.robloxComponentType
			v21.modalType = v22
			v8(setCentralOverlay(sduiPromptModal, v21))

			if fFlagSduiDismissPromptAction then
				ref2.current = v18.title
				ref3.current = v18.identifier
			end
		end
	end

	React.useEffect(fn, {
		v13,
		v14,
		v8,
		v10,
		v18,
		v12,
		entryPoint,
		if FFlagPromptsModalSkipTelemetry then v17 else nil
	})

	if fFlagSduiDismissPromptAction then
		React.useEffect(function()
			local current = ref2.current

			if current == nil then
				return
			end

			for k, v21 in v17 do
				if v21.title == current then
					return
				end
			end

			local current2 = ref3.current
			ref2.current = nil
			ref3.current = nil
			local centralOverlay = v9:getState().CentralOverlay

			if
				centralOverlay ~= nil
				and centralOverlay.OverlayType == centralOverlayType.SduiPromptModal
				and centralOverlay.Arguments ~= nil
				and centralOverlay.Arguments.modalId == current2
			then
				v8(setCentralOverlay())
			end
		end, { v17, v8, v9 })
	end

	if FFlagPlusUpsellSheetHomePrompt then
		v5.usePlusUpsellSheetPrompt({
			entryPoint = entryPoint,
			hasShownKey = entryPoint,
			modalSignalStore = v10
		})
	end

	local v21 = promptStyle == PromptStyle.SurfaceBanner
	local v22 = usePromptEntries(v12.configKey, PromptStyle.SurfaceBanner)
	local v23 = if v21 then v22[1] else nil
	local identifier = if v23 then v23.identifier or nil else nil
	local v24

	if v23 then
		v24 = if fFlagPromptsImpressionUsesTitle then v23.title else v23.robloxComponentType
	else
		v24 = nil
	end

	local v25 = promptStyle == PromptStyle.InlineBanner
	local v26 = usePromptEntries(v12.configKey, PromptStyle.InlineBanner)
	local v27 = if v25 then v26[1] else nil
	local identifier2 = if v27 then v27.identifier or nil else nil
	local v28

	if v27 then
		v28 = if fFlagPromptsImpressionUsesTitle then v27.title else v27.robloxComponentType
	else
		v28 = nil
	end

	React.useEffect(function()
		if identifier and v24 then
			reportPromptImpression(v24, identifier):catch(function()
				Logger:warning("Failed to report prompt impression")
			end)
			sendModalImpressionEvent(identifier, v24)
		end
	end, { identifier, v24 })

	React.useEffect(function()
		if identifier2 and v28 then
			reportPromptImpression(v28, identifier2):catch(function()
				Logger:warning("Failed to report prompt impression")
			end)
			sendModalImpressionEvent(identifier2, v28)
		end
	end, { identifier2, v28 })

	local v29 = false

	if fFlagPromptsHandlerCoachmarkEnabled then
		local v30 = usePromptEntries(v12.configKey, PromptStyle.Coachmark)

		for k, v32 in v30 do
			if v32.config and v32.identifier and v32.title then
				v29 = true
				break
			end
		end
	end

	local v30 = fFlagSduiSurfaceBannerScrollAwaySticky
		and fFlagAppIaScrollAway
		and AppNavBar.getScrollAwayEnabled()
	local v31 = v23 ~= nil or fFlagSduiSurfaceBannerAlwaysMounted
	local v32 = nil

	if v21 then
		if fFlagSduiSystemBannerComponent and v31 and v30 then
			local createElement = React.createElement
			local v35 = if v23 then v23.identifier else nil
			v32 = createElement(module23, {
				identifier = v35,
				configKey = v12.configKey,
				appPage = v12.appPage,
				surfaceBannerContent = props.surfaceBannerContent
			})
		elseif fFlagSduiSystemBannerComponent and v31 then
			local createElement = React.createElement
			local v34 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

			local v35 = {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				SurfaceBanner = 0,
				ContentContainer = 0
			}
			local v36

			if v23 then
				local createElement2 = React.createElement
				local v38 = {
					configKey = v12.configKey,
					identifier = v23.identifier,
					appPage = v12.appPage,
					additionalAnalyticsData = 0,
					shouldDisplayLoading = false,
					shouldDisplayError = false,
					LayoutOrder = 1
				}
				local v39

				if FFlagPromptsActionEventLogging then
					v39 = { promptInstanceId = 0 }
					local v40 = if v23.identifier then v23.identifier else nil
					v39.promptInstanceId = v40
				end

				v38.additionalAnalyticsData = v39
				v36 = createElement2(sduiFeatureEntryPoint, v38)
			end

			v35.SurfaceBanner = v36

			v35.ContentContainer = React.createElement(
				"Frame",
				{
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1
				},
				{
					UIFlexItem = React.createElement("UIFlexItem", {
						FlexMode = Enum.UIFlexMode.Fill
					}),
					Content = props.surfaceBannerContent
				}
			)
			v32 = createElement("Frame", v34, v35)
		else
			v32 = props.surfaceBannerContent
		end
	elseif v25 then
		if v27 then
			local createElement = React.createElement
			local v34 = {
				configKey = v12.configKey,
				identifier = v27.identifier,
				appPage = v12.appPage,
				additionalAnalyticsData = 0,
				shouldDisplayLoading = false,
				shouldDisplayError = false
			}
			local v35

			if FFlagPromptsActionEventLogging then
				v35 = { promptInstanceId = 0 }
				local v36 = if v27.identifier then v27.identifier else nil
				v35.promptInstanceId = v36
			end

			v34.additionalAnalyticsData = v35
			v32 = createElement(sduiFeatureEntryPoint, v34)
		else
			v32 = props.inlineBannerFallback
		end
	end

	if (fFlagHomepagePromptsPaddingFix or v7) and v25 then
		local v33 = v22[1] ~= nil

		if v32 ~= nil then
			local v34 = v33 and props.topPadding ~= nil
			local v35 = props.bottomPadding ~= nil
			local createElement = React.createElement
			local v37 = {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				padding = 0
			}

			local v39 = if v34 then UDim.new(0, props.topPadding) else nil
			local v40 = if v35 then UDim.new(0, props.bottomPadding) else nil
			v37.padding = { top = v39, bottom = v40 }
			v32 = createElement(view, v37, { InlineBanner = v32 })
		elseif v33 and props.topPadding then
			v32 = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, props.topPadding),
				BackgroundTransparency = 1
			})
		end
	end

	if fFlagPromptsHandlerCoachmarkEnabled and v29 then
		return React.createElement(React.Fragment, nil, {
			Slot = v32,
			Coachmarks = React.createElement(CoachmarkRenderer, {
				surfaceConfig = v12,
				hasShownKey = entryPoint
			})
		})
	end

	return v32
end

local memo = React.memo(PromptsHandler)
function memo.resetFetchedSessionsForTests()
	table.clear(v6)
	table.clear(currentUserIds)
end
return memo
