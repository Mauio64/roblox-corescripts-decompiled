local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local DataConsumer = require(script.Parent.Parent.DataConsumer)
local LogOutput = require(script.Parent.LogOutput)

local extended = Roact.Component:extend("ClientLog")

function extended:init()
	function self.initClientLogData()
		return self.props.ClientLogData:getLogData()
	end
end
function extended.render(p)
	return Roact.createElement(LogOutput, {
		layoutOrder = p.props.layoutOrder,
		size = p.props.size,
		initLogOutput = p.initClientLogData,
		targetSignal = p.props.ClientLogData:Signal()
	})
end

return DataConsumer(extended, "ClientLogData")
