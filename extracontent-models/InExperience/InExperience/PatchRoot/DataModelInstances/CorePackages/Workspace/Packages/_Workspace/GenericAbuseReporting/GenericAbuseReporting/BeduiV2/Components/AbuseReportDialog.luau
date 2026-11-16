local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local ButtonVariant = Foundation.Enums.ButtonVariant
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local IconButton = Foundation.IconButton
local InputSize = Foundation.Enums.InputSize
local Sheet = Foundation.Sheet
local View = Foundation.View

local AbuseReportTooltip = require(GenericAbuseReporting.BeduiV2.Components.AbuseReportTooltip)
require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
require(GenericAbuseReporting.Enums.AbuseVector)
local useFocusNavigationRefs = require(GenericAbuseReporting.BeduiV2.Hooks.FocusNavigation.useFocusNavigationRefs)

return React.memo(function(p)
	local abuseReportFlow = p.abuseReportFlow
	local config = abuseReportFlow.config
	local currentPageElement = abuseReportFlow.currentPageElement
	local canGoBack = abuseReportFlow.canGoBack

	local useState = React.useState
	local v

	if config.display.titleDisclosure then
		v = config.display.titleDisclosure.openByDefault or false
	else
		v = false
	end

	local state, setState = useState(v)

	local ref = useFocusNavigationRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, function()
		setState(false)
	end)

	React.useEffect(function()
		if state then
			p.takeoverFocus(true)
		else
			p.takeoverFocus(false)
		end
	end, { p.takeoverFocus, state })

	local v2 = React.useCallback(function()
		setState(function(p2): boolean
			return not p2
		end)
	end, {})

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local header = Sheet.Header

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local backIcon

	if canGoBack then
		backIcon = React.createElement(IconButton, {
			size = InputSize.Medium,
			icon = Foundation.Enums.IconName.ChevronLargeLeft,
			variant = ButtonVariant.Utility,
			onActivated = abuseReportFlow.goBack,
			LayoutOrder = 1
		})
	end

	local v3 = { [1] = nil, (createElement4(View, {
			tag = "row align-y-center gap-small auto-xy"
		}, {
			BackIcon = backIcon
		})) }
	local abuseReportTooltip

	if config.display.titleDisclosure then
		abuseReportTooltip = React.createElement(AbuseReportTooltip, {
			tooltipTitle = config.display.titleDisclosure.tooltipTitle,
			tooltipText = config.display.titleDisclosure.tooltipText,
			buttonLabel = config.display.titleDisclosure.buttonLabel,
			layoutOrder = 3,
			isOpen = state,
			onClose = v2,
			ref = ref
		}, React.createElement(IconButton, {
			size = InputSize.Medium,
			icon = Foundation.Enums.IconName.CircleI,
			variant = ButtonVariant.Utility,
			onActivated = v2,
			LayoutOrder = 3
		}))
	end

	v3.AbuseReportTooltip = abuseReportTooltip
	return createElement(fragment, nil, {
		Header = createElement2(
			header,
			nil,
			createElement3(View, {
				tag = "row flex-between align-y-center gap-small size-full-0 auto-y"
			}, v3)
		),
		Content = currentPageElement
	})
end)
