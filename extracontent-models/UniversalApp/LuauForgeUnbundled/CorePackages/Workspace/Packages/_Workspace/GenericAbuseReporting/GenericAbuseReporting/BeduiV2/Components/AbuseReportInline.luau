local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local Motion = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Motion")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useInExpFocusNavigationRefs = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/FocusNavigation/useInExpFocusNavigationRefs")
local useScrollNavigationBindings = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/FocusNavigation/useScrollNavigationBindings")

local animatePresence = Motion.AnimatePresence
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View

local AbuseReportTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/AbuseReportTooltip")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local Feedback = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Feedback")
local LayoutSlots = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/LayoutSlots")
local SlideTransition = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/SlideTransition")
local useArTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/arTranslation").useArTranslation

local INLINE_LANDSCAPE_WIDTH = LayoutSlots.INLINE_LANDSCAPE_WIDTH

local function AbuseReportInline(p2)
	local v5 = useTokens()
	local translateIntoString = useArTranslation().translateIntoString

	local abuseReportFlow = p2.abuseReportFlow
	local config = abuseReportFlow.config
	local currentPageElement = abuseReportFlow.currentPageElement
	local pendingInlineAlert = abuseReportFlow.pendingInlineAlert

	local createElement = React.createElement
	local v8

	if pendingInlineAlert then
		v8 = { Alert = 0 }
		local createElement2 = React.createElement
		local v10 = {
			severity = pendingInlineAlert.type,
			title = translateIntoString(pendingInlineAlert.title),
			subtitle = 0,
			onClose = 0,
			bottomMargin = 0,
			maxWidth = 0,
			layoutOrder = 1
		}
		local v11 = if pendingInlineAlert.subtitle then translateIntoString(pendingInlineAlert.subtitle) else nil
		v10.subtitle = v11

		v10.onClose = abuseReportFlow.dismissInlineAlert

		local v12 = if not p2.shouldUseOverlaidControls then v5.Padding.Medium else nil
		v10.bottomMargin = v12
		local v13 = if p2.shouldUseOverlaidControls then INLINE_LANDSCAPE_WIDTH * v5.Config.UI.Scale else nil
		v10.maxWidth = v13
		v8.Alert = createElement2(Feedback, v10)
	end

	local element = createElement(animatePresence, nil, v8)

	local element2 = React.createElement(SlideTransition, {
		nodeContent = React.createElement(view, {
			tag = "col align-x-center size-full"
		}, {
			FeedbackAlertElement = element,
			PageContent = React.createElement(
				view,
				{ tag = "col fill size-full-0", LayoutOrder = 2 },
				currentPageElement
			)
		}),
		nodeId = abuseReportFlow.currentNodeId,
		nodeType = abuseReportFlow.currentNodeType,
		direction = abuseReportFlow.navigationDirection
	})

	local useState = React.useState
	local v9

	if config.display.titleDisclosure then
		v9 = config.display.titleDisclosure.openByDefault or false
	else
		v9 = false
	end

	local state, setState = useState(v9)

	local v10 = React.useCallback(function()
		setState(function(p3): boolean
			return not p3
		end)
	end, {})

	local v11 = useScrollNavigationBindings()

	local v12 = React.useCallback(function()
		setState(false)
	end, {})

	local v13 = useInExpFocusNavigationRefs(focusNavigableSurfaceIdentifierEnum.CentralOverlay, v12, state, state)

	local v14 = React.useMemo(function()
		return React.createElement(view, {
			tag = {
				["align-x-center auto-xy padding-y-small"] = true,
				["position-top-left anchor-top-left"] = p2.shouldUseOverlaidControls
			},
			LayoutOrder = 1
		}, React.createElement(view, {
			isDisabled = not abuseReportFlow.canGoBack,
			selection = { Selectable = abuseReportFlow.canGoBack },
			onActivated = abuseReportFlow.goBack,
			tag = "auto-xy padding-small radius-circle"
		}, React.createElement(icon, {
			name = iconName.ChevronLargeLeft,
			size = inputSize.Medium,
			style = {
				Transparency = abuseReportFlow.canGoBack and 0 or 1
			}
		})))
	end, { abuseReportFlow.canGoBack, abuseReportFlow.goBack, p2.shouldUseOverlaidControls })

	local v15 = React.useMemo(function()
		if config.display.titleDisclosure then
			return (React.createElement(view, {
				tag = {
					["align-x-center auto-xy padding-y-small"] = true,
					["position-top-right anchor-top-right"] = p2.shouldUseOverlaidControls
				},
				LayoutOrder = 3,
				ZIndex = 2
			}, React.createElement(
				view,
				{ onActivated = v10, tag = "auto-xy padding-small radius-circle" },
				React.createElement(AbuseReportTooltip, {
					tooltipTitle = config.display.titleDisclosure.tooltipTitle,
					tooltipText = config.display.titleDisclosure.tooltipText,
					buttonLabel = config.display.titleDisclosure.buttonLabel,
					isOpen = state,
					onClose = v10,
					ref = v13
				}, React.createElement(icon, {
					name = iconName.CircleI,
					size = inputSize.Medium
				}))
			)))
		end

		return nil
	end, {
		config.display.titleDisclosure,
		v13,
		v10,
		state,
		p2.shouldUseOverlaidControls
	})

	return React.createElement(view, {
		tag = {
			["size-full"] = p2.shouldUseOverlaidControls,
			["col size-full"] = not p2.shouldUseOverlaidControls
		},
		ref = v11
	}, {
		TopControlsContainer = React.createElement(view, {
			tag = {
				["size-full"] = p2.shouldUseOverlaidControls,
				["row flex-between size-full-0 auto-y"] = not p2.shouldUseOverlaidControls
			},
			LayoutOrder = 1
		}, { BackButtonContainer = v14, AbuseReportTooltipContainer = v15 }),
		Content = React.createElement(view, {
			tag = {
				["col gap-xlarge size-full"] = p2.shouldUseOverlaidControls,
				["col fill size-full-0 margin-bottom-medium"] = not p2.shouldUseOverlaidControls
			},
			LayoutOrder = 2
		}, element2)
	})
end

return React.memo(AbuseReportInline)
