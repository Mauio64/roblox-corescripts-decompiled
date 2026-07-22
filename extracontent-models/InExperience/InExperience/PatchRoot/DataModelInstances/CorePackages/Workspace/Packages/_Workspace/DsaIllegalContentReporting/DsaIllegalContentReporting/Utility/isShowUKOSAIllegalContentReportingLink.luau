local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local u3 = false

task.spawn(function() -- line: 12
	-- upvalues: Players (copy), LocalizationService (copy), u3 (ref)
	local LocalPlayer = Players.LocalPlayer

	while not LocalPlayer do
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		LocalPlayer = Players.LocalPlayer
	end

	local ok, result = pcall(LocalizationService.GetCountryRegionForPlayerAsync, LocalizationService, LocalPlayer)

	if not ok then
		return
	end

	if result == "GB" then
		u3 = true
	end
end)

local function isShowUKOSAIllegalContentReportingLink() -- line: 31
	-- upvalues: u3 (ref)
	return u3
end

return isShowUKOSAIllegalContentReportingLink
