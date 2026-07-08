local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local v3 = game:DefineFastFlag("EnableGenericIllegalContentReporting3", false)
local v4 = game:DefineFastString("CountriesWithGenericIllegalContentReporting2", "AT,BE,BG,CY,CZ,DE,DK,EE,ES,FI,FR,GR,HR,HU,IE,IT,LT,LU,LV,MT,NL,PL,PT,RO,SE,SI,SK,GB,AU")
local u5 = false

if v3 then
	task.spawn(function() -- line: 18
		-- upvalues: Players (copy), LocalizationService (copy), v4 (copy), u5 (ref)
		local LocalPlayer = Players.LocalPlayer

		while not LocalPlayer do
			Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
			LocalPlayer = Players.LocalPlayer
		end

		local ok, result = pcall(LocalizationService.GetCountryRegionForPlayerAsync, LocalizationService, LocalPlayer)

		if not ok then
			return
		end

		local parts = v4:split(",")

		for _, v in ipairs(parts) do
			if result == v then
				u5 = true

				return
			end
		end
	end)
end

local function isShowGenericIllegalContentReportingLink() -- line: 42
	-- upvalues: v3 (copy), u5 (ref)
	return v3 and u5
end

return isShowGenericIllegalContentReportingLink
