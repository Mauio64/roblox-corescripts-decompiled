local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useBrowserTrackerExperiment = RoactAppExperiment.useBrowserTrackerExperiment
local appBtidLayers = require("@luauforge/bundled/dPQ").AppBtidLayers
local React = require(CorePackages.Packages.React)

local enableIOSUIRefactorExperiment = require("@luauforge/bundled/dFv").Enums.LocalStorageKey.EnableIOSUIRefactorExperiment

local function setLocalStorageKey(p2, p3)
	pcall(function()
		if p2 then
			AppStorageService:SetItem(p3, "true")
		else
			AppStorageService:SetItem(p3, "false")
		end

		AppStorageService:Flush()
	end)
end

local function IOSUIRefactorIXP(p2): nil
	local enableIOSUIRefactor = useBrowserTrackerExperiment(
		{ appBtidLayers.ConsumerPlatformsIOSUIRefactor },
		function(p3)
			return {
				enableIOSUIRefactor = (p3[appBtidLayers.ConsumerPlatformsIOSUIRefactor] or {}).enableIOSUIRefactor
			}
		end
	).enableIOSUIRefactor
	React.useEffect(function()
		local v5 = enableIOSUIRefactor
		local v6 = enableIOSUIRefactorExperiment
		pcall(function()
			if v5 then
				AppStorageService:SetItem(v6, "true")
			else
				AppStorageService:SetItem(v6, "false")
			end

			AppStorageService:Flush()
		end)
	end, { enableIOSUIRefactor })

	return nil
end

return IOSUIRefactorIXP
