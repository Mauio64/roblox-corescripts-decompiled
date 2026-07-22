local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local FocusNavigationUtils = require(GenericAbuseReportingParent.FocusNavigationUtils)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local Motion = require(GenericAbuseReportingParent.Motion)
local React = require(GenericAbuseReportingParent.React)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useInExpFocusNavigationRefs = require(GenericAbuseReporting.BeduiV2.Hooks.FocusNavigation.useInExpFocusNavigationRefs)
local useScrollNavigationBindings = require(GenericAbuseReporting.BeduiV2.Hooks.FocusNavigation.useScrollNavigationBindings)
local FFlagAbuseReportSlideOutgoingInputSink = require(GenericAbuseReporting.Flags.FFlagAbuseReportSlideOutgoingInputSink)
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
local SlideTransitionLegacy = require(GenericAbuseReporting.BeduiV2.Components.SlideTransitionLegacy)
local SlideTransition = nil

if FFlagAbuseReportSlideOutgoingInputSink then
	SlideTransition = require(GenericAbuseReporting.BeduiV2.Components.SlideTransition)
end

local useArTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).useArTranslation
local INLINE_LANDSCAPE_WIDTH = LayoutSlots.INLINE_LANDSCAPE_WIDTH

local function AbuseReportInline(t1: {[any]: any}) -- line: 51
	-- upvalues: useTokens (copy), useArTranslation (copy), React (copy), AnimatePresence (copy), Feedback (copy), INLINE_LANDSCAPE_WIDTH (copy), FFlagAbuseReportSlideOutgoingInputSink (copy), SlideTransition (ref), SlideTransitionLegacy (copy), View (copy), FFlagAbuseReportV2ScrollNavigation (copy), useScrollNavigationBindings (copy), FFlagAbuseReportInlineTitleDisclosureFocus (copy), useInExpFocusNavigationRefs (copy), FocusNavigableSurfaceIdentifierEnum (copy), Icon (copy), IconName (copy), InputSize (copy), AbuseReportTooltip (copy)
	local v28 = useTokens()
	local translateIntoString = useArTranslation().translateIntoString
	local abuseReportFlow = t1.abuseReportFlow
	local config = abuseReportFlow.config
	local currentPageElement = abuseReportFlow.currentPageElement
	local pendingInlineAlert = abuseReportFlow.pendingInlineAlert
	local v34 = React.createElement(AnimatePresence, nil, if not pendingInlineAlert then nil else {
		Alert = React.createElement(Feedback, {
			layoutOrder = 1,
			severity = pendingInlineAlert.type,
			title = translateIntoString(pendingInlineAlert.title),
			subtitle = if not pendingInlineAlert.subtitle then nil else translateIntoString(pendingInlineAlert.subtitle),
			onClose = abuseReportFlow.dismissInlineAlert,
			bottomMargin = if not t1.shouldUseOverlaidControls then v28.Padding.Medium else nil,
			maxWidth = if not t1.shouldUseOverlaidControls then nil else INLINE_LANDSCAPE_WIDTH * v28.Config.UI.Scale
		})
	})
	local v35 = if not FFlagAbuseReportSlideOutgoingInputSink then SlideTransitionLegacy else SlideTransition
	local v36 = React.createElement(v35, {
		nodeContent = React.createElement(View, {
			tag = "col align-x-center size-full"
		}, {
			FeedbackAlertElement = v34,
			PageContent = React.createElement(View, {
				tag = "col fill size-full-0",
				LayoutOrder = 2
			}, currentPageElement)
		}),
		nodeId = abuseReportFlow.currentNodeId,
		nodeType = abuseReportFlow.currentNodeType,
		direction = abuseReportFlow.navigationDirection
	})
	local v37, v38 = React.useState(not not config.display.titleDisclosure and (config.display.titleDisclosure.openByDefault or false))
	local v39 = React.useCallback(function() -- line: 112
		-- upvalues: v38 (copy)
		v38(function(p1) -- line: 113
			return not p1
		end)
	end, {})
	local v40 = nil

	if FFlagAbuseReportV2ScrollNavigation then
		v40 = useScrollNavigationBindings()
	end

	local u41 = nil

	if FFlagAbuseReportInlineTitleDisclosureFocus then
		local v42 = React.useCallback(function() -- line: 125
			-- upvalues: v38 (copy)
			v38(false)
		end, {})

		u41 = useInExpFocusNavigationRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, v42, v37, v37)
	end

	local v43 = React.useMemo(function() -- line: 142
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
	local v44 = React.useMemo(function() -- line: 174
		-- upvalues: config (copy), React (copy), View (copy), t1 (copy), v39 (copy), AbuseReportTooltip (copy), v37 (copy), FFlagAbuseReportInlineTitleDisclosureFocus (copy), u41 (ref), Icon (copy), IconName (copy), InputSize (copy)
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
				onActivated = v39
			}, React.createElement(AbuseReportTooltip, {
				tooltipTitle = config.display.titleDisclosure.tooltipTitle,
				tooltipText = config.display.titleDisclosure.tooltipText,
				buttonLabel = config.display.titleDisclosure.buttonLabel,
				isOpen = v37,
				onClose = v39,
				ref = if not FFlagAbuseReportInlineTitleDisclosureFocus then nil else u41
			}, React.createElement(Icon, {
				name = IconName.CircleI,
				size = InputSize.Medium
			})))))
		end

		return nil
	end, {
		config.display.titleDisclosure,
		if not FFlagAbuseReportInlineTitleDisclosureFocus then nil else u41,
		v39,
		v37,
		t1.shouldUseOverlaidControls
	})

	return React.createElement(View, {
		tag = {
			["size-full"] = t1.shouldUseOverlaidControls,
			["col size-full"] = not t1.shouldUseOverlaidControls
		},
		ref = if not FFlagAbuseReportV2ScrollNavigation then nil else v40
	}, {
		TopControlsContainer = React.createElement(View, {
			LayoutOrder = 1,
			tag = {
				["size-full"] = t1.shouldUseOverlaidControls,
				["row flex-between size-full-0 auto-y"] = not t1.shouldUseOverlaidControls
			}
		}, {
			BackButtonContainer = v43,
			AbuseReportTooltipContainer = v44
		}),
		Content = React.createElement(View, {
			LayoutOrder = 2,
			tag = {
				["col gap-xlarge size-full"] = t1.shouldUseOverlaidControls,
				["col fill size-full-0 margin-bottom-medium"] = not t1.shouldUseOverlaidControls
			}
		}, v36)
	})
end

return React.memo(AbuseReportInline)
