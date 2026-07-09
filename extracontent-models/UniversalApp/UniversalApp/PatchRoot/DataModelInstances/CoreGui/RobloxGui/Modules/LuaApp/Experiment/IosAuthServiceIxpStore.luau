local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local useBrowserTrackerExperiment = require(CorePackages.Packages.RoactAppExperiment).useBrowserTrackerExperiment
local AppBtidLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppBtidLayers
local React = require(CorePackages.Packages.React)
local IosAuthServiceEnabled = require(CorePackages.Workspace.Packages.LocalStorage).Enums.LocalStorageKey.IosAuthServiceEnabled

local function setLocalStorageKey(b1: boolean, s1: string) -- line: 10
	-- upvalues: AppStorageService (copy)
	pcall(function() -- line: 11
		-- upvalues: b1 (copy), AppStorageService (copy), s1 (copy)
		if b1 then
			AppStorageService:SetItem(s1, "true")
		else
			AppStorageService:SetItem(s1, "false")
		end

		AppStorageService:Flush()
	end)
end
local function IosAuthServiceIxpStore(_: {[any]: any}) -- line: 21
	-- upvalues: useBrowserTrackerExperiment (copy), AppBtidLayers (copy), React (copy), IosAuthServiceEnabled (copy), AppStorageService (copy)
	local enableNewIosPasswordSaving = useBrowserTrackerExperiment({ AppBtidLayers.IosPasswordSavingLayer }, function(p1) -- line: 24
		-- upvalues: AppBtidLayers (copy)
		return {
			enableNewIosPasswordSaving = (p1[AppBtidLayers.IosPasswordSavingLayer] or {}).enableNewIosPasswordSaving or false
		}
	end).enableNewIosPasswordSaving

	React.useEffect(function() -- line: 33
		-- upvalues: enableNewIosPasswordSaving (copy), IosAuthServiceEnabled (copy), AppStorageService (copy)
		local v14 = enableNewIosPasswordSaving
		local v15 = IosAuthServiceEnabled

		pcall(function() -- line: 11
			-- upvalues: v14 (copy), AppStorageService (copy), v15 (copy)
			if v14 then
				AppStorageService:SetItem(v15, "true")
			else
				AppStorageService:SetItem(v15, "false")
			end

			AppStorageService:Flush()
		end)
	end, { enableNewIosPasswordSaving })

	return nil
end

return IosAuthServiceIxpStore
