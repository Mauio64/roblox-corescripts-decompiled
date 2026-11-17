local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local FoundationProvider = Foundation.FoundationProvider
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local ColorMode = Foundation.Enums.ColorMode
local ThemeName = Foundation.Enums.ThemeName
local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens

require(AmpV2Wizard.Types)
local useWizardWalker = require(AmpV2Wizard.useWizardWalker)
local ComponentRegistry = require(AmpV2Wizard.ComponentRegistry)
local WizardSpinner = require(AmpV2Wizard.WizardSpinner)
local GenericErrorModal = require(AmpV2Wizard.GenericErrorModal)
local UnknownNodeDebugView = require(AmpV2Wizard.UnknownNodeDebugView)
local getFFlagAmpV2WizardDebugUnknownNodes = require(AmpV2Wizard.getFFlagAmpV2WizardDebugUnknownNodes)
local isParentModeThemedNode = require(AmpV2Wizard.isParentModeThemedNode)
local SharedFlags = require(parent.SharedFlags)
local FFlagAmpV2WizardParentModeNavTheme = SharedFlags.FFlagAmpV2WizardParentModeNavTheme
local useSyncParentModeChromeTheme

if FFlagAmpV2WizardParentModeNavTheme then
	useSyncParentModeChromeTheme = require(AmpV2Wizard.useSyncParentModeChromeTheme)
else
	useSyncParentModeChromeTheme = nil
end

local FFlagAmpV2WizardNoCanvasGroupDim = require(AmpV2Wizard.FFlagAmpV2WizardNoCanvasGroupDim)
local FFlagAmpV2WizardVendorOverlay = require(AmpV2Wizard.FFlagAmpV2WizardVendorOverlay)
local FFlagAmpV2WizardServerParentFacing = require(AmpV2Wizard.FFlagAmpV2WizardServerParentFacing)
local FFlagAmpV2WizardAuthorizationModal = require(AmpV2Wizard.FFlagAmpV2WizardAuthorizationModal)
local usePresentedOverPage = require(AmpV2Wizard.usePresentedOverPage)
local useWizardViewportLayout = require(AmpV2Wizard.useWizardViewportLayout)

local function noopReport(_: string, _) end

local function ParentModeTheme(p)
	local v = usePreferences()
	local v2 = useTokens()
	local scale = v2.Config.UI.Scale

	local colorMode = v2.Config.ColorMode.Name == ColorMode.Light and "Light" or "Dark"

	return React.createElement(View, {
		tag = "size-full",
		testId = "amp-v2-wizard-parent-mode-theme"
	}, {
		Theme = React.createElement(FoundationProvider, {
			themeName = ThemeName.Default,
			colorMode = colorMode,
			preferences = {
				preferredTextSize = v.preferredTextSize,
				preferredTransparency = v.preferredTransparency,
				reducedMotion = v.reducedMotion,
				scale = scale
			}
		}, p.children)
	})
end

local function LoadingScrim(p)
	local v = useTokens()

	return React.createElement(View, {
		tag = "size-full",
		backgroundStyle = { Color3 = v.Color.Common.Backdrop.Color3, Transparency = 0.5 },
		testId = "amp-v2-wizard-loading-scrim"
	}, p.children)
end

