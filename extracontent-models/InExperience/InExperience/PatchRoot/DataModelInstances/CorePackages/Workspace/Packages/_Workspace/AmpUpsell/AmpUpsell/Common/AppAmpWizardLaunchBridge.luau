local parent = script:FindFirstAncestor("AmpUpsell").Parent

local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal
require(script.Parent.Types)

local v = Signal.new()
local AppAmpWizardLaunchBridge = {}

function AppAmpWizardLaunchBridge.requestOpen(params)
	local v2 = { params = params, handled = false }

	v:fire(v2)
	return v2.handled
end

function AppAmpWizardLaunchBridge.subscribe(callback)
	return v:connect(function(state)
		if state.handled then
			return
		end

		state.handled = true
		callback(state.params)
	end)
end

return AppAmpWizardLaunchBridge
