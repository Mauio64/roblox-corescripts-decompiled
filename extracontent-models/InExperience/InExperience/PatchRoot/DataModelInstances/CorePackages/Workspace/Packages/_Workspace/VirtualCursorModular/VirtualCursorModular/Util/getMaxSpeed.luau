local ParentParent = script.Parent.Parent
local GuiService = game:GetService("GuiService")
local Properties = require(ParentParent.Properties)

local function getMaxSpeed() -- line: 8
	-- upvalues: GuiService (copy), Properties (copy)
	return GuiService:GetScreenResolution().Magnitude * Properties.MaxSpeedRelative
end

return getMaxSpeed
