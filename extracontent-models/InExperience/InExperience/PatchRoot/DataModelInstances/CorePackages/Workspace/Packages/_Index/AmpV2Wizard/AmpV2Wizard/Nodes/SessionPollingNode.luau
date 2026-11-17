local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)
require(AmpV2Wizard.Types)
local WizardSpinner = require(AmpV2Wizard.WizardSpinner)
local AuthorizationLoadingModal = require(AmpV2Wizard.AuthorizationLoadingModal)
local FFlagAmpV2WizardAuthorizationModal = require(AmpV2Wizard.FFlagAmpV2WizardAuthorizationModal)

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
