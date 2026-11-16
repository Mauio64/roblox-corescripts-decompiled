local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local DataConsumer = require(script.Parent.Parent.DataConsumer)

local Constants = require(script.Parent.Parent.Parent.Constants)
local CommandLineHeight = Constants.LogFormatting.CommandLineHeight

local DevConsoleCommandLine = require(script.Parent.DevConsoleCommandLine)
local LogOutput = require(script.Parent.LogOutput)

local extended = Roact.Component:extend("ServerLog")

function extended:init()
	function self.initServerLogData()
		return self.props.ServerLogData:getLogData()
	end
end

function extended.render(p)
	return Roact.createElement(
		"Frame",
		{ Size = p.props.size, BackgroundTransparency = 1, LayoutOrder = p.props.layoutOrder },
		{
			Scroll = Roact.createElement(LogOutput, {
				size = UDim2.new(1, 0, 1, -(CommandLineHeight + 4)),
				targetSignal = p.props.ServerLogData:Signal(),
				initLogOutput = p.initServerLogData
			}),
			CommandLine = Roact.createElement(DevConsoleCommandLine, {
				pos = UDim2.new(0, 0, 1, -CommandLineHeight),
				height = CommandLineHeight
			})
		}
	)
end

return DataConsumer(extended, "ServerLogData")
