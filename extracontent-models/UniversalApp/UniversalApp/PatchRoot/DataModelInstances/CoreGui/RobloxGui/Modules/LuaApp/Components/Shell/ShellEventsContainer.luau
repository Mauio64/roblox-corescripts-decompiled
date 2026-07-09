local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local FFlagLogKeyboardFocusModeEntered = require(Modules.LuaApp.Flags.FFlagLogKeyboardFocusModeEntered)
local useLogStatusBarTapped = require(CorePackages.Workspace.Packages.UiShellEvents).useLogStatusBarTapped
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local useLogInputTypeChanged = require(CorePackages.Workspace.Packages.UiShellEvents).useLogInputTypeChanged
local useLogKeyboardFocusModeEntered = require(CorePackages.Workspace.Packages.UiShellEvents).useLogKeyboardFocusModeEntered
local useLogOrientationChanged = require(CorePackages.Workspace.Packages.UiShellEvents).useLogOrientationChanged

local function ShellEventsContainer(t1: {[any]: any}) -- line: 18
	-- upvalues: useLogStatusBarTapped (copy), useRoactService (copy), AppEventIngestService (copy), useLogInputTypeChanged (copy), FFlagLogKeyboardFocusModeEntered (copy), useLogKeyboardFocusModeEntered (copy), useLogOrientationChanged (copy)
	useLogStatusBarTapped(t1.currentPage)

	local v12 = useRoactService(AppEventIngestService)

	useLogInputTypeChanged(v12)

	if FFlagLogKeyboardFocusModeEntered then
		useLogKeyboardFocusModeEntered()
	end

	useLogOrientationChanged(v12, nil, t1.currentPage)

	return nil
end

return ShellEventsContainer
