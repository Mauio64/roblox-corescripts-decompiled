local module = require("@luauforge/bundled/gvb")

local module2 = require("@luauforge/bundled/gvj")
local view = module2.View
local foundationProvider = module2.FoundationProvider
local stateLayerAffordance = module2.Enums.StateLayerAffordance
local colorMode = module2.Enums.ColorMode
local themeName = module2.Enums.ThemeName
local usePreferences = module2.Hooks.usePreferences
local useTokens = module2.Hooks.useTokens

require("@luauforge/bundled/gvc")
local module3 = require("@luauforge/bundled/gwl")
local module4 = require("@luauforge/bundled/gvh")
local LoadingStatePage = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Container/LoadingStatePage")
local module6 = require("@luauforge/bundled/gwB")
local module7 = require("@luauforge/bundled/gwC")
local module8 = require("@luauforge/bundled/gwD")
local module9 = require("@luauforge/bundled/gwE")
local fFlagAmpV2WizardParentModeNavTheme = require("@luauforge/bundled/gvp").FFlagAmpV2WizardParentModeNavTheme

local v5 = if fFlagAmpV2WizardParentModeNavTheme then require("@luauforge/bundled/gwF") else nil

local module10 = require("@luauforge/bundled/gwK")
local module11 = require("@luauforge/bundled/gvM")
local module12 = require("@luauforge/bundled/gwI")
local module13 = require("@luauforge/bundled/gvL")
local module14 = require("@luauforge/bundled/gwJ")
local module15 = require("@luauforge/bundled/gwL")

local function noopReport(p2, p3) end

local function ParentModeTheme(p2)
	local v6 = usePreferences()
	local v7 = useTokens()
	local scale = v7.Config.UI.Scale

	local v8 = v7.Config.ColorMode.Name == colorMode.Light and "Light" or "Dark"

	return module.createElement(view, {
		tag = "size-full",
		testId = "amp-v2-wizard-parent-mode-theme"
	}, {
		Theme = module.createElement(foundationProvider, {
			themeName = themeName.Default,
			colorMode = v8,
			preferences = {
				preferredTextSize = v6.preferredTextSize,
				preferredTransparency = v6.preferredTransparency,
				reducedMotion = v6.reducedMotion,
				scale = scale
			}
		}, p2.children)
	})
end

local function LoadingScrim(p2)
	local v6 = useTokens()

	return module.createElement(view, {
		tag = "size-full",
		backgroundStyle = {
			Color3 = v6.Color.Common.Backdrop.Color3,
			Transparency = 0.5
		},
		testId = "amp-v2-wizard-loading-scrim"
	}, p2.children)
end

