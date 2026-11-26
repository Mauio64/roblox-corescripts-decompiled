local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")
require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local WizardSpinner = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/WizardSpinner")
local AuthorizationLoadingModal = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/AuthorizationLoadingModal")
local FFlagAmpV2WizardAuthorizationModal = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FFlagAmpV2WizardAuthorizationModal")

local function SessionPollingNode(props)
	local report = props.report
	local props2 = props.props
	local pollIntervalMs = props2.pollIntervalMs or 2000

	React.useEffect(function()
		local thread = task.delay(pollIntervalMs / 1000, function()
			report("Poll")
		end)
		return function()
			task.cancel(thread)
		end
	end, { props2, pollIntervalMs, report })

	if FFlagAmpV2WizardAuthorizationModal and props.dismiss ~= nil then
		return React.createElement(AuthorizationLoadingModal, { onCancel = props.dismiss })
	end

	return React.createElement(WizardSpinner)
end

return SessionPollingNode
