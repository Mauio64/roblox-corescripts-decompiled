local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local parent = ServerTriggeredModals.Parent

local React = require(parent.React)
local AppNavBar = require(parent.AppNavBar)
local Foundation = require(parent.Foundation)
local CentralOverlay = require(parent.CentralOverlay)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore
local SignalsReact = require(parent.SignalsReact)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SharedFlags = require(parent.SharedFlags)

local FFlagPushNotificationsUpsellPassClientAttributesToPrompts = SharedFlags.FFlagPushNotificationsUpsellPassClientAttributesToPrompts
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useStore = RoactUtils2.Hooks.RoactRodux.useStore

local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local View = Foundation.View

local Logger = require(ServerTriggeredModals.Logger)
local reportPromptImpression = require(ServerTriggeredModals.reportPromptImpression)
local logPromptModalSkipped = require(ServerTriggeredModals.logPromptModalSkipped)
local ServerTriggeredModalImpressions = require(parent.ServerTriggeredModalImpressions)
local sendModalImpressionEvent = ServerTriggeredModalImpressions.sendModalImpressionEvent
local fetchPrompts = require(ServerTriggeredModals.SduiV2.fetchPrompts)
local PromptsEntryPoint = require(ServerTriggeredModals.SduiV2.PromptsEntryPoint)
local PromptStyle = require(ServerTriggeredModals.SduiV2.PromptStyle)
local usePromptEntries = require(ServerTriggeredModals.SduiV2.usePromptEntries)
local useModalSignalStore = require(ServerTriggeredModals.SignalStores.useModalSignalStore)
local FFlagPromptsActionEventLogging = require(ServerTriggeredModals.Flags.FFlagPromptsActionEventLogging)
local FFlagPromptsModalSkipTelemetry = require(ServerTriggeredModals.Flags.FFlagPromptsModalSkipTelemetry)
local FFlagPlusUpsellSheetHomePrompt = require(ServerTriggeredModals.Flags.FFlagPlusUpsellSheetHomePrompt)
local PlusUpsellSheetPrompt

if FFlagPlusUpsellSheetHomePrompt then
	PlusUpsellSheetPrompt = require(script.Parent.Parent.PlusUpsellSheetPrompt)
else
	PlusUpsellSheetPrompt = nil
end

local getEntryPointSurfaceConfig = require(script.Parent.getEntryPointSurfaceConfig)
local getHomepagePromptsClientAttributes = require(script.Parent.Parent.getHomepagePromptsClientAttributes)
local CoachmarkRenderer = require(script.Parent.CoachmarkRenderer)
local SurfaceBanner = require(script.Parent.SurfaceBanner)

local FFlagSduiAllowNoConfigsBuilt = SharedFlags.FFlagSduiAllowNoConfigsBuilt
local FFlagPromptsImpressionUsesTitle = SharedFlags.FFlagPromptsImpressionUsesTitle
local FFlagPromptsHandlerCoachmarkEnabled = SharedFlags.FFlagPromptsHandlerCoachmarkEnabled
local FFlagEdpGameLeavePromptsHandlerEnabled = SharedFlags.FFlagEdpGameLeavePromptsHandlerEnabled
local FFlagEdpOpenPromptsHandlerEnabled = SharedFlags.FFlagEdpOpenPromptsHandlerEnabled
local FFlagNotificationStreamPromptsHandlerEnabled = SharedFlags.FFlagNotificationStreamPromptsHandlerEnabled
local FFlagSduiSystemBannerComponent = SharedFlags.FFlagSduiSystemBannerComponent
local FFlagSduiSurfaceBannerScrollAwaySticky = SharedFlags.FFlagSduiSurfaceBannerScrollAwaySticky
local FFlagSduiSurfaceBannerAlwaysMounted = SharedFlags.FFlagSduiSurfaceBannerAlwaysMounted
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagSduiDismissPromptAction = SharedFlags.FFlagSduiDismissPromptAction
local FFlagHomepagePromptsPaddingFix = SharedFlags.FFlagHomepagePromptsPaddingFix
local FFlagHomepagePromptsHandlerPassClientAttributes = SharedFlags.FFlagHomepagePromptsHandlerPassClientAttributes
local FFlagPromptsEdpOpenReplaceOnFetch = SharedFlags.FFlagPromptsEdpOpenReplaceOnFetch
local FFlagPromptsHandlerFetchOncePerSession = SharedFlags.FFlagPromptsHandlerFetchOncePerSession
local FIntPromptsHandlerSessionTimeoutMs = SharedFlags.FIntPromptsHandlerSessionTimeoutMs
local FFlagChatPushUpsellPromptsEnabled = SharedFlags.FFlagChatPushUpsellPromptsEnabled