local function OverlayWizardHost(props)
	local registry = props.registry or module4.default
	local v6, v7 = module15()

	local v8 = module3({
		initialFragment = props.initialFragment,
		surface = props.surface,
		target = props.target,
		rootFlow = props.rootFlow,
		api = props.api,
		onExit = props.onExit,
		onEvent = props.onEvent
	})

	local ref = module.useRef(false)
	local currentNode = v8.currentNode
	local v9 = if currentNode then module4.get(registry, currentNode.type) else nil

	module.useEffect(function()
		if module8() then
			return
		end

		if currentNode ~= nil and v9 == nil and not (v8.exited or ref.current) then
			ref.current = true

			v8.report("__unrenderable__")
		end
	end, { currentNode, v9, v8.exited, v8.report })

	local v10 = not (currentNode == nil) and module4.ownsLoadingState(registry, currentNode.type)
	local v11 = not (currentNode == nil) and module4.fillsViewport(registry, currentNode.type)

	local v12 = if module11 then module14(currentNode, v9, v11) else nil

	local v13 = module13

	if v13 then
		v13 = not (currentNode == nil) and currentNode.type == "SessionPolling"
	end

	local v14 = v12 ~= nil
	local isLoading = v8.isLoading or v14

	if v14 then
		v10 = module4.ownsLoadingState(registry, v12.node.type)
	end

	local v15 = v13 and true or v10
	local v16, v17 = module.useBinding(0)
	module.useEffect(function()
		v17(isLoading and not v15 and 0.5 or 0)
	end, { isLoading, v15 })

	if fFlagAmpV2WizardParentModeNavTheme then
		v5(v8.exited, v8.presentingError, currentNode, v8.currentNodeId, v9, v12)
	end

	if v8.exited then
		return nil
	end

	if v8.presentingError then
		return module.createElement(
			view,
			{ tag = "col align-x-center align-y-center size-full padding-large" },
			{
				ErrorModal = module.createElement(module6, {
					onClose = v8.acknowledgeError
				})
			}
		)
	end

	local v18 = module8()

	if v18 then
		v18 = not (currentNode == nil) and v9 == nil
	end

	if currentNode == nil or v9 == nil and not v18 then
		return module.createElement(LoadingStatePage)
	end

	local v19 = if v14 then v12.node else currentNode
	local v20 = if v14 then v12.component else v9

	local v21 = props.flowProps

	if props.odpEventUniverseId ~= nil and props.odpEventUniverseId ~= "" then
		v21 = v21 == nil and {} or table.clone(v21)
		v21.universeId = props.odpEventUniverseId
	end

	local v22 = {
		onTerminalRedirect = props.onTerminalRedirect,
		analytics = v8.eventContext,
		logEvent = v8.logEvent,
		odpEventContext = props.odpEventContext,
		launchProps = v21,
		analyticsStrings = v8.analyticsStrings,
		analyticsSessionId = v8.analyticsSessionId
	}
	local v23

	if v18 then
		v23 = module.createElement(module7, {
			nodeType = currentNode.type,
			details = currentNode.details,
			transitions = currentNode.transitions,
			report = v8.report
		})
	else
		local createElement = module.createElement
		local v24 = {
			props = v19.details,
			ctx = v22,
			report = 0,
			transitions = 0,
			dismiss = 0
		}

		local v25 = if v14 then noopReport else v8.report
		v24.report = v25
		v24.transitions = v19.transitions
		local v26 = if v13 then v8.dismissPresentation else nil
		v24.dismiss = v26
		v23 = createElement(v20, v24)
	end

	if v14 then
		v11 = module4.fillsViewport(registry, v19.type)
	end

	local v24

	if v14 then
		local createElement = module.createElement
		local v26 = {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Visible = v13,
			ZIndex = v13 and 3 or nil
		}

		local createElement2 = module.createElement
		local v28 = {
			props = currentNode.details,
			ctx = v22,
			report = v8.report,
			transitions = currentNode.transitions,
			dismiss = 0
		}
		local v29 = if v13 then v8.dismissPresentation else nil
		v28.dismiss = v29
		v24 = createElement("Frame", v26, { Node = createElement2(v9, v28) })
	end

	if not v11 then
		v6 = nil
	end

	local v26 = if v6 then v6.contentPosition else nil
	local v27 = if v6 then v6.contentSize else nil
	local v25 = {
		Position = v26,
		Size = v27,
		ZIndex = v11 and 1 or nil,
		tag = {
			["size-full"] = true,
			col = not v11,
			["align-x-center"] = not v11,
			["align-y-center"] = not v11,
			["padding-large"] = not v11
		},
		GroupTransparency = 0
	}

	if module10 then
		v16 = nil
	end

	v25.GroupTransparency = v16
	local v29

	if v11 then
		local createElement = module.createElement

		local v32 = if v6 then v6.backgroundPosition else nil
		local v33 = if v6 then v6.backgroundSize else nil
		v29 = createElement(view, {
			tag = "size-full bg-surface-0",
			Position = v32,
			Size = v33,
			ZIndex = 0,
			testId = "amp-v2-wizard-viewport-background"
		})
	end

	local v28 = {
		Background = v29,
		Content = module.createElement(view, v25, { Node = v23 }),
		LoadingOverlay = 0
	}
	local v30

	if isLoading and (not v13 or v14) then
		local createElement = module.createElement

		local v33 = if v6 then v6.backgroundPosition else nil
		local v34 = if v6 then v6.backgroundSize else nil
		local v32 = {
			tag = "size-full",
			Position = v33,
			Size = v34,
			ZIndex = 2,
			onActivated = function() end,
			stateLayer = { affordance = stateLayerAffordance.None },
			testId = "amp-v2-wizard-loading-overlay"
		}

		local v36 = if not (v15 or module10) then module.createElement(LoadingStatePage) else nil
		local v37

		if v13 then
			v37 = module.createElement(LoadingScrim, { children = {} })
		elseif module10 and not v15 then
			v37 = module.createElement(LoadingScrim, {
				children = { Spinner = module.createElement(LoadingStatePage) }
			})
		end

		v30 = createElement(view, v32, { Spinner = v36, Scrim = v37 })
	end

	v28.LoadingOverlay = v30

	if v24 ~= nil then
		v28.PresentingNode = v24
	end

	local element = module.createElement(
		view,
		{
			tag = "size-full",
			ref = v7,
			onAbsolutePositionChanged = v7,
			onAbsoluteSizeChanged = v7
		},
		v28
	)

	if module12 then
		if v19.behavior == nil or v19.behavior.parentFacing ~= true then
			return element
		end

		return module.createElement(ParentModeTheme, nil, element)
	elseif module9(v19.type, v8.currentNodeId) then
		return module.createElement(ParentModeTheme, nil, element)
	else
		return element
	end
end

return OverlayWizardHost
