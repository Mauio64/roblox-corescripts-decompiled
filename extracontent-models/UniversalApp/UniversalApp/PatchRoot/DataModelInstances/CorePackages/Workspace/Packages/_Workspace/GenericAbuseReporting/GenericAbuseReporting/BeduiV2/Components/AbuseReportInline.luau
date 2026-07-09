local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local FocusNavigationUtils = require(GenericAbuseReportingParent.FocusNavigationUtils)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local Motion = require(GenericAbuseReportingParent.Motion)
local React = require(GenericAbuseReportingParent.React)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useInExpFocusNavigationRefs = require(GenericAbuseReporting.BeduiV2.Hooks.FocusNavigation.useInExpFocusNavigationRefs)
local useScrollNavigationBindings = require(GenericAbuseReporting.BeduiV2.Hooks.FocusNavigation.useScrollNavigationBindings)
local FFlagAbuseReportV2ScrollNavigation = require(GenericAbuseReporting.Flags.FFlagAbuseReportV2ScrollNavigation)
local FFlagAbuseReportInlineTitleDisclosureFocus = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportInlineTitleDisclosureFocus
local AnimatePresence = Motion.AnimatePresence
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local AbuseReportTooltip = require(GenericAbuseReporting.BeduiV2.Components.AbuseReportTooltip)

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)

local Feedback = require(GenericAbuseReporting.BeduiV2.Components.Feedback)
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local SlideTransition = require(GenericAbuseReporting.BeduiV2.Components.SlideTransition)
local useArTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).useArTranslation
local INLINE_LANDSCAPE_WIDTH = LayoutSlots.INLINE_LANDSCAPE_WIDTH

