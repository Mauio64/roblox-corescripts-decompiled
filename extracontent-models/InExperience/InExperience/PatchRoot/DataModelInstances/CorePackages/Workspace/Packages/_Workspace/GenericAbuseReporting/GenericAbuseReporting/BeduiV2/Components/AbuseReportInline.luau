local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local Motion = require(parent.Motion)
local React = require(parent.React)

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useInExpFocusNavigationRefs = require(GenericAbuseReporting.BeduiV2.Hooks.FocusNavigation.useInExpFocusNavigationRefs)
local useScrollNavigationBindings = require(GenericAbuseReporting.BeduiV2.Hooks.FocusNavigation.useScrollNavigationBindings)

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
local arTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation)
local useArTranslation = arTranslation.useArTranslation

local INLINE_LANDSCAPE_WIDTH = LayoutSlots.INLINE_LANDSCAPE_WIDTH

local function AbuseReportInline(p)
	local v = useTokens()
	local translateIntoString = useArTranslation().translateIntoString

	local abuseReportFlow = p.abuseReportFlow
	local config = abuseReportFlow.config
	local currentPageElement = abuseReportFlow.currentPageElement
	local pendingInlineAlert = abuseReportFlow.pendingInlineAlert

	local createElement = React.createElement
	local v2

	if pendingInlineAlert then
		v2 = { Alert = 0 }
		local createElement2 = React.createElement
		local v3 = {
			severity = pendingInlineAlert.type,
			title = translateIntoString(pendingInlineAlert.title),
			subtitle = 0,
			onClose = 0,
			bottomMargin = 0,
			maxWidth = 0,
			layoutOrder = 1
		}
		local subtitle

		if pendingInlineAlert.subtitle then
			subtitle = translateIntoString(pendingInlineAlert.subtitle)
		end

		v3.subtitle = subtitle

		v3.onClose = abuseReportFlow.dismissInlineAlert
		local bottomMargin

		if not p.shouldUseOverlaidControls then
			bottomMargin = v.Padding.Medium
		end

		v3.bottomMargin = bottomMargin
		local maxWidth

		if p.shouldUseOverlaidControls then
			maxWidth = INLINE_LANDSCAPE_WIDTH * v.Config.UI.Scale
		end

		v3.maxWidth = maxWidth
		v2.Alert = createElement2(Feedback, v3)
	end

	local element = createElement(AnimatePresence, nil, v2)

	local element2 = React.createElement(SlideTransition, {
		nodeContent = React.createElement(View, { tag = "col align-x-center size-full" }, {
			FeedbackAlertElement = element,
			PageContent = React.createElement(
				View,
				{ tag = "col fill size-full-0", LayoutOrder = 2 },
				currentPageElement
			)
		}),
		nodeId = abuseReportFlow.currentNodeId,
		nodeType = abuseReportFlow.currentNodeType,
		direction = abuseReportFlow.navigationDirection
	})

	local useState = React.useState
	local v3

	if config.display.titleDisclosure then
		v3 = config.display.titleDisclosure.openByDefault or false
	else
		v3 = false
	end

	local state, setState = useState(v3)

	local v4 = React.useCallback(function()
		setState(function(p2): boolean
			return not p2
		end)
	end, {})

	local ref = useScrollNavigationBindings()

	local v5 = React.useCallback(function()
		setState(false)
	end, {})

	local ref2 = useInExpFocusNavigationRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, v5, state, state)

	local backButtonContainer = React.useMemo(function()
		return React.createElement(View, {
			tag = {
				["align-x-center auto-xy padding-y-small"] = true,
				["position-top-left anchor-top-left"] = p.shouldUseOverlaidControls
			},
			LayoutOrder = 1
		}, React.createElement(View, {
			isDisabled = not abuseReportFlow.canGoBack,
			selection = { Selectable = abuseReportFlow.canGoBack },
			onActivated = abuseReportFlow.goBack,
			tag = "auto-xy padding-small radius-circle"
		}, React.createElement(Icon, {
			name = IconName.ChevronLargeLeft,
			size = InputSize.Medium,
			style = {
				Transparency = abuseReportFlow.canGoBack and 0 or 1
			}
		})))
	end, { abuseReportFlow.canGoBack, abuseReportFlow.goBack, p.shouldUseOverlaidControls })

	local abuseReportTooltipContainer = React.useMemo(function()
		if config.display.titleDisclosure then
			return (React.createElement(View, {
				tag = {
					["align-x-center auto-xy padding-y-small"] = true,
					["position-top-right anchor-top-right"] = p.shouldUseOverlaidControls
				},
				LayoutOrder = 3,
				ZIndex = 2
			}, React.createElement(
				View,
				{ onActivated = v4, tag = "auto-xy padding-small radius-circle" },
				React.createElement(AbuseReportTooltip, {
					tooltipTitle = config.display.titleDisclosure.tooltipTitle,
					tooltipText = config.display.titleDisclosure.tooltipText,
					buttonLabel = config.display.titleDisclosure.buttonLabel,
					isOpen = state,
					onClose = v4,
					ref = ref2
				}, React.createElement(Icon, { name = IconName.CircleI, size = InputSize.Medium }))
			)))
		end

		return nil
	end, { config.display.titleDisclosure, ref2, v4, state, p.shouldUseOverlaidControls })

	return React.createElement(View, {
		tag = {
			["size-full"] = p.shouldUseOverlaidControls,
			["col size-full"] = not p.shouldUseOverlaidControls
		},
		ref = ref
	}, {
		TopControlsContainer = React.createElement(View, {
			tag = {
				["size-full"] = p.shouldUseOverlaidControls,
				["row flex-between size-full-0 auto-y"] = not p.shouldUseOverlaidControls
			},
			LayoutOrder = 1
		}, {
			BackButtonContainer = backButtonContainer,
			AbuseReportTooltipContainer = abuseReportTooltipContainer
		}),
		Content = React.createElement(View, {
			tag = {
				["col gap-xlarge size-full"] = p.shouldUseOverlaidControls,
				["col fill size-full-0 margin-bottom-medium"] = not p.shouldUseOverlaidControls
			},
			LayoutOrder = 2
		}, element2)
	})
end

return React.memo(AbuseReportInline)
