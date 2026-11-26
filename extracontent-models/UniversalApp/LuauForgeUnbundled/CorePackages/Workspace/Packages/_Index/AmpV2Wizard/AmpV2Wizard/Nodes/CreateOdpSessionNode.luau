local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")
require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local WizardSpinner = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/WizardSpinner")
local OdpSessionApiContext = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/OdpSessionApiContext")

local function CreateOdpSessionNode(p2)
	local report = p2.report
	local props = p2.props
	local v5 = React.useContext(OdpSessionApiContext)

	React.useEffect(function()
		local v6 = false

		local v7 = {
			requestType = props.requestType,
			requestDetails = props.requestDetails,
			isOdpInitiatedRequest = props.isOdpInitiated,
			odpProfileId = props.odpProfileId
		}

		v5.startOdpSession(v7):andThen(function(p3)
			if not v6 then
				report("Success", { odpSessionId = p3.odpSessionId })
			end
		end):catch(function()
			if not v6 then
				report("Error")
			end
		end)

		return function()
			v6 = true
		end
	end, {})

	return React.createElement(WizardSpinner)
end

return CreateOdpSessionNode
