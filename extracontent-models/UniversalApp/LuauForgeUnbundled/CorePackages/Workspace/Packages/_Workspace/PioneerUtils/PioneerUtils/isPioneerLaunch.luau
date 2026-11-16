local fFlagDebugEnablePioneerUX = require("@game/CorePackages/Workspace/Packages/_Workspace/PioneerUtils/SharedFlags").FFlagDebugEnablePioneerUX
local PioneerInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/PioneerUtils/PioneerUtils/PioneerInfo")

local defineFastFlag = game:DefineFastFlag("EnablePioneerUX", false)

local function isPioneerLaunch()
	return fFlagDebugEnablePioneerUX or defineFastFlag and PioneerInfo.isPioneerApp()
end

return isPioneerLaunch