local v = {}

local currentUserIds = {}

local function parsePromptStyles(fStringHomePromptsHandlerPromptStyles: string)
	local result = {}

	for k in string.gmatch(fStringHomePromptsHandlerPromptStyles, "[^,%s]+") do
		table.insert(result, k)
	end

	return if #result ~= 0 then result else nil
end

local function claimAppSessionRequest(entryPoint, configKey: string): boolean -- 2 equivalent calls inferred from this helper
	if not FFlagChatPushUpsellPromptsEnabled or entryPoint ~= PromptsEntryPoint.ChatLandingOpen then
		return true
	end

	local currentUserId = localUserIdStore.getCurrentUserId(false)

	if currentUserIds[configKey] == currentUserId then
		return false
	end

	currentUserIds[configKey] = currentUserId
	return true
end

local function forwardsClientAttributes(entryPoint) -- 2 equivalent calls inferred from this helper
	if FFlagEdpGameLeavePromptsHandlerEnabled or FFlagEdpOpenPromptsHandlerEnabled then
		return true
	end

	return FFlagChatPushUpsellPromptsEnabled and entryPoint == PromptsEntryPoint.ChatLandingOpen
end

local function getHomepagePromptStyles(p)
	if p == PromptsEntryPoint.HomepageLaunch then
		return parsePromptStyles(SharedFlags.FStringHomePromptsHandlerPromptStyles)
	end

	return nil
end