local function OverlayWizardHost(props)
	local registry = props.registry or ComponentRegistry.default
	local v, v2 = useWizardViewportLayout()

	local v3 = useWizardWalker({
		initialFragment = props.initialFragment,
		surface = props.surface,
		target = props.target,
		rootFlow = props.rootFlow,
		api = props.api,
		onExit = props.onExit,
		onEvent = props.onEvent
	})

	local ref = React.useRef(false)
	local currentNode = v3.currentNode
	local v4

	if currentNode then
		v4 = ComponentRegistry.get(registry, currentNode.type)
	else
		v4 = nil
	end

	React.useEffect(function()
		if getFFlagAmpV2WizardDebugUnknownNodes() then
			return
		end

		if currentNode ~= nil and v4 == nil and not (v3.exited or ref.current) then
			ref.current = true

			v3.report("__unrenderable__")
		end
	end, { currentNode, v4, v3.exited, v3.report })
	local v5

	if currentNode == nil then
		v5 = false
	else
		v5 = ComponentRegistry.ownsLoadingState(registry, currentNode.type)
	end

	local v6

	if currentNode == nil then
		v6 = false
	else
		v6 = ComponentRegistry.fillsViewport(registry, currentNode.type)
	end

	local v7

	if FFlagAmpV2WizardVendorOverlay then
		v7 = usePresentedOverPage(currentNode, v4, v6)
	end

	local visible = FFlagAmpV2WizardAuthorizationModal

	if visible then
		if currentNode == nil then
			visible = false
		else
			visible = currentNode.type == "SessionPolling"
		end
	end

	local v8 = v7 ~= nil
	local isLoading = v3.isLoading or v8

	if v8 then
		v5 = ComponentRegistry.ownsLoadingState(registry, v7.node.type)
	end

	local v9 = visible and true or v5
	local groupTransparency, v10 = React.useBinding(0)
	React.useEffect(function()
		v10(isLoading and not v9 and 0.5 or 0)
	end, { isLoading, v9 })

	if FFlagAmpV2WizardParentModeNavTheme then
		useSyncParentModeChromeTheme(v3.exited, v3.presentingError, currentNode, v3.currentNodeId, v4, v7)
	end

	if v3.exited then
		return nil
	end

	if v3.presentingError then
		return React.createElement(View, {
			tag = "col align-x-center align-y-center size-full padding-large"
		}, {
			ErrorModal = React.createElement(GenericErrorModal, { onClose = v3.acknowledgeError })
		})
	end

	local v11 = getFFlagAmpV2WizardDebugUnknownNodes()

	if v11 then
		if currentNode == nil then
			v11 = false
		else
			v11 = v4 == nil
		end
	end

	if currentNode == nil or v4 == nil and not v11 then
		return React.createElement(WizardSpinner)
	end

	local v12 = if v8 then v7.node else currentNode
	local v13 = if v8 then v7.component else v4

	local launchProps = props.flowProps

	if props.odpEventUniverseId ~= nil and props.odpEventUniverseId ~= "" then
		launchProps = launchProps == nil and {} or table.clone(launchProps)
		launchProps.universeId = props.odpEventUniverseId
	end

	local ctx = {
		onTerminalRedirect = props.onTerminalRedirect,
		analytics = v3.eventContext,
		logEvent = v3.logEvent,
		odpEventContext = props.odpEventContext,
		launchProps = launchProps,
		analyticsStrings = v3.analyticsStrings,
		analyticsSessionId = v3.analyticsSessionId
	}
	local node

	if v11 then
		node = React.createElement(UnknownNodeDebugView, {
			nodeType = currentNode.type,
			details = currentNode.details,
			transitions = currentNode.transitions,
			report = v3.report
		})
	else
		local createElement = React.createElement
		local v14 = {
			props = v12.details,
			ctx = ctx,
			report = 0,
			transitions = 0,
			dismiss = 0
		}

		local report = if v8 then noopReport else v3.report
		v14.report = report
		v14.transitions = v12.transitions
		local dismiss

		if visible then
			dismiss = v3.dismissPresentation
		end

		v14.dismiss = dismiss
		node = createElement(v13, v14)
	end

	if v8 then
		v6 = ComponentRegistry.fillsViewport(registry, v12.type)
	end

	local presentingNode

	if v8 then
		local createElement = React.createElement
		local v14 = {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Visible = visible,
			ZIndex = visible and 3 or nil
		}

		local createElement2 = React.createElement
		local v15 = {
			props = currentNode.details,
			ctx = ctx,
			report = v3.report,
			transitions = currentNode.transitions,
			dismiss = 0
		}
		local dismiss

		if visible then
			dismiss = v3.dismissPresentation
		end

		v15.dismiss = dismiss
		presentingNode = createElement("Frame", v14, { Node = createElement2(v4, v15) })
	end

	if not v6 then
		v = nil
	end

	local position

	if v then
		position = v.contentPosition
	end

	local size

	if v then
		size = v.contentSize
	end

	local v14 = {
		Position = position,
		Size = size,
		ZIndex = v6 and 1 or nil,
		tag = {
			["size-full"] = true,
			col = not v6,
			["align-x-center"] = not v6,
			["align-y-center"] = not v6,
			["padding-large"] = not v6
		},
		GroupTransparency = 0
	}

	if FFlagAmpV2WizardNoCanvasGroupDim then
		groupTransparency = nil
	end

	v14.GroupTransparency = groupTransparency
	local background

	if v6 then
		local createElement = React.createElement
		local position2

		if v then
			position2 = v.backgroundPosition
		end

		local size2

		if v then
			size2 = v.backgroundSize
		end

		background = createElement(View, {
			tag = "size-full bg-surface-0",
			Position = position2,
			Size = size2,
			ZIndex = 0,
			testId = "amp-v2-wizard-viewport-background"
		})
	end

	local v15 = {
		Background = background,
		Content = React.createElement(View, v14, { Node = node }),
		LoadingOverlay = 0
	}
	local loadingOverlay

	if isLoading and (not visible or v8) then
		local createElement = React.createElement
		local position2

		if v then
			position2 = v.backgroundPosition
		end

		local size2

		if v then
			size2 = v.backgroundSize
		end

		local v16 = {
			tag = "size-full",
			Position = position2,
			Size = size2,
			ZIndex = 2,
			onActivated = function() end,
			stateLayer = { affordance = StateLayerAffordance.None },
			testId = "amp-v2-wizard-loading-overlay"
		}
		local spinner

		if not (v9 or FFlagAmpV2WizardNoCanvasGroupDim) then
			spinner = React.createElement(WizardSpinner)
		end

		local scrim

		if visible then
			scrim = React.createElement(LoadingScrim, { children = {} })
		elseif FFlagAmpV2WizardNoCanvasGroupDim and not v9 then
			scrim = React.createElement(LoadingScrim, {
				children = {
					Spinner = React.createElement(WizardSpinner)
				}
			})
		end

		loadingOverlay = createElement(View, v16, { Spinner = spinner, Scrim = scrim })
	end

	v15.LoadingOverlay = loadingOverlay

	if presentingNode ~= nil then
		v15.PresentingNode = presentingNode
	end

	local element = React.createElement(
		View,
		{ tag = "size-full", ref = v2, onAbsolutePositionChanged = v2, onAbsoluteSizeChanged = v2 },
		v15
	)

	if FFlagAmpV2WizardServerParentFacing then
		if v12.behavior == nil or v12.behavior.parentFacing ~= true then
			return element
		end

		return React.createElement(ParentModeTheme, nil, element)
	elseif isParentModeThemedNode(v12.type, v3.currentNodeId) then
		return React.createElement(ParentModeTheme, nil, element)
	else
		return element
	end
end

return OverlayWizardHost
