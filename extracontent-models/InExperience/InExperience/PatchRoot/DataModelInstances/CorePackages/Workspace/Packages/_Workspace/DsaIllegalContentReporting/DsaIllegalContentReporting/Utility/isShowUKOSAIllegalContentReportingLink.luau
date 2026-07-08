local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local v3 = game:DefineFastFlag("EnableOSAIllegalContentReporting", false)
local u4 = false

if v3 then
	task.spawn(function() -- line: 16
		-- upvalues: Players (copy), LocalizationService (copy), u4 (ref)
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
			u4 = true
		end
	end)
end

local function isShowUKOSAIllegalContentReportingLink() -- line: 36
	-- upvalues: v3 (copy), u4 (ref)
	return v3 and u4
end

return isShowUKOSAIllegalContentReportingLink
