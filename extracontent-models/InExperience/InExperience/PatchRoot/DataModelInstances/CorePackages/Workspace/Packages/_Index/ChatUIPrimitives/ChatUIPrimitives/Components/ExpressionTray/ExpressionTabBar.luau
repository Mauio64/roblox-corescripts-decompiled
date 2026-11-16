local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local createNextOrder = ReactUtils.createNextOrder

local function ExpressionTabBar(props)
	local v = Foundation.Hooks.useTokens()
	local v2 = #props.tabs > 1
	local children = {}

	for k, tab in props.tabs do
		local v3 = tab.id == props.activeTabId
		local contentemphasis = v3 or not v2
		local v4 = "Tab_" .. tab.id
		local createElement = React.createElement
		local view = Foundation.View
		local v5 = {
			LayoutOrder = k,
			testId = "expressionTab_" .. tab.id,
			tag = "auto-xy padding-x-small",
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			onActivated = function()
				props.onTabActivated(tab.id)
			end,
			selection = props.focusNavEnabled and not v2 and { Selectable = false } or nil
		}
		local v6 = {
			Label = React.createElement(Foundation.Text, {
				Text = tab.text,
				tag = {
					["auto-xy text-label-medium"] = true,
					["content-emphasis"] = contentemphasis,
					["content-muted"] = not contentemphasis
				}
			}),
			Indicator = 0
		}
		local indicator

		if v3 and v2 then
			indicator = React.createElement(Foundation.View, {
				testId = "presetTabIndicator",
				tag = "anchor-bottom-center",
				Position = UDim2.new(0.5, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, 2),
				backgroundStyle = { Color3 = v.Color.Content.Emphasis.Color3, Transparency = 0 }
			})
		end

		v6.Indicator = indicator
		children[v4] = createElement(view, v5, v6)
	end

	local nextOrder = createNextOrder()
	local createElement = React.createElement
	local view = Foundation.View
	local v3 = {
		LayoutOrder = props.LayoutOrder,
		tag = "row align-y-center gap-small size-full-0 auto-y padding-small"
	}

	local v4 = {
		Tabs = React.createElement(
			Foundation.View,
			{ LayoutOrder = nextOrder(), tag = "row gap-medium auto-xy" },
			children
		),
		Spacer = React.createElement(Foundation.View, {
			LayoutOrder = nextOrder(),
			tag = "grow auto-y"
		}),
		Keyboard = 0
	}
	local keyboard

	if props.showKeyboardButton ~= false then
		keyboard = React.createElement(Foundation.IconButton, {
			LayoutOrder = nextOrder(),
			testId = "expressionTrayKeyboardButton",
			icon = { name = "keyboard", variant = "Regular" },
			variant = Foundation.Enums.ButtonVariant.Utility,
			size = Foundation.Enums.InputSize.Small,
			isCircular = true,
			isDisabled = false,
			onActivated = props.onKeyboardActivated
		})
	end

	v4.Keyboard = keyboard
	return createElement(view, v3, v4)
end

return React.memo(ExpressionTabBar)