local function PromptsHandler(props)
	local entryPoint = props.entryPoint

	local v2 = FFlagNotificationStreamPromptsHandlerEnabled and entryPoint == PromptsEntryPoint.NotificationStreamOpen
	local promptStyle = props.promptStyle

	local fFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagHomePromptsHandlerRestrictPromptStyles
		and SharedFlags.FFlagLuaAppEnableSduiHomePage
	local v3 = useDispatch()
	local v4

	if FFlagSduiDismissPromptAction then
		v4 = useStore()
	else
		v4 = nil
	end

	local modalSignalStore = useModalSignalStore()
	local universeId

	if
		(FFlagEdpGameLeavePromptsHandlerEnabled or FFlagEdpOpenPromptsHandlerEnabled)
		and props.clientAttributes ~= nil
	then
		universeId = props.clientAttributes.universeId
	else
		universeId = nil
	end

	local replaceOnFetch

	if FFlagPromptsEdpOpenReplaceOnFetch then
		replaceOnFetch = props.replaceOnFetch
	else
		replaceOnFetch = nil
	end

	local v5

	if FFlagPushNotificationsUpsellPassClientAttributesToPrompts then
		v5 = getHomepagePromptsClientAttributes.use(entryPoint, props.clientAttributes)
	else
		v5 = nil
	end

	local surfaceConfig = React.useMemo(function()
		if FFlagEdpGameLeavePromptsHandlerEnabled or FFlagEdpOpenPromptsHandlerEnabled then
			return getEntryPointSurfaceConfig(entryPoint, universeId)
		end

		return getEntryPointSurfaceConfig(entryPoint)
	end, (FFlagEdpGameLeavePromptsHandlerEnabled or FFlagEdpOpenPromptsHandlerEnabled) and { entryPoint, universeId } or { entryPoint })

	local v6 = SignalsReact.useSignalState(modalSignalStore.getHasShownGetter(entryPoint))
	local v7 = SignalsReact.useSignalState(modalSignalStore.getMetadataGetter(entryPoint))

	local clientAttributes2 = nil
	local v8

	if FFlagHomepagePromptsHandlerPassClientAttributes then
		clientAttributes2 = React.useMemo(function()
			if v2 then
				return props.clientAttributes
			end

			if
				FFlagPushNotificationsUpsellPassClientAttributesToPrompts
				and entryPoint == PromptsEntryPoint.HomepageLaunch
				and (not (FFlagEdpGameLeavePromptsHandlerEnabled or FFlagEdpOpenPromptsHandlerEnabled) or props.clientAttributes == nil)
			then
				return v5
			end

			if forwardsClientAttributes(entryPoint) and props.clientAttributes ~= nil then -- inferred equivalent call
				return props.clientAttributes
			end

			if entryPoint == PromptsEntryPoint.HomepageLaunch then
				return getHomepagePromptsClientAttributes.get()
			end

			return nil
		end, { entryPoint, v5, props.clientAttributes, v2 })

		local useMemo = React.useMemo
		local function fn()
			local v9 = {
				entryPoint = entryPoint,
				surfaceKey = surfaceConfig.surfaceKey,
				configKey = surfaceConfig.configKey,
				clearOnEmptyResponse = true,
				allowNoConfigsBuilt = FFlagSduiAllowNoConfigsBuilt and true or nil,
				loadTimer = SduiLoadTimer.createLoadTimer(surfaceConfig.configKey),
				clientAttributes = clientAttributes2,
				replaceOnFetch = 0,
				promptStyles = 0
			}
			local replaceOnFetch2

			if FFlagPromptsEdpOpenReplaceOnFetch then
				replaceOnFetch2 = replaceOnFetch
			end

			v9.replaceOnFetch = replaceOnFetch2
			local promptStyles

			if fFlagLuaAppEnableSduiHomePage and entryPoint == PromptsEntryPoint.HomepageLaunch then
				promptStyles = parsePromptStyles(SharedFlags.FStringHomePromptsHandlerPromptStyles)
			end

			v9.promptStyles = promptStyles
			return v9
		end

		local v9 = clientAttributes2
		local v10

		if FFlagPromptsEdpOpenReplaceOnFetch then
			v10 = replaceOnFetch
		end

		v8 = useMemo(fn, { entryPoint, surfaceConfig, v9, fFlagLuaAppEnableSduiHomePage, v10 })
	else
		local useMemo = React.useMemo
		local function fn()
			local v9 = {
				entryPoint = entryPoint,
				surfaceKey = surfaceConfig.surfaceKey,
				configKey = surfaceConfig.configKey,
				clearOnEmptyResponse = true,
				allowNoConfigsBuilt = FFlagSduiAllowNoConfigsBuilt and true or nil,
				loadTimer = SduiLoadTimer.createLoadTimer(surfaceConfig.configKey),
				clientAttributes = 0,
				replaceOnFetch = 0,
				promptStyles = 0
			}
			local clientAttributes

			if forwardsClientAttributes(entryPoint) or v2 then -- inferred equivalent call
				clientAttributes = props.clientAttributes
			end

			v9.clientAttributes = clientAttributes
			local replaceOnFetch2

			if FFlagPromptsEdpOpenReplaceOnFetch then
				replaceOnFetch2 = replaceOnFetch
			end

			v9.replaceOnFetch = replaceOnFetch2
			local promptStyles

			if fFlagLuaAppEnableSduiHomePage and entryPoint == PromptsEntryPoint.HomepageLaunch then
				promptStyles = parsePromptStyles(SharedFlags.FStringHomePromptsHandlerPromptStyles)
			end

			v9.promptStyles = promptStyles
			return v9
		end

		local v9

		if
			FFlagEdpGameLeavePromptsHandlerEnabled
			or FFlagEdpOpenPromptsHandlerEnabled
			or FFlagChatPushUpsellPromptsEnabled
			or FFlagNotificationStreamPromptsHandlerEnabled
		then
			v9 = { nil, nil, nil, nil, nil, nil }

			local clientAttributes = props.clientAttributes
			local v10

			if FFlagPromptsEdpOpenReplaceOnFetch then
				v10 = replaceOnFetch
			end

			v9[1], v9[2], v9[3], v9[4], v9[5], v9[6] = entryPoint, surfaceConfig, clientAttributes, fFlagLuaAppEnableSduiHomePage, v10, v2
		else
			v9 = { nil, nil, nil, nil }
			local v10

			if FFlagPromptsEdpOpenReplaceOnFetch then
				v10 = replaceOnFetch
			end

			v9[1], v9[2], v9[3], v9[4] = entryPoint, surfaceConfig, fFlagLuaAppEnableSduiHomePage, v10
		end

		v8 = useMemo(fn, v9)
	end

	local ref = React.useRef(os.clock() + FIntPromptsHandlerSessionTimeoutMs / 1000)

	if FFlagPushNotificationsUpsellPassClientAttributesToPrompts then
		React.useEffect(function()
			local v9

			if entryPoint == PromptsEntryPoint.HomepageLaunch then
				v9 = not (FFlagEdpGameLeavePromptsHandlerEnabled or FFlagEdpOpenPromptsHandlerEnabled)
					or props.clientAttributes == nil
			else
				v9 = false
			end

			local sessionClientAttribute

			if v9 then
				sessionClientAttribute = getHomepagePromptsClientAttributes.sessionClientAttribute
			end

			if
				v9
				and clientAttributes2 == nil
				and (not FFlagPromptsHandlerFetchOncePerSession or sessionClientAttribute == nil)
			then
				return
			end

			if FFlagPromptsHandlerFetchOncePerSession and sessionClientAttribute ~= nil then
				local configKey = v8.configKey
				local v10

				if clientAttributes2 then
					v10 = clientAttributes2[sessionClientAttribute]
				end

				if v10 == nil then
					if v[configKey] ~= nil then
						return
					end

					local thread = task.delay(math.max(0, ref.current - os.clock()), function()
						if v[configKey] == nil then
							v[configKey] = false
							fetchPrompts(v8, true)
						end
					end)
					return function()
						task.cancel(thread)
					end
				end

				if v[configKey] == false then
					v[configKey] = v10
					return
				end

				if v[configKey] == v10 then
					return
				end

				v[configKey] = v10
				fetchPrompts(v8, true)
			else
				if not claimAppSessionRequest(entryPoint, v8.configKey) then -- inferred equivalent call
					return
				end

				local v10

				if FFlagEdpOpenPromptsHandlerEnabled then
					v10 = v9 or entryPoint == PromptsEntryPoint.ExperienceDetailsPageOpen
				end

				if v2 or not FFlagEdpOpenPromptsHandlerEnabled and v9 or FFlagEdpOpenPromptsHandlerEnabled and v10 then
					fetchPrompts(v8, true)
				else
					fetchPrompts(v8)
				end
			end
		end, { entryPoint, v8, props.clientAttributes, clientAttributes2, v2 })
	else
		local useEffect = React.useEffect
		local function fn()
			if not claimAppSessionRequest(entryPoint, v8.configKey) then -- inferred equivalent call
				return
			end

			local v9

			if FFlagEdpOpenPromptsHandlerEnabled then
				v9 = entryPoint == PromptsEntryPoint.ExperienceDetailsPageOpen
			end

			fetchPrompts(v8, (v2 or FFlagEdpOpenPromptsHandlerEnabled and v9) and true or nil)
		end

		local v9

		if FFlagEdpOpenPromptsHandlerEnabled or FFlagChatPushUpsellPromptsEnabled then
			v9 = entryPoint
		end

		useEffect(fn, { v8, v9, v2 })
	end

	local v9 = usePromptEntries(surfaceConfig.configKey, PromptStyle.Modal)
	local v10 = v9[1]
	local ref2

	if FFlagSduiDismissPromptAction then
		ref2 = React.useRef(nil)
	else
		ref2 = nil
	end

	local ref3

	if FFlagSduiDismissPromptAction then
		ref3 = React.useRef(nil)
	else
		ref3 = nil
	end

	local useEffect = React.useEffect
	local function fn()
		if v6 then
			if FFlagPromptsModalSkipTelemetry then
				logPromptModalSkipped.logAll(logPromptModalSkipped.Reason.AlreadyShown, entryPoint, v9)
			end
		elseif v7 then
			if FFlagPromptsModalSkipTelemetry then
				logPromptModalSkipped.logAll(logPromptModalSkipped.Reason.LegacyMetadata, entryPoint, v9)
			end
		elseif
			v10 == nil
			or v10.config == nil
			or v10.identifier == nil
			or v10.robloxComponentType == nil
			or v10.title == nil
		then
			if FFlagPromptsModalSkipTelemetry and v10 ~= nil then
				logPromptModalSkipped.log(logPromptModalSkipped.Reason.IncompleteEntry, entryPoint, v10)
			end
		else
			modalSignalStore.setHasShown(entryPoint, true)

			if FFlagPromptsModalSkipTelemetry then
				logPromptModalSkipped.markShown(entryPoint, v10)
			end

			local sduiPromptModal = CentralOverlayType.SduiPromptModal
			local v11 = {
				configKey = surfaceConfig.configKey,
				appPage = surfaceConfig.appPage,
				modalId = v10.identifier,
				modalType = 0
			}
			local modalType

			if FFlagPromptsImpressionUsesTitle then
				modalType = v10.title
			else
				modalType = v10.robloxComponentType
			end

			v11.modalType = modalType
			v3(SetCentralOverlay(sduiPromptModal, v11))

			if FFlagSduiDismissPromptAction then
				ref2.current = v10.title
				ref3.current = v10.identifier
			end
		end
	end

	local v11

	if FFlagPromptsModalSkipTelemetry then
		v11 = v9
	end

	useEffect(fn, { v6, v7, v3, modalSignalStore, v10, surfaceConfig, entryPoint, v11 })

	if FFlagSduiDismissPromptAction then
		React.useEffect(function()
			local current = ref2.current

			if current == nil then
				return
			end

			for _, v12 in v9 do
				if v12.title == current then
					return
				end
			end

			local current2 = ref3.current
			ref2.current = nil
			ref3.current = nil
			local centralOverlay = v4:getState().CentralOverlay

			if
				centralOverlay ~= nil
				and centralOverlay.OverlayType == CentralOverlayType.SduiPromptModal
				and centralOverlay.Arguments ~= nil
				and centralOverlay.Arguments.modalId == current2
			then
				v3(SetCentralOverlay())
			end
		end, { v9, v3, v4 })
	end

	if FFlagPlusUpsellSheetHomePrompt then
		PlusUpsellSheetPrompt.usePlusUpsellSheetPrompt({
			entryPoint = entryPoint,
			hasShownKey = entryPoint,
			modalSignalStore = modalSignalStore
		})
	end

	local v12 = promptStyle == PromptStyle.SurfaceBanner
	local v13 = usePromptEntries(surfaceConfig.configKey, PromptStyle.SurfaceBanner)
	local v14

	if v12 then
		v14 = v13[1]
	end

	local identifier

	if v14 then
		identifier = v14.identifier or nil
	else
		identifier = nil
	end

	local v15

	if v14 then
		if FFlagPromptsImpressionUsesTitle then
			v15 = v14.title
		else
			v15 = v14.robloxComponentType
		end
	else
		v15 = nil
	end

	local v16 = promptStyle == PromptStyle.InlineBanner
	local v17 = usePromptEntries(surfaceConfig.configKey, PromptStyle.InlineBanner)
	local v18

	if v16 then
		v18 = v17[1]
	end

	local identifier2

	if v18 then
		identifier2 = v18.identifier or nil
	else
		identifier2 = nil
	end

	local v19

	if v18 then
		if FFlagPromptsImpressionUsesTitle then
			v19 = v18.title
		else
			v19 = v18.robloxComponentType
		end
	else
		v19 = nil
	end

	React.useEffect(function()
		if identifier and v15 then
			reportPromptImpression(v15, identifier):catch(function()
				Logger:warning("Failed to report prompt impression")
			end)
			sendModalImpressionEvent(identifier, v15)
		end
	end, { identifier, v15 })

	React.useEffect(function()
		if identifier2 and v19 then
			reportPromptImpression(v19, identifier2):catch(function()
				Logger:warning("Failed to report prompt impression")
			end)
			sendModalImpressionEvent(identifier2, v19)
		end
	end, { identifier2, v19 })

	local v20 = false

	if FFlagPromptsHandlerCoachmarkEnabled then
		local v21 = usePromptEntries(surfaceConfig.configKey, PromptStyle.Coachmark)

		for _, v22 in v21 do
			if v22.config and v22.identifier and v22.title then
				v20 = true
				break
			end
		end
	end

	local v21 = FFlagSduiSurfaceBannerScrollAwaySticky and FFlagAppIaScrollAway and AppNavBar.getScrollAwayEnabled()
	local v22 = v14 ~= nil or FFlagSduiSurfaceBannerAlwaysMounted
	local v23 = nil

	if v12 then
		if FFlagSduiSystemBannerComponent and v22 and v21 then
			local createElement = React.createElement
			local identifier3

			if v14 then
				identifier3 = v14.identifier
			end

			v23 = createElement(SurfaceBanner, {
				identifier = identifier3,
				configKey = surfaceConfig.configKey,
				appPage = surfaceConfig.appPage,
				surfaceBannerContent = props.surfaceBannerContent
			})
		elseif FFlagSduiSystemBannerComponent and v22 then
			local createElement = React.createElement
			local v24 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

			local v25 = {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				SurfaceBanner = 0,
				ContentContainer = 0
			}
			local surfaceBanner

			if v14 then
				local createElement2 = React.createElement
				local v26 = {
					configKey = surfaceConfig.configKey,
					identifier = v14.identifier,
					appPage = surfaceConfig.appPage,
					additionalAnalyticsData = 0,
					shouldDisplayLoading = false,
					shouldDisplayError = false,
					LayoutOrder = 1
				}
				local additionalAnalyticsData

				if FFlagPromptsActionEventLogging then
					additionalAnalyticsData = { promptInstanceId = 0 }
					local promptInstanceId

					if v14.identifier then
						promptInstanceId = v14.identifier
					end

					additionalAnalyticsData.promptInstanceId = promptInstanceId
				end

				v26.additionalAnalyticsData = additionalAnalyticsData
				surfaceBanner = createElement2(SduiFeatureEntryPoint, v26)
			end

			v25.SurfaceBanner = surfaceBanner

			v25.ContentContainer = React.createElement(
				"Frame",
				{ LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 },
				{
					UIFlexItem = React.createElement("UIFlexItem", {
						FlexMode = Enum.UIFlexMode.Fill
					}),
					Content = props.surfaceBannerContent
				}
			)
			v23 = createElement("Frame", v24, v25)
		else
			v23 = props.surfaceBannerContent
		end
	elseif v16 then
		if v18 then
			local createElement = React.createElement
			local v24 = {
				configKey = surfaceConfig.configKey,
				identifier = v18.identifier,
				appPage = surfaceConfig.appPage,
				additionalAnalyticsData = 0,
				shouldDisplayLoading = false,
				shouldDisplayError = false
			}
			local additionalAnalyticsData

			if FFlagPromptsActionEventLogging then
				additionalAnalyticsData = { promptInstanceId = 0 }
				local promptInstanceId

				if v18.identifier then
					promptInstanceId = v18.identifier
				end

				additionalAnalyticsData.promptInstanceId = promptInstanceId
			end

			v24.additionalAnalyticsData = additionalAnalyticsData
			v23 = createElement(SduiFeatureEntryPoint, v24)
		else
			v23 = props.inlineBannerFallback
		end
	end

	if (FFlagHomepagePromptsPaddingFix or v2) and v16 then
		local v24 = v13[1] ~= nil

		if v23 ~= nil then
			local v25 = v24 and props.topPadding ~= nil
			local v26 = props.bottomPadding ~= nil
			local createElement = React.createElement
			local v27 = {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				padding = 0
			}
			local top

			if v25 then
				top = UDim.new(0, props.topPadding)
			end

			local bottom

			if v26 then
				bottom = UDim.new(0, props.bottomPadding)
			end

			v27.padding = { top = top, bottom = bottom }
			v23 = createElement(View, v27, { InlineBanner = v23 })
		elseif v24 and props.topPadding then
			v23 = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, props.topPadding),
				BackgroundTransparency = 1
			})
		end
	end

	if FFlagPromptsHandlerCoachmarkEnabled and v20 then
		return React.createElement(React.Fragment, nil, {
			Slot = v23,
			Coachmarks = React.createElement(CoachmarkRenderer, {
				surfaceConfig = surfaceConfig,
				hasShownKey = entryPoint
			})
		})
	end

	return v23
end

local memo = React.memo(PromptsHandler)
function memo.resetFetchedSessionsForTests()
	table.clear(v)
	table.clear(currentUserIds)
end
return memo
