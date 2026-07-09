local Parent = script:FindFirstAncestor("BumperNavigation").Parent
local UserInputService = game:GetService("UserInputService")
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local Foundation = require(Parent.Foundation)
local Responsive = require(Parent.Responsive)
local Icon = Foundation.Icon
local Enums = Foundation.Enums
local FFlagPlayStationBumperHint = require(Parent.SharedFlags).FFlagPlayStationBumperHint
local t1 = {
	Xbox = "Xbox",
	PlayStation = "PlayStation"
}
local t2 = {
	Xbox = {
		[Enum.KeyCode.ButtonL1] = Enums.IconName.XboxLb,
		[Enum.KeyCode.ButtonR1] = Enums.IconName.XboxRb
	},
	PlayStation = {
		[Enum.KeyCode.ButtonL1] = Enums.IconName.PsL1,
		[Enum.KeyCode.ButtonR1] = Enums.IconName.PsR1
	}
}

local function getGamepadIconName(p1) -- line: 29
	-- upvalues: UserInputService (copy), t1 (copy), t2 (copy)
	local function getGamepadType() -- line: 30
		-- upvalues: UserInputService (copy)
		if UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonA) == "ButtonCross" then
			return "PlayStation"
		end

		return "Xbox"
	end

	return t2[(if UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonA) ~= "ButtonCross" then t1.Xbox else t1.PlayStation)][p1]
end

function BumperHint(t3: {[any]: any}) -- line: 52
	-- upvalues: Responsive (copy), FFlagPlayStationBumperHint (copy), UserInputService (copy), t1 (copy), t2 (copy), Enums (copy), Cryo (copy), React (copy), Icon (copy)
	local v16 = Responsive.usePreferredInput() == Responsive.Input.Directional
	local v17 = not not t3.isPersistent or v16
	local v20

	if FFlagPlayStationBumperHint then
		local v18 = if not t3.isLeftBumper then Enum.KeyCode.ButtonR1 else Enum.KeyCode.ButtonL1

		local function getGamepadType() -- line: 30
			-- upvalues: UserInputService (copy)
			if UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonA) == "ButtonCross" then
				return "PlayStation"
			end

			return "Xbox"
		end

		v20 = t2[(if UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonA) ~= "ButtonCross" then t1.Xbox else t1.PlayStation)][v18]
	else
		v20 = if not t3.isLeftBumper then Enums.IconName.XboxRb else Enums.IconName.XboxLb
	end

	local t4 = {
		name = v20,
		size = Enums.IconSize.Large,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Visible = v17
	}

	if t3.overrideIconProps then
		t4 = Cryo.Dictionary.join(t4, t3.overrideIconProps)
	end

	if t3.squareSize then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(t3.squareSize, t3.squareSize),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}, {
			Icon = React.createElement(Icon, t4)
		})
	end

	return React.createElement(Icon, t4)
end

return BumperHint
