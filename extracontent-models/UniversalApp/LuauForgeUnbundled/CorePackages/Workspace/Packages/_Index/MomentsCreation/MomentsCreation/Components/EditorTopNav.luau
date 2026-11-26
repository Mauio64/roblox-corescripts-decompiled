local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local button = Foundation.Button
local icon = Foundation.Icon
local view = Foundation.View

local gradientBackdrop = MomentsCommon.Components.GradientBackdrop

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens

local useCreationFlowStrings = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useCreationFlowStrings")

local function EditorTopNav(props)
	local v5 = useTokens()
	local v6 = useDeviceInsets()
	local v7 = useCreationFlowStrings()
	local zIndex = props.zIndex or 1

	return React.createElement(React.Fragment, nil, {
		TopScrim = React.createElement(gradientBackdrop, {
			color3 = Color3.new(0, 0, 0),
			cornerRadius = UDim.new(0, v5.Radius.Large),
			rotation = 90,
			size = UDim2.new(1, 0, 0, v6.top + v5.Size.Size_2000 + v5.Size.Size_1600),
			startingTransparency = 0.4,
			zIndex = zIndex
		}),
		Nav = React.createElement(view, {
			tag = "row flex-x-between align-y-center position-top-center anchor-top-center size-full-0 auto-y",
			padding = {
				top = UDim.new(0, v6.top + v5.Padding.Medium),
				left = UDim.new(0, v6.left + v5.Padding.Medium),
				right = UDim.new(0, v6.right + v5.Padding.Medium)
			},
			ZIndex = zIndex + 1
		}, {
			BackButton = React.createElement(view, {
				LayoutOrder = 1,
				onActivated = props.onBack,
				stateLayer = {
					affordance = Foundation.Enums.StateLayerAffordance.Background
				},
				tag = "auto-xy padding-small radius-circle",
				testId = props.backTestId
			}, {
				BackIcon = React.createElement(icon, {
					name = BuilderIcons.Icon.ChevronLargeLeft,
					size = Foundation.Enums.IconSize.Large,
					style = v5.Color.Content.Emphasis
				})
			}),
			SaveButton = React.createElement(button, {
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				LayoutOrder = 2,
				text = v7.GeneralCtaSave,
				variant = Foundation.Enums.ButtonVariant.Text,
				onActivated = props.onSave,
				size = Foundation.Enums.InputSize.Medium,
				testId = props.saveTestId
			})
		})
	})
end

return EditorTopNav
