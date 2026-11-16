local IXPService = game:GetService("IXPService")
local fireEventDetailsPageVisit = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Analytics/fireEventDetailsPageVisit")
local fetchEventDetailsPage = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/SduiEventDetailsPage/fetchEventDetailsPage")
local getEventDetailsPageKey = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/SduiEventDetailsPage/getEventDetailsPageKey")
local EventDetailsFeedSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/SduiEventDetailsPage/EventDetailsFeedSkeleton")
local EventDetailsFullBleedSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/SduiEventDetailsPage/EventDetailsFullBleedSkeleton")
local EventDetailsActionBarSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/SduiEventDetailsPage/EventDetailsActionBarSkeleton")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Navigation")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Foundation")
local useTokens = Foundation.Hooks.useTokens
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Navigation").useNavigation
local useRouteName = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Navigation").useRouteName
local useNavigationFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Navigation").useNavigationFocus
local useDeviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RobloxAppHooks").useDeviceType
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SduiSharedUtilities")
local sduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local sduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local sduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RobloxAppEnums")
local appPage = RobloxAppEnums.AppPage
local deviceType = RobloxAppEnums.DeviceType
local fFlagLuaAppSduiEventDetailsLogExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SharedFlags").FFlagLuaAppSduiEventDetailsLogExposure
local fFlagLuaAppSduiEventDetailsCenterSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SharedFlags").FFlagLuaAppSduiEventDetailsCenterSheet
local fFlagLuaAppSduiEventDetailsLoadingSlot = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SharedFlags").FFlagLuaAppSduiEventDetailsLoadingSlot

local fFlagLuaAppSduiEventDetailsActionBarInFeed = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SharedFlags").FFlagLuaAppSduiEventDetailsActionBarInFeed
local fStringLuaAppSduiEventDetailsIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SharedFlags").FStringLuaAppSduiEventDetailsIxpLayer
local fFlagSduiPageEntryUseSharedHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SharedFlags").FFlagSduiPageEntryUseSharedHooks

local function getFromPropsOrNavigationParams(p2, p3)
	local v5 = p2.navigation and p2.navigation.getParam("extraProps")
	return p2[p3] or v5 and v5[p3]
end

local function SduiEventDetailsPage(props)
	local v5 = useTokens()
	local v6 = props.navigation and props.navigation.getParam("extraProps")
	local eventId = props.eventId
		or v6 and v6.eventId
		or props.navigation and props.navigation.getParam("detail")
	local v7 = props.navigation and props.navigation.getParam("extraProps")
	local universeId = props.universeId or v7 and v7.universeId
	local v8 = props.navigation and props.navigation.getParam("extraProps")
	local referralSource = props.referralSource or v8 and v8.referralSource

	local v9 = getEventDetailsPageKey(eventId)

	local v10 = React.useMemo(function()
		local v11 = props
		local v12 = v11.navigation and v11.navigation.getParam("extraProps")
		return v11.pageTimer or v12 and v12.pageTimer or sduiLoadTimer.createLoadTimer(appPage.EventDetails)
	end, {})

	local v11 = useNavigation()
	local v12 = useRouteName()
	local v13 = useNavigationFocus()
	local v14

	if fFlagLuaAppSduiEventDetailsCenterSheet then
		local v15 = useDeviceType()
		v14 = v15 == deviceType.Desktop or v15 == deviceType.Tablet
	end

	local v15 = React.useCallback(function()
		if v12 == appPage.EventDetails and v13 then
			v11.goBack()
		end
	end, { v11, v12, v13 })

	React.useEffect(function()
		if eventId then
			fetchEventDetailsPage(eventId, v10)
		end
	end, { eventId, v10 })

	React.useEffect(function()
		if eventId and fFlagLuaAppSduiEventDetailsLogExposure then
			IXPService:LogFlagLinkedUserLayerExposure(fStringLuaAppSduiEventDetailsIxpLayer)
		end
	end, { eventId })

	React.useEffect(function()
		if eventId then
			fireEventDetailsPageVisit({
				virtualEventId = eventId,
				universeId = tostring(universeId or ""),
				channel = referralSource or "link"
			})
		end
	end, { eventId })

	local ref = React.useRef(nil)

	if eventId == nil then
		return nil
	end

	local createElement = React.createElement
	local root = Foundation.Sheet.Root
	local v16 = {
		isOpen = v13,
		snapPoints = { 1 },
		displaySize = Foundation.Enums.DialogSize.Large,
		preferCenterSheet = v14,
		centerSheetHeight = fFlagLuaAppSduiEventDetailsCenterSheet and 1 or nil,
		onClose = v15
	}

	local createElement2 = React.createElement
	local fullBleed = Foundation.Sheet.FullBleed

	local createElement3 = React.createElement
	local v20 = {
		appPage = appPage.EventDetails,
		configKey = v9,
		identifier = "event_details_sheet_full_bleed",
		shouldDisplayLoading = fFlagLuaAppSduiEventDetailsLoadingSlot,
		loadingSlot = 0,
		shouldDisplayError = false,
		Size = 0,
		AutomaticSize = 0
	}

	local v21 = if fFlagLuaAppSduiEventDetailsLoadingSlot then React.createElement(EventDetailsFullBleedSkeleton) else nil
	v20.loadingSlot = v21

	v20.Size = UDim2.fromScale(1, 1)
	v20.AutomaticSize = Enum.AutomaticSize.None
	local children = {
		FullBleed = createElement2(fullBleed, {
			aspectRatio = 16 / 9
		}, {
			FullBleedContent = createElement3(sduiFeatureEntryPoint, v20)
		}),
		Content = 0,
		Actions = 0
	}

	local createElement4 = React.createElement
	local content = Foundation.Sheet.Content

	local createElement5 = React.createElement
	local v24 = {
		appPage = appPage.EventDetails,
		configKey = v9,
		identifier = fFlagSduiPageEntryUseSharedHooks and "event_details_feed" or v9 .. "_event_details_feed",
		pageTimer = v10,
		includeNavigationHeaderBar = false,
		backgroundStyle = v5.Color.None,
		disableRootPadding = true,
		scrollingFrameRef = ref,
		snackbarPortalLayoutOrder = 2147483647,
		loadingSlot = 0
	}

	local v25 = if fFlagLuaAppSduiEventDetailsLoadingSlot then React.createElement(EventDetailsFeedSkeleton) else nil
	v24.loadingSlot = v25
	children.Content = createElement4(
		content,
		{ scrollingFrameRef = ref },
		createElement5(sduiPageEntryPoint, v24)
	)
	local v26

	if not fFlagLuaAppSduiEventDetailsActionBarInFeed then
		local createElement6 = React.createElement
		local actions = Foundation.Sheet.Actions

		local createElement7 = React.createElement
		local v29 = {
			appPage = appPage.EventDetails,
			configKey = v9,
			identifier = "event_details_action_bar",
			shouldDisplayLoading = fFlagLuaAppSduiEventDetailsLoadingSlot,
			loadingSlot = 0,
			shouldDisplayError = false
		}

		local v30 = if fFlagLuaAppSduiEventDetailsLoadingSlot then React.createElement(EventDetailsActionBarSkeleton) else nil
		v29.loadingSlot = v30
		v26 = createElement6(actions, nil, createElement7(sduiFeatureEntryPoint, v29))
	end

	children.Actions = v26
	return createElement(root, v16, children)
end

return React.memo(SduiEventDetailsPage)
