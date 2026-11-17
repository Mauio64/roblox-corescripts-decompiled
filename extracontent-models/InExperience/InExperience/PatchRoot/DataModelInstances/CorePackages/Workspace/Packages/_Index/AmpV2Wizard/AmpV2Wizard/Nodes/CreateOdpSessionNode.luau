local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)
require(AmpV2Wizard.Types)
local WizardSpinner = require(AmpV2Wizard.WizardSpinner)
local OdpSessionApiContext = require(AmpV2Wizard.OdpSessionApiContext)

local function CreateOdpSessionNode(p)
	local report = p.report
	local props = p.props
	local v = React.useContext(OdpSessionApiContext)

	React.useEffect(function()
		local v2 = false

		local v3 = {
			requestType = props.requestType,
			requestDetails = props.requestDetails,
			isOdpInitiatedRequest = props.isOdpInitiated,
			odpProfileId = props.odpProfileId
		}

		v.startOdpSession(v3):andThen(function(p2)
			if not v2 then
				report("Success", { odpSessionId = p2.odpSessionId })
			end
		end):catch(function()
			if not v2 then
				report("Error")
			end
		end)

		return function()
			v2 = true
		end
	end, {})

	return React.createElement(WizardSpinner)
end

return CreateOdpSessionNode
