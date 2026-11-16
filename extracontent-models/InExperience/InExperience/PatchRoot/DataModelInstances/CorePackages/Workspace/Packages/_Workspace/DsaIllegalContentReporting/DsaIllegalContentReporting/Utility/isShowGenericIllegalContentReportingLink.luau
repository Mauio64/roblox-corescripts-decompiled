local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local defineFastFlag = game:DefineFastFlag("EnableGenericIllegalContentReporting3", false)
local defineFastString = game:DefineFastString(
	"CountriesWithGenericIllegalContentReporting2",
	"AT,BE,BG,CY,CZ,DE,DK,EE,ES,FI,FR,GR,HR,HU,IE,IT,LT,LU,LV,MT,NL,PL,PT,RO,SE,SI,SK,GB,AU"
)

local v = false

if defineFastFlag then
	task.spawn(function()
		local localPlayer = Players.LocalPlayer

		while not localPlayer do
			Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
			localPlayer = Players.LocalPlayer
		end

		local success, countryRegionForPlayerAsync = pcall(
			LocalizationService.GetCountryRegionForPlayerAsync,
			LocalizationService,
			localPlayer
		)

		if not success then
			return
		end

		local parts = defineFastString:split(",")

		for _, part in ipairs(parts) do
			if countryRegionForPlayerAsync == part then
				v = true
				break
			end
		end
	end)
end

local function isShowGenericIllegalContentReportingLink()
	return defineFastFlag and v
end

return isShowGenericIllegalContentReportingLink
