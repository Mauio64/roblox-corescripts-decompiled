local parent = script.Parent.Parent

local GuiService = game:GetService("GuiService")
local Properties = require(parent.Properties)

local function getMaxSpeed()
	return GuiService:GetScreenResolution().Magnitude * Properties.MaxSpeedRelative
end

return getMaxSpeed
