local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

local function leaveExperience(callback)
	GuiService.SelectedCoreObject = nil

	RunService.RenderStepped:Wait()
	RunService.RenderStepped:Wait()

	if callback then
		callback()
	end

	game:Shutdown()
end

return leaveExperience
