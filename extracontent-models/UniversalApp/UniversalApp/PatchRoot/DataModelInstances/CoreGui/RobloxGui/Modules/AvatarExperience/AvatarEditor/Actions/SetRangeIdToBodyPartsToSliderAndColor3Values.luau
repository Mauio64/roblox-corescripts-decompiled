local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

require(Modules.AvatarExperience.Common.Types)

local mutedError = require(Modules.LuaApp.mutedError)
local ColorPickerUtils = require(Modules.AvatarExperience.ColorPicker.ColorPickerUtils)

return Rodux.makeActionCreator(script.Name, function(s1: string, p1, n1: number, color3: Color3) -- line: 27
	-- upvalues: ArgCheck (copy), ColorPickerUtils (copy), mutedError (copy)
	ArgCheck.isType(s1, "string", "rangeId")
	ArgCheck.isType(p1, "string", "bodyPartForSkinColoringId")
	ArgCheck.isType(n1, "number", "sliderValue")

	local v11, v12 = ColorPickerUtils.clampBetween0And1(n1)

	if v12 then
		mutedError(string.format("getColor3AtValueInRange: value %s should be between 0 and 1 inclusive", (tostring(n1))))
	end

	ArgCheck.isType(color3, "Color3", "color3")

	return {
		rangeId = s1,
		bodyPartForSkinColoringId = p1,
		sliderValue = v11,
		color3 = color3
	}
end)
