local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local parent = ServerTriggeredModals.Parent

local React = require(parent.React)
local AppNavBar = require(parent.AppNavBar)
local Foundation = require(parent.Foundation)
local CentralOverlay = require(parent.CentralOverlay)
local RobloxAppEnums = require(parent.RobloxAppEnums)
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
local ServerTriggeredModalImpressions = require(parent.ServerTriggeredModalImpressions)
local sendModalImpressionEvent = ServerTriggeredModalImpressions.sendModalImpressionEvent
local fetchPrompts = require(ServerTriggeredModals.SduiV2.fetchPrompts)
local PromptsEntryPoint = require(ServerTriggeredModals.SduiV2.PromptsEntryPoint)
local PromptStyle = require(ServerTriggeredModals.SduiV2.PromptStyle)
local usePromptEntries = require(ServerTriggeredModals.SduiV2.usePromptEntries)
local useModalSignalStore = require(ServerTriggeredModals.SignalStores.useModalSignalStore)
local FFlagPromptsActionEventLogging = require(ServerTriggeredModals.Flags.FFlagPromptsActionEventLogging)

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

local v = {}

local function parsePromptStyles(fStringHomePromptsHandlerPromptStyles: string)
	local result = {}

	for k in string.gmatch(fStringHomePromptsHandlerPromptStyles, "[^,%s]+") do
		table.insert(result, k)
	end

	return if #result ~= 0 then result else nil
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

	local v5 = useModalSignalStore()
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

	local v6

	if FFlagPushNotificationsUpsellPassClientAttributesToPrompts then
		v6 = getHomepagePromptsClientAttributes.use(entryPoint, props.clientAttributes)
	else
		v6 = nil
	end

	local surfaceConfig = React.useMemo(function()
		if FFlagEdpGameLeavePromptsHandlerEnabled or FFlagEdpOpenPromptsHandlerEnabled then
			return getEntryPointSurfaceConfig(entryPoint, universeId)
		end

		return getEntryPointSurfaceConfig(entryPoint)
	end, (FFlagEdpGameLeavePromptsHandlerEnabled or FFlagEdpOpenPromptsHandlerEnabled) and { entryPoint, universeId } or { entryPoint })

	local v7 = SignalsReact.useSignalState(v5.getHasShownGetter(entryPoint))
	local v8 = SignalsReact.useSignalState(v5.getMetadataGetter(entryPoint))

	local clientAttributes2 = nil
	local v9

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
				return v6
			end

			if
				(FFlagEdpGameLeavePromptsHandlerEnabled or FFlagEdpOpenPromptsHandlerEnabled)
				and props.clientAttributes ~= nil
			then
				return props.clientAttributes
			end

			if entryPoint == PromptsEntryPoint.HomepageLaunch then
				return getHomepagePromptsClientAttributes.get()
			end

			return nil
		end, { entryPoint, v6, props.clientAttributes, v2 })

		local useMemo = React.useMemo
		local function fn()
			local v10 = {
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

			v10.replaceOnFetch = replaceOnFetch2
			local promptStyles

			if fFlagLuaAppEnableSduiHomePage and entryPoint == PromptsEntryPoint.HomepageLaunch then
				promptStyles = parsePromptStyles(SharedFlags.FStringHomePromptsHandlerPromptStyles)
			end

			v10.promptStyles = promptStyles
			return v10
		end

		local v10

		if FFlagPromptsEdpOpenReplaceOnFetch then
			v10 = replaceOnFetch
		end

		v9 = useMemo(fn, {
			entryPoint,
			surfaceConfig,
			clientAttributes2,
			fFlagLuaAppEnableSduiHomePage,
			v10
		})
	else
		local useMemo = React.useMemo
		local function fn()
			local v10 = {
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

			if FFlagEdpGameLeavePromptsHandlerEnabled or FFlagEdpOpenPromptsHandlerEnabled or v2 then
				clientAttributes = props.clientAttributes
			end

			v10.clientAttributes = clientAttributes
			local replaceOnFetch2

			if FFlagPromptsEdpOpenReplaceOnFetch then
				replaceOnFetch2 = replaceOnFetch
			end

			v10.replaceOnFetch = replaceOnFetch2
			local promptStyles

			if fFlagLuaAppEnableSduiHomePage and entryPoint == PromptsEntryPoint.HomepageLaunch then
				promptStyles = parsePromptStyles(SharedFlags.FStringHomePromptsHandlerPromptStyles)
			end

			v10.promptStyles = promptStyles
			return v10
		end

		local v10

		if
			FFlagEdpGameLeavePromptsHandlerEnabled
			or FFlagEdpOpenPromptsHandlerEnabled
			or FFlagNotificationStreamPromptsHandlerEnabled
		then
			v10 = { nil, nil, nil, nil, nil, nil }

			local clientAttributes = props.clientAttributes
			local v11

			if FFlagPromptsEdpOpenReplaceOnFetch then
				v11 = replaceOnFetch
			end

			v10[1], v10[2], v10[3], v10[4], v10[5], v10[6] = entryPoint, surfaceConfig, clientAttributes, fFlagLuaAppEnableSduiHomePage, v11, v2
		else
			v10 = { nil, nil, nil, nil }
			local v11

			if FFlagPromptsEdpOpenReplaceOnFetch then
				v11 = replaceOnFetch
			end

			v10[1], v10[2], v10[3], v10[4] = entryPoint, surfaceConfig, fFlagLuaAppEnableSduiHomePage, v11
		end

		v9 = useMemo(fn, v10)
	end

	local ref = React.useRef(os.clock() + FIntPromptsHandlerSessionTimeoutMs / 1000)

	if FFlagPushNotificationsUpsellPassClientAttributesToPrompts then
		React.useEffect(function()
			local v10

			if entryPoint == PromptsEntryPoint.HomepageLaunch then
				v10 = not (FFlagEdpGameLeavePromptsHandlerEnabled or FFlagEdpOpenPromptsHandlerEnabled)
					or props.clientAttributes == nil
			else
				v10 = false
			end

			local sessionClientAttribute

			if v10 then
				sessionClientAttribute = getHomepagePromptsClientAttributes.sessionClientAttribute
			end

			if
				v10
				and clientAttributes2 == nil
				and (not FFlagPromptsHandlerFetchOncePerSession or sessionClientAttribute == nil)
			then
				return
			end

			if FFlagPromptsHandlerFetchOncePerSession and sessionClientAttribute ~= nil then
				local configKey = v9.configKey
				local v11

				if clientAttributes2 then
					v11 = clientAttributes2[sessionClientAttribute]
				end

				if v11 == nil then
					if v[configKey] ~= nil then
						return
					end

					local thread = task.delay(math.max(0, ref.current - os.clock()), function()
						if v[configKey] == nil then
							v[configKey] = false
							fetchPrompts(v9, true)
						end
					end)
					return function()
						task.cancel(thread)
					end
				end

				if v[configKey] == false then
					v[configKey] = v11
					return
				end

				if v[configKey] == v11 then
					return
				end

				v[configKey] = v11
				fetchPrompts(v9, true)
			else
				local v11

				if FFlagEdpOpenPromptsHandlerEnabled then
					v11 = v10 or entryPoint == PromptsEntryPoint.ExperienceDetailsPageOpen
				end

				if v2 or not FFlagEdpOpenPromptsHandlerEnabled and v10 or FFlagEdpOpenPromptsHandlerEnabled and v11 then
					fetchPrompts(v9, true)
				else
					fetchPrompts(v9)
				end
			end
		end, { entryPoint, v9, props.clientAttributes, clientAttributes2, v2 })
	else
		local useEffect = React.useEffect
		local function fn()
			local v10

			if FFlagEdpOpenPromptsHandlerEnabled then
				v10 = entryPoint == PromptsEntryPoint.ExperienceDetailsPageOpen
			end

			fetchPrompts(v9, (v2 or FFlagEdpOpenPromptsHandlerEnabled and v10) and true or nil)
		end

		local v10

		if FFlagEdpOpenPromptsHandlerEnabled then
			v10 = entryPoint
		end

		useEffect(fn, { v9, v10, v2 })
	end

	local v10 = usePromptEntries(surfaceConfig.configKey, PromptStyle.Modal)
	local v11 = v10[1]
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

	React.useEffect(function()
		if v7 or v8 then
			return
		end

		if
			v11 == nil
			or v11.config == nil
			or v11.identifier == nil
			or v11.robloxComponentType == nil
			or v11.title == nil
		then
			return
		end

		v5.setHasShown(entryPoint, true)
		local sduiPromptModal = CentralOverlayType.SduiPromptModal
		local v12 = {
			configKey = surfaceConfig.configKey,
			appPage = surfaceConfig.appPage,
			modalId = v11.identifier,
			modalType = 0
		}
		local modalType

		if FFlagPromptsImpressionUsesTitle then
			modalType = v11.title
		else
			modalType = v11.robloxComponentType
		end

		v12.modalType = modalType
		v3(SetCentralOverlay(sduiPromptModal, v12))

		if FFlagSduiDismissPromptAction then
			ref2.current = v11.title
			ref3.current = v11.identifier
		end
	end, { v7, v8, v3, v5, v11, surfaceConfig, entryPoint })

	if FFlagSduiDismissPromptAction then
		React.useEffect(function()
			local current = ref2.current

			if current == nil then
				return
			end

			for _, v12 in v10 do
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
		end, { v10, v3, v4 })
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
end
return memo
