local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local useUserExperiment = require(CorePackages.Packages.RoactAppExperiment).useUserExperiment
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local React = require(CorePackages.Packages.React)

local function setMenuVersion(p1) -- line: 9
	-- upvalues: AppStorageService (copy)
	pcall(function() -- line: 10
		-- upvalues: AppStorageService (copy), p1 (copy)
		if AppStorageService:GetItem("ExperienceMenuVersion") ~= p1 then
			AppStorageService:SetItem("ExperienceMenuVersion", p1 or "")
			AppStorageService:Flush()
		end
	end)
end

function ExperienceMenuIXPPreload(_) -- line: 20
	-- upvalues: useUserExperiment (copy), AppUserLayers (copy), React (copy), AppStorageService (copy)
	local v9 = useUserExperiment({
		AppUserLayers.ExperienceMenuLayer,
		AppUserLayers.ConsoleExperienceMenuLayer
	}, function(p3) -- line: 24
		-- upvalues: AppUserLayers (copy)
		if p3[AppUserLayers.ExperienceMenuLayer] and p3[AppUserLayers.ExperienceMenuLayer].menuVersion then
			return p3[AppUserLayers.ExperienceMenuLayer].menuVersion
		end

		if p3[AppUserLayers.ConsoleExperienceMenuLayer] and p3[AppUserLayers.ConsoleExperienceMenuLayer].menuVersion then
			return p3[AppUserLayers.ConsoleExperienceMenuLayer].menuVersion
		end

		return ""
	end)

	React.useEffect(function() -- line: 40
		-- upvalues: v9 (copy), AppStorageService (copy)
		local v11 = v9

		pcall(function() -- line: 10
			-- upvalues: AppStorageService (copy), v11 (copy)
			if AppStorageService:GetItem("ExperienceMenuVersion") ~= v11 then
				AppStorageService:SetItem("ExperienceMenuVersion", v11 or "")
				AppStorageService:Flush()
			end
		end)
	end, { v9 })

	return nil
end

return ExperienceMenuIXPPreload
