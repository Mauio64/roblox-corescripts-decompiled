local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local FocusNavigationUtils = require(GenericAbuseReportingParent.FocusNavigationUtils)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
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

return React.memo(function(t1: {[any]: any}) -- line: 35
	-- upvalues: React (copy), useFocusNavigationRefs (copy), FocusNavigableSurfaceIdentifierEnum (copy), Sheet (copy), View (copy), IconButton (copy), InputSize (copy), Foundation (copy), ButtonVariant (copy), AbuseReportTooltip (copy)
	local abuseReportFlow = t1.abuseReportFlow
	local config = abuseReportFlow.config
	local currentPageElement = abuseReportFlow.currentPageElement
	local canGoBack = abuseReportFlow.canGoBack
	local v19, v20 = React.useState(not not config.display.titleDisclosure and (config.display.titleDisclosure.openByDefault or false))
	local v21 = useFocusNavigationRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, function() -- line: 44
		-- upvalues: v20 (copy)
		v20(false)
	end)

	React.useEffect(function() -- line: 48
		-- upvalues: v19 (copy), t1 (copy)
		if v19 then
			t1.takeoverFocus(true)

			return
		end

		t1.takeoverFocus(false)
	end, {
		t1.takeoverFocus,
		v19
	})

	local v22 = React.useCallback(function() -- line: 56
		-- upvalues: v20 (copy)
		v20(function(p1) -- line: 57
			return not p1
		end)
	end, {})

	return React.createElement(React.Fragment, nil, {
		Header = React.createElement(Sheet.Header, nil, React.createElement(View, {
			tag = "size-full-0 auto-y row align-y-center gap-small flex-between"
		}, {
			React.createElement(View, {
				tag = "auto-xy row align-y-center gap-small"
			}, {
				BackIcon = if not canGoBack then nil else React.createElement(IconButton, {
					LayoutOrder = 1,
					size = InputSize.Medium,
					icon = Foundation.Enums.IconName.ChevronLargeLeft,
					variant = ButtonVariant.Utility,
					onActivated = abuseReportFlow.goBack
				})
			}),
			AbuseReportTooltip = if not config.display.titleDisclosure then nil else React.createElement(AbuseReportTooltip, {
				layoutOrder = 3,
				tooltipTitle = config.display.titleDisclosure.tooltipTitle,
				tooltipText = config.display.titleDisclosure.tooltipText,
				buttonLabel = config.display.titleDisclosure.buttonLabel,
				isOpen = v19,
				onClose = v22,
				ref = v21
			}, React.createElement(IconButton, {
				LayoutOrder = 3,
				size = InputSize.Medium,
				icon = Foundation.Enums.IconName.CircleI,
				variant = ButtonVariant.Utility,
				onActivated = v22
			}))
		})),
		Content = currentPageElement
	})
end)
