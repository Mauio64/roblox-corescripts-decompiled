local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local buttonVariant = Foundation.Enums.ButtonVariant
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local iconButton = Foundation.IconButton
local inputSize = Foundation.Enums.InputSize
local sheet = Foundation.Sheet
local view = Foundation.View

local AbuseReportTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/AbuseReportTooltip")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")
local useFocusNavigationRefs = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/FocusNavigation/useFocusNavigationRefs")

return React.memo(function(p2)
	local abuseReportFlow = p2.abuseReportFlow
	local config = abuseReportFlow.config
	local currentPageElement = abuseReportFlow.currentPageElement
	local canGoBack = abuseReportFlow.canGoBack

	local useState = React.useState
	local v5

	if config.display.titleDisclosure then
		v5 = config.display.titleDisclosure.openByDefault or false
	else
		v5 = false
	end

	local state, setState = useState(v5)

	local v6 = useFocusNavigationRefs(focusNavigableSurfaceIdentifierEnum.CentralOverlay, function()
		setState(false)
	end)

	React.useEffect(function()
		if state then
			p2.takeoverFocus(true)
		else
			p2.takeoverFocus(false)
		end
	end, { p2.takeoverFocus, state })

	local v7 = React.useCallback(function()
		setState(function(p3): boolean
			return not p3
		end)
	end, {})

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local header = sheet.Header

	local createElement3 = React.createElement

	local createElement4 = React.createElement

	local v17 = if canGoBack then React.createElement(iconButton, {
		size = inputSize.Medium,
		icon = Foundation.Enums.IconName.ChevronLargeLeft,
		variant = buttonVariant.Utility,
		onActivated = abuseReportFlow.goBack,
		LayoutOrder = 1
	}) else nil
	local v13 = { [1] = nil, (createElement4(view, {
			tag = "row align-y-center gap-small auto-xy"
		}, {
			BackIcon = v17
		})) }

	local v18 = if config.display.titleDisclosure then React.createElement(AbuseReportTooltip, {
		tooltipTitle = config.display.titleDisclosure.tooltipTitle,
		tooltipText = config.display.titleDisclosure.tooltipText,
		buttonLabel = config.display.titleDisclosure.buttonLabel,
		layoutOrder = 3,
		isOpen = state,
		onClose = v7,
		ref = v6
	}, React.createElement(iconButton, {
		size = inputSize.Medium,
		icon = Foundation.Enums.IconName.CircleI,
		variant = buttonVariant.Utility,
		onActivated = v7,
		LayoutOrder = 3
	})) else nil
	v13.AbuseReportTooltip = v18
	return createElement(fragment, nil, {
		Header = createElement2(
			header,
			nil,
			createElement3(
				view,
				{ tag = "row flex-between align-y-center gap-small size-full-0 auto-y" },
				v13
			)
		),
		Content = currentPageElement
	})
end)
