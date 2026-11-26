local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local getPageMargin = UIBlox.App.Container.getPageMargin
local buttonStack = UIBlox.App.Button.ButtonStack
local buttonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useProperty = require("@luauforge/bundled/fyQ").useProperty
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module = require("@luauforge/bundled/dRr")

local function ResetApplyBar(props)
	local theme = useStyle().Theme

	local v5 = useLocalization({
		apply = "CommonUI.Messages.Action.Apply",
		reset = "CommonUI.Messages.Action.Reset"
	})

	local ref = React.useRef(nil)
	local frameRef = props.frameRef or ref
	local v6 = useProperty(frameRef, "AbsoluteSize")
	local v7 = not v6 and 0 or getPageMargin(v6.X)
	local v8

	if module() then
		v8 = React.useMemo(function()
			local v9 = {}

			if props.onReset then
				table.insert(v9, {
					props = {
						onActivated = props.onReset,
						text = v5.reset,
						isDisabled = not props.canReset
					},
					isDefaultChild = props.onApply == nil
				})
			end

			if props.onApply then
				table.insert(v9, {
					buttonType = buttonType.PrimarySystem,
					props = {
						onActivated = props.onApply,
						text = v5.apply,
						isDisabled = not props.canApply
					},
					isDefaultChild = true
				})
			end

			return v9
		end, { props.onApply, props.onReset, v5, props.canReset, props.canApply })
	end

	local createElement = React.createElement
	local v10 = {
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = theme.BackgroundUIDefault.Transparency,
		Size = UDim2.new(1, 0, 0, props.height),
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = frameRef
	}

	local v11 = {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v7),
			PaddingRight = UDim.new(0, v7),
			PaddingTop = UDim.new(0, 32)
		}),
		Gradient = React.createElement("UIGradient", {
			Rotation = 270,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, theme.BackgroundDefault.Transparency),
				NumberSequenceKeypoint.new(0.8, theme.BackgroundDefault.Transparency),
				NumberSequenceKeypoint.new(1, 1)
			})
		}),
		Buttons = 0
	}

	local createElement2 = React.createElement

	if not module() then
		v8 = {
			{
				props = {
					onActivated = props.onReset,
					text = v5.reset,
					isDisabled = not props.canReset
				}
			},
			{
				buttonType = buttonType.PrimarySystem,
				props = {
					onActivated = props.onApply,
					text = v5.apply,
					isDisabled = not props.canApply
				},
				isDefaultChild = true
			}
		}
	end

	v11.Buttons = createElement2(buttonStack, {
		isRoactGamepadEnabled = false,
		buttons = v8
	})
	return createElement("Frame", v10, v11)
end

return ResetApplyBar
