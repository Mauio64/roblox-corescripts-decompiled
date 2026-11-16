local FFlagSettingsSelectorStepOnPressOnly = require(script.Parent.Flags.FFlagSettingsSelectorStepOnPressOnly)

local function shouldSelectorArrowStep(p, flag: boolean, flag2: boolean)
	if FFlagSettingsSelectorStepOnPressOnly then
		return p == Enum.UserInputType.MouseButton1 or p == Enum.UserInputType.Touch
	end

	return flag or flag2 and p == Enum.UserInputType.MouseButton1
end

return shouldSelectorArrowStep
