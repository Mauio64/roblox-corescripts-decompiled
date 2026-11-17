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
local FFlagLuaAppSduiEventDetailsActionBarInFeed = SharedFlags3.FFlagLuaAppSduiEventDetailsActionBarInFeed
local SharedFlags4 = require(parent.SharedFlags)
local FStringLuaAppSduiEventDetailsIxpLayer = SharedFlags4.FStringLuaAppSduiEventDetailsIxpLayer
local SharedFlags5 = require(parent.SharedFlags)
local FFlagSduiPageEntryUseSharedHooks = SharedFlags5.FFlagSduiPageEntryUseSharedHooks

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
	local v7 = {
		FullBleed = React.createElement(Foundation.Sheet.FullBleed, {
			aspectRatio = 16 / 9
		}, {
			FullBleedContent = React.createElement(SduiFeatureEntryPoint, {
				appPage = AppPage.EventDetails,
				configKey = eventDetailsPageKey,
				identifier = "event_details_sheet_full_bleed",
				loadingSlot = React.createElement(EventDetailsFullBleedSkeleton),
				shouldDisplayError = false,
				Size = UDim2.fromScale(1, 1),
				AutomaticSize = Enum.AutomaticSize.None
			})
		}),
		Content = React.createElement(
			Foundation.Sheet.Content,
			{ scrollingFrameRef = ref },
			React.createElement(SduiPageEntryPoint, {
				appPage = AppPage.EventDetails,
				configKey = eventDetailsPageKey,
				identifier = FFlagSduiPageEntryUseSharedHooks and "event_details_feed" or eventDetailsPageKey .. "_event_details_feed",
				pageTimer = pageTimer,
				includeNavigationHeaderBar = false,
				backgroundStyle = v.Color.None,
				disableRootPadding = true,
				scrollingFrameRef = ref,
				snackbarPortalLayoutOrder = 2147483647,
				loadingSlot = React.createElement(EventDetailsFeedSkeleton)
			})
		),
		Actions = 0
	}
	local actions

	if not FFlagLuaAppSduiEventDetailsActionBarInFeed then
		actions = React.createElement(Foundation.Sheet.Actions, nil, React.createElement(SduiFeatureEntryPoint, {
			appPage = AppPage.EventDetails,
			configKey = eventDetailsPageKey,
			identifier = "event_details_action_bar",
			loadingSlot = React.createElement(EventDetailsActionBarSkeleton),
			shouldDisplayError = false
		}))
	end

	v7.Actions = actions
	return createElement(root, v6, v7)
end

return React.memo(SduiEventDetailsPage)
