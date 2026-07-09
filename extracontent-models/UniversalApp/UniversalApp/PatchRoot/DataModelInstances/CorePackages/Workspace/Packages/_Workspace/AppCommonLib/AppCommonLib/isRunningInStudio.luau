local function isRunningInStudio() -- line: 1
	return game:GetService("RunService"):IsStudio() and not _G.__TESTEZ_RUNNING_TEST__
end

return isRunningInStudio
