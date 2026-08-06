local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

local function leaveExperience(p1: ((...any) -> ...any)?) -- line: 10
	-- upvalues: GuiService (copy), RunService (copy)
	GuiService.SelectedCoreObject = nil
	RunService.RenderStepped:Wait()
	RunService.RenderStepped:Wait()

	if p1 then
		p1()
	end

	game:Shutdown()
end

return leaveExperience
