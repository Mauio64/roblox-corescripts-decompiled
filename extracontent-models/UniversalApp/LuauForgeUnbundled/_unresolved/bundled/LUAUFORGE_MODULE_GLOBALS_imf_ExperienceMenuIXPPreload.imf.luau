local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local React = require(CorePackages.Packages.React)

local function setMenuVersion(value)
	pcall(function()
		if value ~= AppStorageService:GetItem("ExperienceMenuVersion") then
			AppStorageService:SetItem("ExperienceMenuVersion", value or "")
			AppStorageService:Flush()
		end
	end)
end

function LUAUFORGE_MODULE_GLOBALS_imf_ExperienceMenuIXPPreload(p2): nil
	local v5 = useUserExperiment(
		{ appUserLayers.ExperienceMenuLayer, appUserLayers.ConsoleExperienceMenuLayer },
		function(p3)
			if
				p3[appUserLayers.ExperienceMenuLayer]
				and p3[appUserLayers.ExperienceMenuLayer].menuVersion
			then
				return p3[appUserLayers.ExperienceMenuLayer].menuVersion
			end

			if
				p3[appUserLayers.ConsoleExperienceMenuLayer]
				and p3[appUserLayers.ConsoleExperienceMenuLayer].menuVersion
			then
				return p3[appUserLayers.ConsoleExperienceMenuLayer].menuVersion
			end

			return ""
		end
	)

	React.useEffect(function()
		local v6 = v5
		pcall(function()
			if v6 ~= AppStorageService:GetItem("ExperienceMenuVersion") then
				AppStorageService:SetItem("ExperienceMenuVersion", v6 or "")
				AppStorageService:Flush()
			end
		end)
	end, { v5 })

	return nil
end

return LUAUFORGE_MODULE_GLOBALS_imf_ExperienceMenuIXPPreload
