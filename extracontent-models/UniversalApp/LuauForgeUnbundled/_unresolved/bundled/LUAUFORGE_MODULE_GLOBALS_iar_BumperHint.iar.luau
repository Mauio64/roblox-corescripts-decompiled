local UserInputService = game:GetService("UserInputService")
local module = require("@luauforge/bundled/ias")
local module2 = require("@luauforge/bundled/iat")
local module3 = require("@luauforge/bundled/iau")
local module4 = require("@luauforge/bundled/iav")
local icon = module3.Icon
local enums = module3.Enums

local v5 = { Xbox = "Xbox", PlayStation = "PlayStation" }

local v6 = {
	Xbox = {
		[Enum.KeyCode.ButtonL1] = enums.IconName.XboxLb,
		[Enum.KeyCode.ButtonR1] = enums.IconName.XboxRb
	},
	PlayStation = {
		[Enum.KeyCode.ButtonL1] = enums.IconName.PsL1,
		[Enum.KeyCode.ButtonR1] = enums.IconName.PsR1
	}
}

local function getGamepadIconName(p2)
	local function getGamepadType(): string
		if UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonA) == "ButtonCross" then
			return "PlayStation"
		end

		return "Xbox"
	end

	local v9 = if UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonA) == "ButtonCross" then v5.PlayStation else v5.Xbox

	return v6[v9][p2]
end

function LUAUFORGE_MODULE_GLOBALS_iar_BumperHint(props)
	local v9 = module4.usePreferredInput() == module4.Input.Directional
	local v10 = props.isPersistent and true or v9

	local v11 = if props.isLeftBumper then Enum.KeyCode.ButtonL1 else Enum.KeyCode.ButtonR1

	local function getGamepadType(): string
		if UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonA) == "ButtonCross" then
			return "PlayStation"
		end

		return "Xbox"
	end

	local v12 = if UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonA) == "ButtonCross" then v5.PlayStation else v5.Xbox

	local joined = {
		name = v6[v12][v11],
		size = enums.IconSize.Large,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Visible = v10
	}

	if props.overrideIconProps then
		joined = module2.Dictionary.join(joined, props.overrideIconProps)
	end

	if props.squareSize then
		return module.createElement(
			"Frame",
			{
				Size = UDim2.fromOffset(props.squareSize, props.squareSize),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1
			},
			{
				Icon = module.createElement(icon, joined)
			}
		)
	end

	return module.createElement(icon, joined)
end

return LUAUFORGE_MODULE_GLOBALS_iar_BumperHint
