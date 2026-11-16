local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local parent = VirtualEvents.Parent

local IXPService = game:GetService("IXPService")
local fireEventDetailsPageVisit = require(VirtualEvents.Analytics.fireEventDetailsPageVisit)
local fetchEventDetailsPage = require(script.Parent.fetchEventDetailsPage)
local getEventDetailsPageKey = require(script.Parent.getEventDetailsPageKey)
local EventDetailsFeedSkeleton = require(script.Parent.EventDetailsFeedSkeleton)
local EventDetailsFullBleedSkeleton = require(script.Parent.EventDetailsFullBleedSkeleton)
local EventDetailsActionBarSkeleton = require(script.Parent.EventDetailsActionBarSkeleton)
require(parent.Navigation)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Navigation2 = require(parent.Navigation)
local useRouteName = Navigation2.useRouteName
local Navigation3 = require(parent.Navigation)
local useNavigationFocus = Navigation3.useNavigationFocus
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useDeviceType = RobloxAppHooks.useDeviceType
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local DeviceType = RobloxAppEnums.DeviceType
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiEventDetailsLogExposure = SharedFlags.FFlagLuaAppSduiEventDetailsLogExposure
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppSduiEventDetailsCenterSheet = SharedFlags2.FFlagLuaAppSduiEventDetailsCenterSheet
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppSduiEventDetailsLoadingSlot = SharedFlags3.FFlagLuaAppSduiEventDetailsLoadingSlot

local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppSduiEventDetailsActionBarInFeed = SharedFlags4.FFlagLuaAppSduiEventDetailsActionBarInFeed
local SharedFlags5 = require(parent.SharedFlags)
local FStringLuaAppSduiEventDetailsIxpLayer = SharedFlags5.FStringLuaAppSduiEventDetailsIxpLayer
local SharedFlags6 = require(parent.SharedFlags)
local FFlagSduiPageEntryUseSharedHooks = SharedFlags6.FFlagSduiPageEntryUseSharedHooks

local function getFromPropsOrNavigationParams(p, p2: string) -- 4 equivalent calls inferred from this helper
	local v = p.navigation and p.navigation.getParam("extraProps")
	return p[p2] or v and v[p2]
end

