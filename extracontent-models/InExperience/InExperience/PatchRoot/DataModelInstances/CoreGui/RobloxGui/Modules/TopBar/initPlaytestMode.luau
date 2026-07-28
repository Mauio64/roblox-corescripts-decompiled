local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GetPlaytestModeStore = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon.GetPlaytestModeStore)
local PlayerPermissionsModule = require(RobloxGui.Modules.PlayerPermissionsModule)

local function initPlaytestMode() -- line: 10
	-- upvalues: GetPlaytestModeStore (copy), PlayerPermissionsModule (copy), Players (copy)
	local v8 = GetPlaytestModeStore(false)

	task.spawn(function() -- line: 13
		-- upvalues: v8 (copy), PlayerPermissionsModule (copy), Players (copy)
		v8.setHasEditAccess(PlayerPermissionsModule.CanPlayerManagePlaceAsync(Players.LocalPlayer))
	end)
end

return initPlaytestMode
