local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local VirtualEventsParent = VirtualEvents.Parent
local IXPService = game:GetService("IXPService")
local fireEventDetailsPageVisit = require(VirtualEvents.Analytics.fireEventDetailsPageVisit)
local fetchEventDetailsPage = require(script.Parent.fetchEventDetailsPage)
local getEventDetailsPageKey = require(script.Parent.getEventDetailsPageKey)
local EventDetailsFeedSkeleton = require(script.Parent.EventDetailsFeedSkeleton)
local EventDetailsFullBleedSkeleton = require(script.Parent.EventDetailsFullBleedSkeleton)
local EventDetailsActionBarSkeleton = require(script.Parent.EventDetailsActionBarSkeleton)

require(VirtualEventsParent.Navigation)

local Foundation = require(VirtualEventsParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local React = require(VirtualEventsParent.React)
local useNavigation = require(VirtualEventsParent.Navigation).useNavigation
local useRouteName = require(VirtualEventsParent.Navigation).useRouteName
local useNavigationFocus = require(VirtualEventsParent.Navigation).useNavigationFocus
local useDeviceType = require(VirtualEventsParent.RobloxAppHooks).useDeviceType
local SduiSharedUtilities = require(VirtualEventsParent.SduiSharedUtilities)
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local RobloxAppEnums = require(VirtualEventsParent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local DeviceType = RobloxAppEnums.DeviceType
local FFlagLuaAppSduiEventDetailsLogExposure = require(VirtualEventsParent.SharedFlags).FFlagLuaAppSduiEventDetailsLogExposure
local FFlagLuaAppSduiEventDetailsCenterSheet = require(VirtualEventsParent.SharedFlags).FFlagLuaAppSduiEventDetailsCenterSheet
local FFlagLuaAppSduiEventDetailsLoadingSlot = require(VirtualEventsParent.SharedFlags).FFlagLuaAppSduiEventDetailsLoadingSlot
local FFlagLuaAppSduiEventDetailsActionBarInFeed = require(VirtualEventsParent.SharedFlags).FFlagLuaAppSduiEventDetailsActionBarInFeed
local FStringLuaAppSduiEventDetailsIxpLayer = require(VirtualEventsParent.SharedFlags).FStringLuaAppSduiEventDetailsIxpLayer
local FFlagSduiPageEntryUseSharedHooks = require(VirtualEventsParent.SharedFlags).FFlagSduiPageEntryUseSharedHooks
local FoundationSheetFullBleed = Foundation.Utility.Flags.FoundationSheetFullBleed

local function getFromPropsOrNavigationParams(t1: {[any]: any}, s1: string) -- line: 49
	local v35 = t1.navigation and t1.navigation.getParam("extraProps")

	return t1[s1] or v35 and v35[s1]
end
local function SduiEventDetailsPage(t2: {[any]: any}) -- line: 66
	-- upvalues: useTokens (copy), getEventDetailsPageKey (copy), React (copy), SduiLoadTimer (copy), AppPage (copy), useNavigation (copy), useRouteName (copy), useNavigationFocus (copy), FFlagLuaAppSduiEventDetailsCenterSheet (copy), useDeviceType (copy), DeviceType (copy), fetchEventDetailsPage (copy), FFlagLuaAppSduiEventDetailsLogExposure (copy), IXPService (copy), FStringLuaAppSduiEventDetailsIxpLayer (copy), fireEventDetailsPageVisit (copy), Foundation (copy), FoundationSheetFullBleed (copy), SduiFeatureEntryPoint (copy), FFlagLuaAppSduiEventDetailsLoadingSlot (copy), EventDetailsFullBleedSkeleton (copy), SduiPageEntryPoint (copy), FFlagSduiPageEntryUseSharedHooks (copy), EventDetailsFeedSkeleton (copy), FFlagLuaAppSduiEventDetailsActionBarInFeed (copy), EventDetailsActionBarSkeleton (copy)
	local v39 = useTokens()
	local v40 = t2.navigation and t2.navigation.getParam("extraProps")
	local v41 = t2.eventId or v40 and v40.eventId or t2.navigation and t2.navigation.getParam("detail")
	local v42 = t2.navigation and t2.navigation.getParam("extraProps")
	local v43 = t2.universeId or v42 and v42.universeId
	local v44 = t2.navigation and t2.navigation.getParam("extraProps")
	local v45 = t2.referralSource or v44 and v44.referralSource
	local v46 = getEventDetailsPageKey(v41)
	local v47 = React.useMemo(function() -- line: 76
		-- upvalues: t2 (copy), SduiLoadTimer (copy), AppPage (copy)
		local v55 = t2
		local v56 = v55.navigation and v55.navigation.getParam("extraProps")

		return v55.pageTimer or v56 and v56.pageTimer or SduiLoadTimer.createLoadTimer(AppPage.EventDetails)
	end, {})
	local v48 = useNavigation()
	local v49 = useRouteName()
	local v50 = useNavigationFocus()
	local v51 = nil

	if FFlagLuaAppSduiEventDetailsCenterSheet then
		local v52 = useDeviceType()

		v51 = v52 == DeviceType.Desktop or v52 == DeviceType.Tablet
	end

	local v53 = React.useCallback(function() -- line: 89
		-- upvalues: v49 (copy), AppPage (copy), v50 (copy), v48 (copy)
		if v49 == AppPage.EventDetails and v50 then
			v48.goBack()
		end
	end, {
		v48,
		v49,
		v50
	})

	React.useEffect(function() -- line: 95
		-- upvalues: v41 (copy), fetchEventDetailsPage (copy), v47 (copy)
		if v41 then
			fetchEventDetailsPage(v41, v47)
		end
	end, {
		v41,
		v47
	})
	React.useEffect(function() -- line: 101
		-- upvalues: v41 (copy), FFlagLuaAppSduiEventDetailsLogExposure (copy), IXPService (copy), FStringLuaAppSduiEventDetailsIxpLayer (copy)
		if v41 and FFlagLuaAppSduiEventDetailsLogExposure then
			IXPService:LogFlagLinkedUserLayerExposure(FStringLuaAppSduiEventDetailsIxpLayer)
		end
	end, { v41 })
	React.useEffect(function() -- line: 107
		-- upvalues: v41 (copy), fireEventDetailsPageVisit (copy), v43 (copy), v45 (copy)
		if v41 then
			fireEventDetailsPageVisit({
				virtualEventId = v41,
				universeId = tostring(v43 or ""),
				channel = v45 or "link"
			})
		end
	end, { v41 })

	local v54 = React.useRef(nil)

	if v41 == nil then
		return nil
	end

	return React.createElement(Foundation.Sheet.Root, {
		isOpen = v50,
		snapPoints = { 1 },
		displaySize = Foundation.Enums.DialogSize.Large,
		preferCenterSheet = v51,
		centerSheetHeight = if not FFlagLuaAppSduiEventDetailsCenterSheet then nil else 1,
		onClose = v53
	}, {
		FullBleed = if not FoundationSheetFullBleed then nil else React.createElement(Foundation.Sheet.FullBleed, {
			aspectRatio = 1.7777777777777777
		}, {
			FullBleedContent = React.createElement(SduiFeatureEntryPoint, {
				identifier = "event_details_sheet_full_bleed",
				shouldDisplayError = false,
				appPage = AppPage.EventDetails,
				configKey = v46,
				shouldDisplayLoading = FFlagLuaAppSduiEventDetailsLoadingSlot,
				loadingSlot = if not FFlagLuaAppSduiEventDetailsLoadingSlot then nil else React.createElement(EventDetailsFullBleedSkeleton),
				Size = UDim2.fromScale(1, 1),
				AutomaticSize = Enum.AutomaticSize.None
			})
		}),
		Content = React.createElement(Foundation.Sheet.Content, {
			scrollingFrameRef = v54
		}, React.createElement(SduiPageEntryPoint, {
			includeNavigationHeaderBar = false,
			disableRootPadding = true,
			snackbarPortalLayoutOrder = 2147483647,
			appPage = AppPage.EventDetails,
			configKey = v46,
			identifier = if not FFlagSduiPageEntryUseSharedHooks then v46 .. "_" .. "event_details_feed" else "event_details_feed",
			pageTimer = v47,
			backgroundStyle = v39.Color.None,
			scrollingFrameRef = v54,
			loadingSlot = if not FFlagLuaAppSduiEventDetailsLoadingSlot then nil else React.createElement(EventDetailsFeedSkeleton)
		})),
		Actions = if not FFlagLuaAppSduiEventDetailsActionBarInFeed then React.createElement(Foundation.Sheet.Actions, nil, React.createElement(SduiFeatureEntryPoint, {
			identifier = "event_details_action_bar",
			shouldDisplayError = false,
			appPage = AppPage.EventDetails,
			configKey = v46,
			shouldDisplayLoading = FFlagLuaAppSduiEventDetailsLoadingSlot,
			loadingSlot = if not FFlagLuaAppSduiEventDetailsLoadingSlot then nil else React.createElement(EventDetailsActionBarSkeleton)
		})) else nil
	})
end

return React.memo(SduiEventDetailsPage)
