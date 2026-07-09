local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local VirtualEventsParent = VirtualEvents.Parent
local IXPService = game:GetService("IXPService")
local fireEventDetailsPageVisit = require(VirtualEvents.Analytics.fireEventDetailsPageVisit)
local fetchEventDetailsPage = require(script.Parent.fetchEventDetailsPage)
local getEventDetailsPageKey = require(script.Parent.getEventDetailsPageKey)

require(VirtualEventsParent.Navigation)

local Foundation = require(VirtualEventsParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local React = require(VirtualEventsParent.React)
local useNavigation = require(VirtualEventsParent.Navigation).useNavigation
local useRouteName = require(VirtualEventsParent.Navigation).useRouteName
local useNavigationFocus = require(VirtualEventsParent.Navigation).useNavigationFocus
local SduiSharedUtilities = require(VirtualEventsParent.SduiSharedUtilities)
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local AppPage = require(VirtualEventsParent.RobloxAppEnums).AppPage
local FFlagLuaAppSduiEventDetailsLogExposure = require(VirtualEventsParent.SharedFlags).FFlagLuaAppSduiEventDetailsLogExposure
local FStringLuaAppSduiEventDetailsIxpLayer = require(VirtualEventsParent.SharedFlags).FStringLuaAppSduiEventDetailsIxpLayer
local FFlagSduiPageEntryUseSharedHooks = require(VirtualEventsParent.SharedFlags).FFlagSduiPageEntryUseSharedHooks
local FoundationSheetFullBleed = Foundation.Utility.Flags.FoundationSheetFullBleed

local function getFromPropsOrNavigationParams(t1: {[any]: any}, s1: string) -- line: 39
	local v26 = t1.navigation and t1.navigation.getParam("extraProps")

	return t1[s1] or v26 and v26[s1]
end
local function SduiEventDetailsPage(t2: {[any]: any}) -- line: 56
	-- upvalues: useTokens (copy), getEventDetailsPageKey (copy), React (copy), SduiLoadTimer (copy), AppPage (copy), useNavigation (copy), useRouteName (copy), useNavigationFocus (copy), fetchEventDetailsPage (copy), FFlagLuaAppSduiEventDetailsLogExposure (copy), IXPService (copy), FStringLuaAppSduiEventDetailsIxpLayer (copy), fireEventDetailsPageVisit (copy), Foundation (copy), FoundationSheetFullBleed (copy), SduiFeatureEntryPoint (copy), SduiPageEntryPoint (copy), FFlagSduiPageEntryUseSharedHooks (copy)
	local v30 = useTokens()
	local v31 = t2.navigation and t2.navigation.getParam("extraProps")
	local v32 = t2.eventId or v31 and v31.eventId or t2.navigation and t2.navigation.getParam("detail")
	local v33 = t2.navigation and t2.navigation.getParam("extraProps")
	local v34 = t2.universeId or v33 and v33.universeId
	local v35 = t2.navigation and t2.navigation.getParam("extraProps")
	local v36 = t2.referralSource or v35 and v35.referralSource
	local v37 = getEventDetailsPageKey(v32)
	local v38 = React.useMemo(function() -- line: 66
		-- upvalues: t2 (copy), SduiLoadTimer (copy), AppPage (copy)
		local v44 = t2
		local v45 = v44.navigation and v44.navigation.getParam("extraProps")

		return v44.pageTimer or v45 and v45.pageTimer or SduiLoadTimer.createLoadTimer(AppPage.EventDetails)
	end, {})
	local v39 = useNavigation()
	local v40 = useRouteName()
	local v41 = useNavigationFocus()
	local v42 = React.useCallback(function() -- line: 74
		-- upvalues: v40 (copy), AppPage (copy), v41 (copy), v39 (copy)
		if v40 == AppPage.EventDetails and v41 then
			v39.goBack()
		end
	end, {
		v39,
		v40,
		v41
	})

	React.useEffect(function() -- line: 80
		-- upvalues: v32 (copy), fetchEventDetailsPage (copy), v38 (copy)
		if v32 then
			fetchEventDetailsPage(v32, v38)
		end
	end, {
		v32,
		v38
	})
	React.useEffect(function() -- line: 86
		-- upvalues: v32 (copy), FFlagLuaAppSduiEventDetailsLogExposure (copy), IXPService (copy), FStringLuaAppSduiEventDetailsIxpLayer (copy)
		if v32 and FFlagLuaAppSduiEventDetailsLogExposure then
			IXPService:LogFlagLinkedUserLayerExposure(FStringLuaAppSduiEventDetailsIxpLayer)
		end
	end, { v32 })
	React.useEffect(function() -- line: 92
		-- upvalues: v32 (copy), fireEventDetailsPageVisit (copy), v34 (copy), v36 (copy)
		if v32 then
			fireEventDetailsPageVisit({
				virtualEventId = v32,
				universeId = tostring(v34 or ""),
				channel = v36 or "link"
			})
		end
	end, { v32 })

	local v43 = React.useRef(nil)

	if v32 == nil then
		return nil
	end

	return React.createElement(Foundation.Sheet.Root, {
		isOpen = v41,
		snapPoints = { 1 },
		displaySize = Foundation.Enums.DialogSize.Large,
		onClose = v42
	}, {
		FullBleed = if not FoundationSheetFullBleed then nil else React.createElement(Foundation.Sheet.FullBleed, {
			aspectRatio = 1.7777777777777777
		}, {
			FullBleedContent = React.createElement(SduiFeatureEntryPoint, {
				identifier = "event_details_sheet_full_bleed",
				shouldDisplayLoading = false,
				shouldDisplayError = false,
				appPage = AppPage.EventDetails,
				configKey = v37,
				Size = UDim2.fromScale(1, 1),
				AutomaticSize = Enum.AutomaticSize.None
			})
		}),
		Content = React.createElement(Foundation.Sheet.Content, {
			scrollingFrameRef = v43
		}, React.createElement(SduiPageEntryPoint, {
			includeNavigationHeaderBar = false,
			disableRootPadding = true,
			snackbarPortalLayoutOrder = 2147483647,
			appPage = AppPage.EventDetails,
			configKey = v37,
			identifier = if not FFlagSduiPageEntryUseSharedHooks then v37 .. "_" .. "event_details_feed" else "event_details_feed",
			pageTimer = v38,
			backgroundStyle = v30.Color.None,
			scrollingFrameRef = v43
		})),
		Actions = React.createElement(Foundation.Sheet.Actions, nil, React.createElement(SduiFeatureEntryPoint, {
			identifier = "event_details_action_bar",
			shouldDisplayLoading = false,
			shouldDisplayError = false,
			appPage = AppPage.EventDetails,
			configKey = v37
		}))
	})
end

return React.memo(SduiEventDetailsPage)
