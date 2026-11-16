local useLogStatusBarTapped = require("@luauforge/bundled/hSC").useLogStatusBarTapped
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local useLogInputTypeChanged = require("@luauforge/bundled/hSC").useLogInputTypeChanged

local useLogKeyboardFocusModeEntered = require("@luauforge/bundled/hSC").useLogKeyboardFocusModeEntered
local useLogOrientationChanged = require("@luauforge/bundled/hSC").useLogOrientationChanged

local useLogFocusNavigationTelemetry = require("@luauforge/bundled/hSC").useLogFocusNavigationTelemetry
local fFlagEnableFocusNavTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableFocusNavTelemetry

local function ShellEventsContainer(p2): nil
	useLogStatusBarTapped(p2.currentPage)

	local v5 = useRoactService(appEventIngestService)
	useLogInputTypeChanged(v5)

	if fFlagEnableFocusNavTelemetry then
		useLogFocusNavigationTelemetry(p2.currentPage)
	else
		useLogKeyboardFocusModeEntered()
	end

	useLogOrientationChanged(v5, nil, p2.currentPage)

	return nil
end

return ShellEventsContainer
