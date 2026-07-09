local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local AppUpdateService = RoactServiceTags.AppUpdateService
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local CheckForUpdate = require(CorePackages.Workspace.Packages.RobloxAppUpdate).Thunks.CheckForUpdate
local LoginStatus = require(Modules.LuaApp.Enum.LoginStatus)

local function AppUpdateManager(_) -- line: 17
	-- upvalues: useRoactService (copy), RoactAnalytics (copy), AppUpdateService (copy), useDispatch (copy), useSelector (copy), React (copy), LoginStatus (copy), CheckForUpdate (copy)
	local v15 = useRoactService(RoactAnalytics)
	local v16 = useRoactService(AppUpdateService)
	local v17 = useDispatch()
	local v18 = useSelector(function(p2) -- line: 22
		return p2.AuthenticationStatus.status
	end)

	React.useEffect(function() -- line: 26
		-- upvalues: v18 (copy), LoginStatus (copy), v17 (copy), CheckForUpdate (copy), v16 (copy), v15 (copy)
		if game:GetEngineFeature("AutoUpgradeEngineFeatureOnly") and v18 == LoginStatus.LOGGED_IN then
			v17(CheckForUpdate(v16, false, v15, function() -- line: 29
			end, {
				ctx = "AppUpdateManager"
			}))
		end
	end, {
		v18,
		v16,
		v15
	})

	return nil
end

return AppUpdateManager
