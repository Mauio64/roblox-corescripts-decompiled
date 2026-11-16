local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useBrowserTrackerExperiment = RoactAppExperiment.useBrowserTrackerExperiment
local appBtidLayers = require("@luauforge/bundled/dMA").AppBtidLayers
local React = require(CorePackages.Packages.React)

local iosAuthServiceEnabled = require("@luauforge/bundled/dCq").Enums.LocalStorageKey.IosAuthServiceEnabled

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

local function IosAuthServiceIxpStore(p2): nil
	local enableNewIosPasswordSaving = useBrowserTrackerExperiment(
		{ appBtidLayers.IosPasswordSavingLayer },
		function(p3)
			return {
				enableNewIosPasswordSaving = (p3[appBtidLayers.IosPasswordSavingLayer] or {}).enableNewIosPasswordSaving or false
			}
		end
	).enableNewIosPasswordSaving
	React.useEffect(function()
		local v5 = enableNewIosPasswordSaving
		local v6 = iosAuthServiceEnabled
		pcall(function()
			if v5 then
				AppStorageService:SetItem(v6, "true")
			else
				AppStorageService:SetItem(v6, "false")
			end

			AppStorageService:Flush()
		end)
	end, { enableNewIosPasswordSaving })

	return nil
end

return IosAuthServiceIxpStore
