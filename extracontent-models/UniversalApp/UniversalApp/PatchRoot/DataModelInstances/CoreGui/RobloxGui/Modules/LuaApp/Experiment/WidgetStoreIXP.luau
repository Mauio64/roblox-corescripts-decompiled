local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local useBrowserTrackerExperiment = require(CorePackages.Packages.RoactAppExperiment).useBrowserTrackerExperiment
local AppBtidLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppBtidLayers
local React = require(CorePackages.Packages.React)

local function setLocalStorageKey(p1, p2) -- line: 10
	-- upvalues: AppStorageService (copy)
	pcall(function() -- line: 11
		-- upvalues: p1 (copy), AppStorageService (copy), p2 (copy)
		if p1 then
			AppStorageService:SetItem(p2, "true")
		else
			AppStorageService:SetItem(p2, "false")
		end

		AppStorageService:Flush()
	end)
end

function WidgetStoreIXP(_) -- line: 21
	-- upvalues: useBrowserTrackerExperiment (copy), AppBtidLayers (copy), React (copy), AppStorageService (copy)
	local v10 = useBrowserTrackerExperiment({
		AppBtidLayers.WidgetLayer,
		AppBtidLayers.LockScreenWidgetLayer
	}, function(p4) -- line: 25
		-- upvalues: AppBtidLayers (copy)
		local v14 = p4[AppBtidLayers.WidgetLayer] or {}
		local v15 = p4[AppBtidLayers.LockScreenWidgetLayer] or {}

		return {
			showRecentsWidget = v14.showRecentsWidget,
			showLockScreenWidget = v15.showLockScreenWidget
		}
	end)
	local showRecentsWidget = v10.showRecentsWidget
	local showLockScreenWidget = v10.showLockScreenWidget

	React.useEffect(function() -- line: 37
		-- upvalues: showRecentsWidget (copy), AppStorageService (copy), showLockScreenWidget (copy)
		local v16 = showRecentsWidget
		local s1 = "EnableWidgetExtension"

		pcall(function() -- line: 11
			-- upvalues: v16 (copy), AppStorageService (copy), s1 (copy)
			if v16 then
				AppStorageService:SetItem(s1, "true")
			else
				AppStorageService:SetItem(s1, "false")
			end

			AppStorageService:Flush()
		end)

		local v18 = showLockScreenWidget
		local s2 = "EnableLockScreenWidgetExperiment"

		pcall(function() -- line: 11
			-- upvalues: v18 (copy), AppStorageService (copy), s2 (copy)
			if v18 then
				AppStorageService:SetItem(s2, "true")
			else
				AppStorageService:SetItem(s2, "false")
			end

			AppStorageService:Flush()
		end)
	end, {
		showRecentsWidget,
		showLockScreenWidget
	})

	return nil
end

return WidgetStoreIXP