local function SduiEventDetailsPage(p)
	local v = useTokens()

	local virtualEventId = getFromPropsOrNavigationParams(p, "eventId") -- inferred equivalent call
		or p.navigation and p.navigation.getParam("detail")
	local v2 = getFromPropsOrNavigationParams(p, "universeId") -- inferred equivalent call
	local v3 = getFromPropsOrNavigationParams(p, "referralSource") -- inferred equivalent call
	local eventDetailsPageKey = getEventDetailsPageKey(virtualEventId)

	local pageTimer = React.useMemo(function()
		return getFromPropsOrNavigationParams(p, "pageTimer") or SduiLoadTimer.createLoadTimer(AppPage.EventDetails) -- inferred equivalent call
	end, {})

	local v4 = useNavigation()
	local v5 = useRouteName()
	local isOpen = useNavigationFocus()
	local preferCenterSheet

	if FFlagLuaAppSduiEventDetailsCenterSheet then
		local v6 = useDeviceType()
		preferCenterSheet = v6 == DeviceType.Desktop or v6 == DeviceType.Tablet
	end

	local onClose = React.useCallback(function()
		if v5 == AppPage.EventDetails and isOpen then
			v4.goBack()
		end
	end, { v4, v5, isOpen })

	React.useEffect(function()
		if virtualEventId then
			fetchEventDetailsPage(virtualEventId, pageTimer)
		end
	end, { virtualEventId, pageTimer })

	React.useEffect(function()
		if virtualEventId and FFlagLuaAppSduiEventDetailsLogExposure then
			IXPService:LogFlagLinkedUserLayerExposure(FStringLuaAppSduiEventDetailsIxpLayer)
		end
	end, { virtualEventId })

	React.useEffect(function()
		if virtualEventId then
			fireEventDetailsPageVisit({
				virtualEventId = virtualEventId,
				universeId = tostring(v2 or ""),
				channel = v3 or "link"
			})
		end
	end, { virtualEventId })

	local ref = React.useRef(nil)

	if virtualEventId == nil then
		return nil
	end

	local createElement = React.createElement
	local root = Foundation.Sheet.Root
	local v6 = {
		isOpen = isOpen,
		snapPoints = { 1 },
		displaySize = Foundation.Enums.DialogSize.Large,
		preferCenterSheet = preferCenterSheet,
		centerSheetHeight = FFlagLuaAppSduiEventDetailsCenterSheet and 1 or nil,
		onClose = onClose
	}

	local createElement2 = React.createElement
	local fullBleed = Foundation.Sheet.FullBleed

	local createElement3 = React.createElement
	local v7 = {
		appPage = AppPage.EventDetails,
		configKey = eventDetailsPageKey,
		identifier = "event_details_sheet_full_bleed",
		shouldDisplayLoading = FFlagLuaAppSduiEventDetailsLoadingSlot,
		loadingSlot = 0,
		shouldDisplayError = false,
		Size = 0,
		AutomaticSize = 0
	}
	local loadingSlot

	if FFlagLuaAppSduiEventDetailsLoadingSlot then
		loadingSlot = React.createElement(EventDetailsFullBleedSkeleton)
	end

	v7.loadingSlot = loadingSlot

	v7.Size = UDim2.fromScale(1, 1)
	v7.AutomaticSize = Enum.AutomaticSize.None
	local children = {
		FullBleed = createElement2(fullBleed, {
			aspectRatio = 16 / 9
		}, {
			FullBleedContent = createElement3(SduiFeatureEntryPoint, v7)
		}),
		Content = 0,
		Actions = 0
	}

	local createElement4 = React.createElement
	local content = Foundation.Sheet.Content

	local createElement5 = React.createElement
	local v8 = {
		appPage = AppPage.EventDetails,
		configKey = eventDetailsPageKey,
		identifier = FFlagSduiPageEntryUseSharedHooks and "event_details_feed" or eventDetailsPageKey .. "_event_details_feed",
		pageTimer = pageTimer,
		includeNavigationHeaderBar = false,
		backgroundStyle = v.Color.None,
		disableRootPadding = true,
		scrollingFrameRef = ref,
		snackbarPortalLayoutOrder = 2147483647,
		loadingSlot = 0
	}
	local loadingSlot2

	if FFlagLuaAppSduiEventDetailsLoadingSlot then
		loadingSlot2 = React.createElement(EventDetailsFeedSkeleton)
	end

	v8.loadingSlot = loadingSlot2
	children.Content = createElement4(content, { scrollingFrameRef = ref }, createElement5(SduiPageEntryPoint, v8))
	local actions2

	if not FFlagLuaAppSduiEventDetailsActionBarInFeed then
		local createElement6 = React.createElement
		local actions = Foundation.Sheet.Actions

		local createElement7 = React.createElement
		local v9 = {
			appPage = AppPage.EventDetails,
			configKey = eventDetailsPageKey,
			identifier = "event_details_action_bar",
			shouldDisplayLoading = FFlagLuaAppSduiEventDetailsLoadingSlot,
			loadingSlot = 0,
			shouldDisplayError = false
		}
		local loadingSlot3

		if FFlagLuaAppSduiEventDetailsLoadingSlot then
			loadingSlot3 = React.createElement(EventDetailsActionBarSkeleton)
		end

		v9.loadingSlot = loadingSlot3
		actions2 = createElement6(actions, nil, createElement7(SduiFeatureEntryPoint, v9))
	end

	children.Actions = actions2
	return createElement(root, v6, children)
end

return React.memo(SduiEventDetailsPage)
