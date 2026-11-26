local GuiService = game:GetService("GuiService")
local Properties = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/VirtualCursorModular/Properties")

local function getMaxSpeed()
	return GuiService:GetScreenResolution().Magnitude * Properties.MaxSpeedRelative
end

return getMaxSpeed
