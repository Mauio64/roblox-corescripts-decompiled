local module = require("@luauforge/bundled/hMW")
local module2 = require("@luauforge/bundled/hNc")
local module3 = require("@luauforge/bundled/hNk")
require("@luauforge/bundled/hNi")
require("@luauforge/bundled/hMS")
local module4 = require("@luauforge/bundled/hMV")
local module5 = require("@luauforge/bundled/hMO")
local useDesignTokens = require("@luauforge/bundled/hNg").useDesignTokens
local module6 = require("@luauforge/bundled/hNl")
local eventStreamConstants = module6.EventStreamConstants
local authButtonClick = module6.Events.authButtonClick
local authPageload = module6.Events.authPageload
require("@luauforge/bundled/hMQ")

local module7 = require("@luauforge/bundled/hNn")

local function ActivationFrameworkWrapper(props)
	local activationFrameworkState = module.useContext(module4).activationFrameworkState
	local state, setState = module.useState(0)
	local state2, setState2 = module.useState(0)
	local state3, setState3 = module.useState(0)
	local state4, setState4 = module.useState(0)

	local state5, setState5 = module.useState(0)
	local state6, setState6 = module.useState(0)

	local state7, setState7 = module.useState(0)
	local state8, setState8 = module.useState(0)

	local activationFramework = useDesignTokens().LuaApps.ActivationFramework

	local v5 = not props.shouldExpandMiddleContent

	module.useEffect(function()
		authPageload(props.namespace, activationFrameworkState.currentState)
	end, {})

	local v6 = module7(props.navigation)

	local function onBack()
		authButtonClick(
			props.namespace,
			eventStreamConstants.Button.Back,
			activationFrameworkState.currentState
		)
		v6(module5.Back)
	end

	local function onSkip()
		authButtonClick(
			props.namespace,
			eventStreamConstants.Button.Skip,
			activationFrameworkState.currentState
		)
		v6(module5.Skip)
	end

	local state9, setState9 = module.useState({
		shouldShowBackButton = false,
		icon = "icons/actions/cycleLeft",
		onBack = onBack
	})
	local state10, setState10 = module.useState({
		shouldShowSkipButton = false,
		skipButtonTextKey = "Authentication.SignUp.Label.Skip",
		onSkip = onSkip
	})

	module.useEffect(function()
		local clone = table.clone(state9)
		local clone2 = table.clone(state10)

		clone2.shouldShowSkipButton = table.find(activationFrameworkState.availableActions, module5.Skip) ~= nil

		clone.shouldShowBackButton = false

		if table.find(activationFrameworkState.availableActions, module5.Back) then
			clone.shouldShowBackButton = true
			clone.icon = "icons/actions/cycleLeft"
		elseif table.find(activationFrameworkState.availableActions, module5.Close) then
			clone.shouldShowBackButton = true
			clone.icon = "icons/navigation/close"
		end

		setState9(clone)
		setState10(clone2)
	end, { activationFrameworkState.availableActions })

	local verticalPaddingPx = activationFramework.verticalPaddingPx
	local verticalPaddingPx2 = activationFramework.verticalPaddingPx

	module.useLayoutEffect(function()
		if state3 > 0 then
			local v7 = state3 - activationFramework.horizontalPaddingPx * 2
			setState5(v7)
			setState7(v7)
		end
	end, { state3 })

	module.useLayoutEffect(function()
		if v5 and state > 0 and state2 > 0 and state4 > 0 and state6 > 0 then
			setState8(state4 - state - state2 - verticalPaddingPx - verticalPaddingPx2 - state6)
		end
	end, { state, state2, state4, state6 })

	module.useLayoutEffect(function()
		if props.shouldExpandMiddleContent and state > 0 and state2 > 0 and state4 > 0 then
			setState6(state4 - state - state2 - verticalPaddingPx - verticalPaddingPx2 - state8)
		end
	end, { state, state2, state4, state8 })

	local v7 = {
		primaryButton = props.primaryButton,
		secondaryButton = props.secondaryButton,
		shouldShowButtonDivider = props.shouldShowButtonDivider,
		navigation = props.navigation
	}

	local createElement = module.createElement
	local v9 = {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		[module.Change.AbsoluteSize] = function(p2)
			setState3(p2.AbsoluteSize.X)
			setState4(p2.AbsoluteSize.Y)
		end,
		BorderSizePixel = 0
	}

	local children = {
		Padding = module.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, activationFramework.verticalPaddingPx),
			PaddingTop = UDim.new(0, activationFramework.verticalPaddingPx),
			PaddingLeft = UDim.new(0, activationFramework.horizontalPaddingPx),
			PaddingRight = UDim.new(0, activationFramework.horizontalPaddingPx)
		}),
		Layout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		Header = module.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			[module.Change.AbsoluteSize] = function(p2)
				setState(p2.AbsoluteSize.Y)
			end,
			LayoutOrder = 1
		}, {
			Padding = module.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, activationFramework.headerTopPadding)
			}),
			HeaderContent = module.createElement(module2, {
				skipProps = state10,
				backProps = state9,
				titleTextKey = props.titleTextKey,
				bodyTextKey = props.bodyTextKey,
				headingTextKey = props.headingTextKey,
				ixpTitleTextKey = props.ixpTitleTextKey,
				ixpBodyTextKey = props.ixpBodyTextKey
			})
		}),
		Content = 0,
		Footer = 0,
		SubFooterContent = 0
	}

	local createElement3 = module.createElement
	local v13 = if props.shouldExpandMiddleContent then UDim2.new(0, state5, 0, state6) else UDim2.new(0, state5, 0, 0)
	local v14 = if not props.shouldExpandMiddleContent then Enum.AutomaticSize.Y else nil
	children.Content = createElement3("Frame", {
		Size = v13,
		AutomaticSize = v14,
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		[module.Change.AbsoluteSize] = function(p2)
			if not props.shouldExpandMiddleContent then
				setState6(p2.AbsoluteSize.Y)
			end
		end
	}, { props.children })

	children.Footer = module.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		[module.Change.AbsoluteSize] = function(p2)
			setState2(p2.AbsoluteSize.Y)
		end,
		BackgroundTransparency = 1,
		LayoutOrder = 3
	}, {
		Padding = module.createElement("UIPadding", {
			PaddingTop = UDim.new(0, activationFramework.footerTopPaddingPx)
		}),
		FooterContent = module.createElement(module3, v7)
	})
	local v16

	if props.subFooterContent then
		local createElement5 = module.createElement

		local v19 = if v5 then UDim2.new(0, state7, 0, state8) else UDim2.new(0, state7, 0, 0)
		local v20 = if not v5 then Enum.AutomaticSize.Y else nil
		v16 = createElement5("Frame", {
			Size = v19,
			AutomaticSize = v20,
			BackgroundTransparency = 1,
			LayoutOrder = 4,
			[module.Change.AbsoluteSize] = function(p2)
				if not v5 then
					setState8(p2.AbsoluteSize.Y)
				end
			end
		}, {
			Padding = module.createElement("UIPadding", {
				PaddingTop = UDim.new(0, activationFramework.subfooterTopPaddingPx),
				PaddingBottom = UDim.new(0, activationFramework.subfooterBottomPaddingPx)
			}),
			props.subFooterContent
		})
	end

	children.SubFooterContent = v16
	return createElement("Frame", v9, children)
end

return ActivationFrameworkWrapper
