local parent = script:FindFirstAncestor("PioneerUtils").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagDebugEnablePioneerUX = SharedFlags.FFlagDebugEnablePioneerUX
local PioneerInfo = require(script.Parent.PioneerInfo)

local defineFastFlag = game:DefineFastFlag("EnablePioneerUX", false)

local function isPioneerLaunch()
	return FFlagDebugEnablePioneerUX or defineFastFlag and PioneerInfo.isPioneerApp()
end

return isPioneerLaunch
