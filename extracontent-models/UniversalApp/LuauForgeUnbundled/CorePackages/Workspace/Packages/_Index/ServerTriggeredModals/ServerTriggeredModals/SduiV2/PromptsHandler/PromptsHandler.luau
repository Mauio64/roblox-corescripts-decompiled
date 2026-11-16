local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/React")
local AppNavBar = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/AppNavBar")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/Foundation")
local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/CentralOverlay")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RobloxAppEnums")
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
local sendModalImpressionEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/ServerTriggeredModalImpressions").sendModalImpressionEvent
local fetchPrompts = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/fetchPrompts")
local PromptsEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsEntryPoint")
local PromptStyle = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptStyle")
local usePromptEntries = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/usePromptEntries")
local useModalSignalStore = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SignalStores/useModalSignalStore")
local FFlagPromptsActionEventLogging = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Flags/FFlagPromptsActionEventLogging")

local getEntryPointSurfaceConfig = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsHandler/getEntryPointSurfaceConfig")
local getHomepagePromptsClientAttributes = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/getHomepagePromptsClientAttributes")
local CoachmarkRenderer = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsHandler/CoachmarkRenderer")
local module20 = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsHandler/SurfaceBanner")

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

local v5 = {}

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

local function getHomepagePromptStyles(p2)
	if p2 == PromptsEntryPoint.HomepageLaunch then
		return parsePromptStyles(SharedFlags.FStringHomePromptsHandlerPromptStyles)
	end

	return nil
end

