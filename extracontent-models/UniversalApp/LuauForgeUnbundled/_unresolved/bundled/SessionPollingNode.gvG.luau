local module = require("@luauforge/bundled/gvb")
require("@luauforge/bundled/gvc")
local LoadingStatePage = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Container/LoadingStatePage")
local module3 = require("@luauforge/bundled/gvH")
local module4 = require("@luauforge/bundled/gvL")

local function SessionPollingNode(props)
	local report = props.report
	local props2 = props.props
	local pollIntervalMs = props2.pollIntervalMs or 2000

	module.useEffect(function()
		local thread = task.delay(pollIntervalMs / 1000, function()
			report("Poll")
		end)
		return function()
			task.cancel(thread)
		end
	end, { props2, pollIntervalMs, report })

	if module4 and props.dismiss ~= nil then
		return module.createElement(module3, { onCancel = props.dismiss })
	end

	return module.createElement(LoadingStatePage)
end

return SessionPollingNode
