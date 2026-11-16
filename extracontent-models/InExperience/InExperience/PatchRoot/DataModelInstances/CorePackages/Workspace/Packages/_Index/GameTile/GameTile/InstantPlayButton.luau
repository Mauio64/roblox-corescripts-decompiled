local parent = script:FindFirstAncestor("GameTile").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local function InstantPlayButton(props)
	local v = useLocalization({ play = "Feature.ExperienceDetails.PlayButtonText.Play" })

	local createElement = React.createElement
	local icon

	if props.showIcon then
		icon = IconName.PlayXlarge
	end

	local text

	if props.showText then
		text = v.play
	end

	return createElement(Button, {
		icon = icon,
		text = text,
		variant = ButtonVariant.SoftEmphasis,
		size = InputSize.Small,
		fillBehavior = FillBehavior.Fill,
		onActivated = props.onActivated
	})
end

return React.memo(InstantPlayButton)