local function PromptsHandler(props)
	local entryPoint = props.entryPoint

	local v6 = fFlagNotificationStreamPromptsHandlerEnabled
		and entryPoint == PromptsEntryPoint.NotificationStreamOpen
	local promptStyle = props.promptStyle

	local fFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagHomePromptsHandlerRestrictPromptStyles
		and SharedFlags.FFlagLuaAppEnableSduiHomePage
	local v7 = useDispatch()
	local v8 = if fFlagSduiDismissPromptAction then useStore() else nil
	local v9 = useModalSignalStore()
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
	local v10

	if fFlagPushNotificationsUpsellPassClientAttributesToPrompts then
		v10 = getHomepagePromptsClientAttributes.use(entryPoint, props.clientAttributes)
	else
		v10 = nil
	end

	local v11 = React.useMemo(function()
		if fFlagEdpGameLeavePromptsHandlerEnabled or fFlagEdpOpenPromptsHandlerEnabled then
			return getEntryPointSurfaceConfig(entryPoint, universeId)
		end

		return getEntryPointSurfaceConfig(entryPoint)
	end, (fFlagEdpGameLeavePromptsHandlerEnabled or fFlagEdpOpenPromptsHandlerEnabled) and {
		entryPoint,
		universeId
	} or { entryPoint })

	local v12 = SignalsReact.useSignalState(v9.getHasShownGetter(entryPoint))
	local v13 = SignalsReact.useSignalState(v9.getMetadataGetter(entryPoint))

	local v14 = nil
	local v15

	if fFlagHomepagePromptsHandlerPassClientAttributes then
		v14 = React.useMemo(function()
			if v6 then
				return props.clientAttributes
			end

			if
				fFlagPushNotificationsUpsellPassClientAttributesToPrompts
				and entryPoint == PromptsEntryPoint.HomepageLaunch
				and (not (fFlagEdpGameLeavePromptsHandlerEnabled or fFlagEdpOpenPromptsHandlerEnabled) or props.clientAttributes == nil)
			then
				return v10
			end

			if
				(fFlagEdpGameLeavePromptsHandlerEnabled or fFlagEdpOpenPromptsHandlerEnabled)
				and props.clientAttributes ~= nil
			then
				return props.clientAttributes
			end

			if entryPoint == PromptsEntryPoint.HomepageLaunch then
				return getHomepagePromptsClientAttributes.get()
			end

			return nil
		end, { entryPoint, v10, props.clientAttributes, v6 })

		local useMemo = React.useMemo
		local function fn()
			local v16 = {
				entryPoint = entryPoint,
				surfaceKey = v11.surfaceKey,
				configKey = v11.configKey,
				clearOnEmptyResponse = true,
				allowNoConfigsBuilt = fFlagSduiAllowNoConfigsBuilt and true or nil,
				loadTimer = sduiLoadTimer.createLoadTimer(v11.configKey),
				clientAttributes = v14,
				replaceOnFetch = if fFlagPromptsEdpOpenReplaceOnFetch then replaceOnFetch else nil,
				promptStyles = 0
			}
			local v18 = if fFlagLuaAppEnableSduiHomePage and entryPoint == PromptsEntryPoint.HomepageLaunch then parsePromptStyles(SharedFlags.FStringHomePromptsHandlerPromptStyles) else nil

			v16.promptStyles = v18
			return v16
		end

		v15 = useMemo(fn, {
			entryPoint,
			v11,
			v14,
			fFlagLuaAppEnableSduiHomePage,
			if fFlagPromptsEdpOpenReplaceOnFetch then replaceOnFetch else nil
		})
	else
		local useMemo = React.useMemo
		local function fn()
			local v16 = {
				entryPoint = entryPoint,
				surfaceKey = v11.surfaceKey,
				configKey = v11.configKey,
				clearOnEmptyResponse = true,
				allowNoConfigsBuilt = fFlagSduiAllowNoConfigsBuilt and true or nil,
				loadTimer = sduiLoadTimer.createLoadTimer(v11.configKey),
				clientAttributes = 0,
				replaceOnFetch = 0,
				promptStyles = 0
			}

			local v17 = if fFlagEdpGameLeavePromptsHandlerEnabled or fFlagEdpOpenPromptsHandlerEnabled or v6 then props.clientAttributes else nil
			v16.clientAttributes = v17

			v16.replaceOnFetch = if fFlagPromptsEdpOpenReplaceOnFetch then replaceOnFetch else nil
			local v19 = if fFlagLuaAppEnableSduiHomePage and entryPoint == PromptsEntryPoint.HomepageLaunch then parsePromptStyles(SharedFlags.FStringHomePromptsHandlerPromptStyles) else nil

			v16.promptStyles = v19
			return v16
		end

		local v16

		if
			fFlagEdpGameLeavePromptsHandlerEnabled
			or fFlagEdpOpenPromptsHandlerEnabled
			or fFlagNotificationStreamPromptsHandlerEnabled
		then
			v16 = { nil, nil, nil, nil, nil, nil }

			v16[1], v16[2], v16[3], v16[4], v16[5], v16[6] = entryPoint, v11, props.clientAttributes, fFlagLuaAppEnableSduiHomePage, if fFlagPromptsEdpOpenReplaceOnFetch then replaceOnFetch else nil, v6
		else
			v16 = { nil, nil, nil, nil }

			v16[1], v16[2], v16[3], v16[4] = entryPoint, v11, fFlagLuaAppEnableSduiHomePage, if fFlagPromptsEdpOpenReplaceOnFetch then replaceOnFetch else nil
		end

		v15 = useMemo(fn, v16)
	end

	local ref = React.useRef(os.clock() + fIntPromptsHandlerSessionTimeoutMs / 1000)

	if fFlagPushNotificationsUpsellPassClientAttributesToPrompts then
		React.useEffect(function()
			local v16

			if entryPoint == PromptsEntryPoint.HomepageLaunch then
				v16 = not (fFlagEdpGameLeavePromptsHandlerEnabled or fFlagEdpOpenPromptsHandlerEnabled)
					or props.clientAttributes == nil
			else
				v16 = false
			end

			local sessionClientAttribute = if v16 then getHomepagePromptsClientAttributes.sessionClientAttribute else nil

			if
				v16
				and v14 == nil
				and (not fFlagPromptsHandlerFetchOncePerSession or sessionClientAttribute == nil)
			then
				return
			end

			if fFlagPromptsHandlerFetchOncePerSession and sessionClientAttribute ~= nil then
				local configKey = v15.configKey

				local v17 = if v14 then v14[sessionClientAttribute] else nil

				if v17 == nil then
					if v5[configKey] ~= nil then
						return
					end

					local thread = task.delay(math.max(0, ref.current - os.clock()), function()
						if v5[configKey] == nil then
							v5[configKey] = false
							fetchPrompts(v15, true)
						end
					end)
					return function()
						task.cancel(thread)
					end
				end

				if v5[configKey] == false then
					v5[configKey] = v17
					return
				end

				if v5[configKey] == v17 then
					return
				end

				v5[configKey] = v17
				fetchPrompts(v15, true)
			else
				local v17

				if fFlagEdpOpenPromptsHandlerEnabled then
					v17 = v16 or entryPoint == PromptsEntryPoint.ExperienceDetailsPageOpen
				end

				if
					v6
					or not fFlagEdpOpenPromptsHandlerEnabled and v16
					or fFlagEdpOpenPromptsHandlerEnabled and v17
				then
					fetchPrompts(v15, true)
				else
					fetchPrompts(v15)
				end
			end
		end, { entryPoint, v15, props.clientAttributes, v14, v6 })
	else
		local function fn()
			local v16 = if fFlagEdpOpenPromptsHandlerEnabled then entryPoint == PromptsEntryPoint.ExperienceDetailsPageOpen else nil

			fetchPrompts(v15, (v6 or fFlagEdpOpenPromptsHandlerEnabled and v16) and true or nil)
		end

		React.useEffect(fn, { v15, if fFlagEdpOpenPromptsHandlerEnabled then entryPoint else nil, v6 })
	end

	local v16 = usePromptEntries(v11.configKey, PromptStyle.Modal)
	local v17 = v16[1]

	local ref2 = if fFlagSduiDismissPromptAction then React.useRef(nil) else nil
	local ref3 = if fFlagSduiDismissPromptAction then React.useRef(nil) else nil

	React.useEffect(function()
		if v12 or v13 then
			return
		end

		if
			v17 == nil
			or v17.config == nil
			or v17.identifier == nil
			or v17.robloxComponentType == nil
			or v17.title == nil
		then
			return
		end

		v9.setHasShown(entryPoint, true)
		local sduiPromptModal = centralOverlayType.SduiPromptModal
		local v20 = {
			configKey = v11.configKey,
			appPage = v11.appPage,
			modalId = v17.identifier,
			modalType = 0
		}

		local v21 = if fFlagPromptsImpressionUsesTitle then v17.title else v17.robloxComponentType
		v20.modalType = v21
		v7(setCentralOverlay(sduiPromptModal, v20))

		if fFlagSduiDismissPromptAction then
			ref2.current = v17.title
			ref3.current = v17.identifier
		end
	end, { v12, v13, v7, v9, v17, v11, entryPoint })

	if fFlagSduiDismissPromptAction then
		React.useEffect(function()
			local current = ref2.current

			if current == nil then
				return
			end

			for k, v18 in v16 do
				if v18.title == current then
					return
				end
			end

			local current2 = ref3.current
			ref2.current = nil
			ref3.current = nil
			local centralOverlay = v8:getState().CentralOverlay

			if
				centralOverlay ~= nil
				and centralOverlay.OverlayType == centralOverlayType.SduiPromptModal
				and centralOverlay.Arguments ~= nil
				and centralOverlay.Arguments.modalId == current2
			then
				v7(setCentralOverlay())
			end
		end, { v16, v7, v8 })
	end

	local v18 = promptStyle == PromptStyle.SurfaceBanner
	local v19 = usePromptEntries(v11.configKey, PromptStyle.SurfaceBanner)
	local v20 = if v18 then v19[1] else nil
	local identifier = if v20 then v20.identifier or nil else nil
	local v21

	if v20 then
		v21 = if fFlagPromptsImpressionUsesTitle then v20.title else v20.robloxComponentType
	else
		v21 = nil
	end

	local v22 = promptStyle == PromptStyle.InlineBanner
	local v23 = usePromptEntries(v11.configKey, PromptStyle.InlineBanner)
	local v24 = if v22 then v23[1] else nil
	local identifier2 = if v24 then v24.identifier or nil else nil
	local v25

	if v24 then
		v25 = if fFlagPromptsImpressionUsesTitle then v24.title else v24.robloxComponentType
	else
		v25 = nil
	end

	React.useEffect(function()
		if identifier and v21 then
			reportPromptImpression(v21, identifier):catch(function()
				Logger:warning("Failed to report prompt impression")
			end)
			sendModalImpressionEvent(identifier, v21)
		end
	end, { identifier, v21 })

	React.useEffect(function()
		if identifier2 and v25 then
			reportPromptImpression(v25, identifier2):catch(function()
				Logger:warning("Failed to report prompt impression")
			end)
			sendModalImpressionEvent(identifier2, v25)
		end
	end, { identifier2, v25 })

	local v26 = false

	if fFlagPromptsHandlerCoachmarkEnabled then
		local v27 = usePromptEntries(v11.configKey, PromptStyle.Coachmark)

		for k, v29 in v27 do
			if v29.config and v29.identifier and v29.title then
				v26 = true
				break
			end
		end
	end

	local v27 = fFlagSduiSurfaceBannerScrollAwaySticky
		and fFlagAppIaScrollAway
		and AppNavBar.getScrollAwayEnabled()
	local v28 = v20 ~= nil or fFlagSduiSurfaceBannerAlwaysMounted
	local v29 = nil

	if v18 then
		if fFlagSduiSystemBannerComponent and v28 and v27 then
			local createElement = React.createElement
			local v32 = if v20 then v20.identifier else nil
			v29 = createElement(module20, {
				identifier = v32,
				configKey = v11.configKey,
				appPage = v11.appPage,
				surfaceBannerContent = props.surfaceBannerContent
			})
		elseif fFlagSduiSystemBannerComponent and v28 then
			local createElement = React.createElement
			local v31 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

			local v32 = {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				SurfaceBanner = 0,
				ContentContainer = 0
			}
			local v33

			if v20 then
				local createElement2 = React.createElement
				local v35 = {
					configKey = v11.configKey,
					identifier = v20.identifier,
					appPage = v11.appPage,
					additionalAnalyticsData = 0,
					shouldDisplayLoading = false,
					shouldDisplayError = false,
					LayoutOrder = 1
				}
				local v36

				if FFlagPromptsActionEventLogging then
					v36 = { promptInstanceId = 0 }
					local v37 = if v20.identifier then v20.identifier else nil
					v36.promptInstanceId = v37
				end

				v35.additionalAnalyticsData = v36
				v33 = createElement2(sduiFeatureEntryPoint, v35)
			end

			v32.SurfaceBanner = v33

			v32.ContentContainer = React.createElement(
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
			v29 = createElement("Frame", v31, v32)
		else
			v29 = props.surfaceBannerContent
		end
	elseif v22 then
		if v24 then
			local createElement = React.createElement
			local v31 = {
				configKey = v11.configKey,
				identifier = v24.identifier,
				appPage = v11.appPage,
				additionalAnalyticsData = 0,
				shouldDisplayLoading = false,
				shouldDisplayError = false
			}
			local v32

			if FFlagPromptsActionEventLogging then
				v32 = { promptInstanceId = 0 }
				local v33 = if v24.identifier then v24.identifier else nil
				v32.promptInstanceId = v33
			end

			v31.additionalAnalyticsData = v32
			v29 = createElement(sduiFeatureEntryPoint, v31)
		else
			v29 = props.inlineBannerFallback
		end
	end

	if (fFlagHomepagePromptsPaddingFix or v6) and v22 then
		local v30 = v19[1] ~= nil

		if v29 ~= nil then
			local v31 = v30 and props.topPadding ~= nil
			local v32 = props.bottomPadding ~= nil
			local createElement = React.createElement
			local v34 = {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				padding = 0
			}

			local v36 = if v31 then UDim.new(0, props.topPadding) else nil
			local v37 = if v32 then UDim.new(0, props.bottomPadding) else nil
			v34.padding = { top = v36, bottom = v37 }
			v29 = createElement(view, v34, { InlineBanner = v29 })
		elseif v30 and props.topPadding then
			v29 = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, props.topPadding),
				BackgroundTransparency = 1
			})
		end
	end

	if fFlagPromptsHandlerCoachmarkEnabled and v26 then
		return React.createElement(React.Fragment, nil, {
			Slot = v29,
			Coachmarks = React.createElement(CoachmarkRenderer, {
				surfaceConfig = v11,
				hasShownKey = entryPoint
			})
		})
	end

	return v29
end

local memo = React.memo(PromptsHandler)
function memo.resetFetchedSessionsForTests()
	table.clear(v5)
end
return memo
