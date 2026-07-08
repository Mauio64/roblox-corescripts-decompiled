local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local DataConsumer = require(script.Parent.Parent.DataConsumer)
local LogOutput = require(script.Parent.LogOutput)
local v5 = Roact.Component:extend("ClientLog")

function v5.init(p1) -- line: 9
	function p1.initClientLogData() -- line: 10
		-- upvalues: p1 (copy)
		return p1.props.ClientLogData:getLogData()
	end
end
function v5.render(p2) -- line: 14
	-- upvalues: Roact (copy), LogOutput (copy)
	return Roact.createElement(LogOutput, {
		layoutOrder = p2.props.layoutOrder,
		size = p2.props.size,
		initLogOutput = p2.initClientLogData,
		targetSignal = p2.props.ClientLogData:Signal()
	})
end

return DataConsumer(v5, "ClientLogData")
