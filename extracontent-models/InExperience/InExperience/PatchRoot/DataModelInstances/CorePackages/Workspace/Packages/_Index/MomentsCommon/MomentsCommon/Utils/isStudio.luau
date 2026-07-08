local RunService = game:GetService("RunService")

local function isStudio() -- line: 4
	-- upvalues: RunService (copy)
	return RunService:IsStudio()
end

return isStudio
