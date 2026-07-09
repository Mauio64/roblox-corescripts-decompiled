local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local LocalStorageKey = require(CorePackages.Workspace.Packages.LocalStorage).Enums.LocalStorageKey

game:DefineFastInt("LinkBrowserTrackerToDeviceRollout", 0)

return function() -- line: 7
	-- upvalues: AppStorageService (copy), LocalStorageKey (copy)
	return game:GetFastInt("LinkBrowserTrackerToDeviceRollout") > (AppStorageService and (not not LocalStorageKey and tonumber(AppStorageService:GetItem(LocalStorageKey.BrowserTrackerId))) or 99) % 100
end
