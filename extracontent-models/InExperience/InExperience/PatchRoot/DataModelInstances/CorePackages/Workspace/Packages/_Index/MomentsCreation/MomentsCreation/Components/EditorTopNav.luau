local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Button = Foundation.Button
local Icon = Foundation.Icon
local View = Foundation.View

local GradientBackdrop = MomentsCommon.Components.GradientBackdrop

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens

local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)

local function EditorTopNav(props)
	local v = useTokens()
	local v2 = useDeviceInsets()
	local v3 = useCreationFlowStrings()
	local zIndex = props.zIndex or 1

	return React.createElement(React.Fragment, nil, {
		TopScrim = React.createElement(GradientBackdrop, {
			color3 = Color3.new(0, 0, 0),
			cornerRadius = UDim.new(0, v.Radius.Large),
			rotation = 90,
			size = UDim2.new(1, 0, 0, v2.top + v.Size.Size_2000 + v.Size.Size_1600),
			startingTransparency = 0.4,
			zIndex = zIndex
		}),
		Nav = React.createElement(View, {
			tag = "row flex-x-between align-y-center position-top-center anchor-top-center size-full-0 auto-y",
			padding = {
				top = UDim.new(0, v2.top + v.Padding.Medium),
				left = UDim.new(0, v2.left + v.Padding.Medium),
				right = UDim.new(0, v2.right + v.Padding.Medium)
			},
			ZIndex = zIndex + 1
		}, {
			BackButton = React.createElement(View, {
				LayoutOrder = 1,
				onActivated = props.onBack,
				stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.Background },
				tag = "auto-xy padding-small radius-circle",
				testId = props.backTestId
			}, {
				BackIcon = React.createElement(Icon, {
					name = BuilderIcons.Icon.ChevronLargeLeft,
					size = Foundation.Enums.IconSize.Large,
					style = v.Color.Content.Emphasis
				})
			}),
			SaveButton = React.createElement(Button, {
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				LayoutOrder = 2,
				text = v3.GeneralCtaSave,
				variant = Foundation.Enums.ButtonVariant.Text,
				onActivated = props.onSave,
				size = Foundation.Enums.InputSize.Medium,
				testId = props.saveTestId
			})
		})
	})
end

return EditorTopNav
