local module = require("@luauforge/bundled/gvb")
require("@luauforge/bundled/gvc")
local LoadingStatePage = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Container/LoadingStatePage")
local module3 = require("@luauforge/bundled/gvw")

local function CreateOdpSessionNode(p2)
	local report = p2.report
	local props = p2.props
	local v5 = module.useContext(module3)

	module.useEffect(function()
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

	return module.createElement(LoadingStatePage)
end

return CreateOdpSessionNode
