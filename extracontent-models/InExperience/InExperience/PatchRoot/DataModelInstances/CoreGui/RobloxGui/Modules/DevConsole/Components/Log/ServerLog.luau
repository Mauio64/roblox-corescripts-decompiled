local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local DataConsumer = require(script.Parent.Parent.DataConsumer)
local CommandLineHeight = require(script.Parent.Parent.Parent.Constants).LogFormatting.CommandLineHeight
local DevConsoleCommandLine = require(script.Parent.DevConsoleCommandLine)
local LogOutput = require(script.Parent.LogOutput)
local v7 = Roact.Component:extend("ServerLog")

function v7.init(p1) -- line: 15
	function p1.initServerLogData() -- line: 16
		-- upvalues: p1 (copy)
		return p1.props.ServerLogData:getLogData()
	end
end
function v7.render(p2) -- line: 21
	-- upvalues: Roact (copy), LogOutput (copy), CommandLineHeight (copy), DevConsoleCommandLine (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = p2.props.size,
		LayoutOrder = p2.props.layoutOrder
	}, {
		Scroll = Roact.createElement(LogOutput, {
			size = UDim2.new(1, 0, 1, -(CommandLineHeight + 4)),
			targetSignal = p2.props.ServerLogData:Signal(),
			initLogOutput = p2.initServerLogData
		}),
		CommandLine = Roact.createElement(DevConsoleCommandLine, {
			pos = UDim2.new(0, 0, 1, -CommandLineHeight),
			height = CommandLineHeight
		})
	})
end

return DataConsumer(v7, "ServerLogData")
