local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local useBrowserTrackerExperiment = require(CorePackages.Packages.RoactAppExperiment).useBrowserTrackerExperiment
local AppBtidLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppBtidLayers
local React = require(CorePackages.Packages.React)
local EnableIOSUIRefactorExperiment = require(CorePackages.Workspace.Packages.LocalStorage).Enums.LocalStorageKey.EnableIOSUIRefactorExperiment

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
local function IOSUIRefactorIXP(_: {[any]: any}) -- line: 21
	-- upvalues: useBrowserTrackerExperiment (copy), AppBtidLayers (copy), React (copy), EnableIOSUIRefactorExperiment (copy), AppStorageService (copy)
	local enableIOSUIRefactor = useBrowserTrackerExperiment({ AppBtidLayers.ConsumerPlatformsIOSUIRefactor }, function(p1) -- line: 24
		-- upvalues: AppBtidLayers (copy)
		return {
			enableIOSUIRefactor = (p1[AppBtidLayers.ConsumerPlatformsIOSUIRefactor] or {}).enableIOSUIRefactor
		}
	end).enableIOSUIRefactor

	React.useEffect(function() -- line: 33
		-- upvalues: enableIOSUIRefactor (copy), EnableIOSUIRefactorExperiment (copy), AppStorageService (copy)
		local v14 = enableIOSUIRefactor
		local v15 = EnableIOSUIRefactorExperiment

		pcall(function() -- line: 11
			-- upvalues: v14 (copy), AppStorageService (copy), v15 (copy)
			if v14 then
				AppStorageService:SetItem(v15, "true")
			else
				AppStorageService:SetItem(v15, "false")
			end

			AppStorageService:Flush()
		end)
	end, { enableIOSUIRefactor })

	return nil
end

return IOSUIRefactorIXP
