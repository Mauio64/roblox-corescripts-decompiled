local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local useBrowserTrackerExperiment = require(CorePackages.Packages.RoactAppExperiment).useBrowserTrackerExperiment
local AppBtidLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppBtidLayers
local React = require(CorePackages.Packages.React)

local function setLocalStorageKey(p1) -- line: 9
	-- upvalues: AppStorageService (copy)
	pcall(function() -- line: 10
		-- upvalues: p1 (copy), AppStorageService (copy)
		if p1 ~= nil then
			AppStorageService:SetItem("AndroidRecentlyPlayedWidgetVariant", p1)
		else
			AppStorageService:SetItem("AndroidRecentlyPlayedWidgetVariant", "no_widget")
		end

		AppStorageService:Flush()
	end)
end

function AndroidWidgetStoreIXP(_) -- line: 20
	-- upvalues: useBrowserTrackerExperiment (copy), AppBtidLayers (copy), React (copy), AppStorageService (copy)
	local recentlyPlayedWidgetVariant2 = useBrowserTrackerExperiment({ AppBtidLayers.AndroidWidgetLayer }, function(p3) -- line: 23
		-- upvalues: AppBtidLayers (copy)
		return {
			recentlyPlayedWidgetVariant2 = (p3[AppBtidLayers.AndroidWidgetLayer] or {}).recentlyPlayedWidgetVariant2
		}
	end).recentlyPlayedWidgetVariant2

	React.useEffect(function() -- line: 32
		-- upvalues: recentlyPlayedWidgetVariant2 (copy), AppStorageService (copy)
		local v11 = recentlyPlayedWidgetVariant2

		pcall(function() -- line: 10
			-- upvalues: v11 (copy), AppStorageService (copy)
			if v11 ~= nil then
				AppStorageService:SetItem("AndroidRecentlyPlayedWidgetVariant", v11)
			else
				AppStorageService:SetItem("AndroidRecentlyPlayedWidgetVariant", "no_widget")
			end

			AppStorageService:Flush()
		end)
	end, { recentlyPlayedWidgetVariant2 })

	return nil
end

return AndroidWidgetStoreIXP
