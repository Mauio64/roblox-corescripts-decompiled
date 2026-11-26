local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Localization").Hooks.useLocalization

local function InstantPlayButton(props)
	local v5 = useLocalization({
		play = "Feature.ExperienceDetails.PlayButtonText.Play"
	})

	local createElement = React.createElement
	local v8 = if props.showIcon then iconName.PlayXlarge else nil
	local v9 = if props.showText then v5.play else nil
	return createElement(button, {
		icon = v8,
		text = v9,
		variant = buttonVariant.SoftEmphasis,
		size = inputSize.Small,
		fillBehavior = fillBehavior.Fill,
		onActivated = props.onActivated
	})
end

return React.memo(InstantPlayButton)