local function AbuseReportInline(t1: {[any]: any}) -- line: 46
	-- upvalues: useTokens (copy), useArTranslation (copy), React (copy), AnimatePresence (copy), Feedback (copy), INLINE_LANDSCAPE_WIDTH (copy), SlideTransition (copy), View (copy), FFlagAbuseReportV2ScrollNavigation (copy), useScrollNavigationBindings (copy), FFlagAbuseReportInlineTitleDisclosureFocus (copy), useInExpFocusNavigationRefs (copy), FocusNavigableSurfaceIdentifierEnum (copy), Icon (copy), IconName (copy), InputSize (copy), AbuseReportTooltip (copy)
	local v26 = useTokens()
	local translateIntoString = useArTranslation().translateIntoString
	local abuseReportFlow = t1.abuseReportFlow
	local config = abuseReportFlow.config
	local currentPageElement = abuseReportFlow.currentPageElement
	local pendingInlineAlert = abuseReportFlow.pendingInlineAlert
	local v32 = React.createElement(AnimatePresence, nil, if not pendingInlineAlert then nil else {
		Alert = React.createElement(Feedback, {
			layoutOrder = 1,
			severity = pendingInlineAlert.type,
			title = translateIntoString(pendingInlineAlert.title),
			subtitle = if not pendingInlineAlert.subtitle then nil else translateIntoString(pendingInlineAlert.subtitle),
			onClose = abuseReportFlow.dismissInlineAlert,
			bottomMargin = if not t1.shouldUseOverlaidControls then v26.Padding.Medium else nil,
			maxWidth = if not t1.shouldUseOverlaidControls then nil else INLINE_LANDSCAPE_WIDTH * v26.Config.UI.Scale
		})
	})
	local v33 = React.createElement(SlideTransition, {
		nodeContent = React.createElement(View, {
			tag = "col align-x-center size-full"
		}, {
			FeedbackAlertElement = v32,
			PageContent = React.createElement(View, {
				tag = "col fill size-full-0",
				LayoutOrder = 2
			}, currentPageElement)
		}),
		nodeId = abuseReportFlow.currentNodeId,
		nodeType = abuseReportFlow.currentNodeType,
		direction = abuseReportFlow.navigationDirection
	})
	local v34, v35 = React.useState(not not config.display.titleDisclosure and (config.display.titleDisclosure.openByDefault or false))
	local v36 = React.useCallback(function() -- line: 106
		-- upvalues: v35 (copy)
		v35(function(p1) -- line: 107
			return not p1
		end)
	end, {})
	local v37 = nil

	if FFlagAbuseReportV2ScrollNavigation then
		v37 = useScrollNavigationBindings()
	end

	local u38 = nil

	if FFlagAbuseReportInlineTitleDisclosureFocus then
		local v39 = React.useCallback(function() -- line: 119
			-- upvalues: v35 (copy)
			v35(false)
		end, {})

		u38 = useInExpFocusNavigationRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, v39, v34, v34)
	end

	local v40 = React.useMemo(function() -- line: 136
		-- upvalues: React (copy), View (copy), t1 (copy), abuseReportFlow (copy), Icon (copy), IconName (copy), InputSize (copy)
		return React.createElement(View, {
			LayoutOrder = 1,
			tag = {
				["align-x-center auto-xy padding-y-small"] = true,
				["position-top-left anchor-top-left"] = t1.shouldUseOverlaidControls
			}
		}, React.createElement(View, {
			tag = "auto-xy padding-small radius-circle",
			isDisabled = not abuseReportFlow.canGoBack,
			selection = {
				Selectable = abuseReportFlow.canGoBack
			},
			onActivated = abuseReportFlow.goBack
		}, React.createElement(Icon, {
			name = IconName.ChevronLargeLeft,
			size = InputSize.Medium,
			style = {
				Transparency = not abuseReportFlow.canGoBack and 1 or 0
			}
		})))
	end, {
		abuseReportFlow.canGoBack,
		abuseReportFlow.goBack,
		t1.shouldUseOverlaidControls
	})
	local v41 = React.useMemo(function() -- line: 168
		-- upvalues: config (copy), React (copy), View (copy), t1 (copy), v36 (copy), AbuseReportTooltip (copy), v34 (copy), FFlagAbuseReportInlineTitleDisclosureFocus (copy), u38 (ref), Icon (copy), IconName (copy), InputSize (copy)
		if config.display.titleDisclosure then
			return (React.createElement(View, {
				LayoutOrder = 3,
				ZIndex = 2,
				tag = {
					["align-x-center auto-xy padding-y-small"] = true,
					["position-top-right anchor-top-right"] = t1.shouldUseOverlaidControls
				}
			}, React.createElement(View, {
				tag = "auto-xy padding-small radius-circle",
				onActivated = v36
			}, React.createElement(AbuseReportTooltip, {
				tooltipTitle = config.display.titleDisclosure.tooltipTitle,
				tooltipText = config.display.titleDisclosure.tooltipText,
				buttonLabel = config.display.titleDisclosure.buttonLabel,
				isOpen = v34,
				onClose = v36,
				ref = if not FFlagAbuseReportInlineTitleDisclosureFocus then nil else u38
			}, React.createElement(Icon, {
				name = IconName.CircleI,
				size = InputSize.Medium
			})))))
		end

		return nil
	end, {
		config.display.titleDisclosure,
		if not FFlagAbuseReportInlineTitleDisclosureFocus then nil else u38,
		v36,
		v34,
		t1.shouldUseOverlaidControls
	})

	return React.createElement(View, {
		tag = {
			["size-full"] = t1.shouldUseOverlaidControls,
			["col size-full"] = not t1.shouldUseOverlaidControls
		},
		ref = if not FFlagAbuseReportV2ScrollNavigation then nil else v37
	}, {
		TopControlsContainer = React.createElement(View, {
			LayoutOrder = 1,
			tag = {
				["size-full"] = t1.shouldUseOverlaidControls,
				["row flex-between size-full-0 auto-y"] = not t1.shouldUseOverlaidControls
			}
		}, {
			BackButtonContainer = v40,
			AbuseReportTooltipContainer = v41
		}),
		Content = React.createElement(View, {
			LayoutOrder = 2,
			tag = {
				["col gap-xlarge size-full"] = t1.shouldUseOverlaidControls,
				["col fill size-full-0 margin-bottom-medium"] = not t1.shouldUseOverlaidControls
			}
		}, v33)
	})
end

return React.memo(AbuseReportInline)
