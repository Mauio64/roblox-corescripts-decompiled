local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useBrowserTrackerExperiment = RoactAppExperiment.useBrowserTrackerExperiment
local appBtidLayers = require("@luauforge/bundled/dPQ").AppBtidLayers
local React = require(CorePackages.Packages.React)

local function setLocalStorageKey(p2)
	pcall(function()
		if p2 == nil then
			AppStorageService:SetItem("AndroidRecentlyPlayedWidgetVariant", "no_widget")
		else
			AppStorageService:SetItem("AndroidRecentlyPlayedWidgetVariant", p2)
		end

		AppStorageService:Flush()
	end)
end

function LUAUFORGE_MODULE_GLOBALS_img_AndroidWidgetStoreIXP(p2): nil
	local recentlyPlayedWidgetVariant2 = useBrowserTrackerExperiment(
		{ appBtidLayers.AndroidWidgetLayer },
		function(p3)
			return {
				recentlyPlayedWidgetVariant2 = (p3[appBtidLayers.AndroidWidgetLayer] or {}).recentlyPlayedWidgetVariant2
			}
		end
	).recentlyPlayedWidgetVariant2
	React.useEffect(function()
		local v5 = recentlyPlayedWidgetVariant2
		pcall(function()
			if v5 == nil then
				AppStorageService:SetItem("AndroidRecentlyPlayedWidgetVariant", "no_widget")
			else
				AppStorageService:SetItem("AndroidRecentlyPlayedWidgetVariant", v5)
			end

			AppStorageService:Flush()
		end)
	end, { recentlyPlayedWidgetVariant2 })

	return nil
end

return LUAUFORGE_MODULE_GLOBALS_img_AndroidWidgetStoreIXP
