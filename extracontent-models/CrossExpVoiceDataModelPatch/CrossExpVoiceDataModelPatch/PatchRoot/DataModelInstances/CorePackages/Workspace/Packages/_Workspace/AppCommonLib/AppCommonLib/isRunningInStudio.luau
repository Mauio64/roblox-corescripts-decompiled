local function isRunningInStudio()
	local RunService = game:GetService("RunService")
	return RunService:IsStudio() and not _G.__TESTEZ_RUNNING_TEST__
end

return isRunningInStudio
