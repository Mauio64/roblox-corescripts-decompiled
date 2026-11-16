local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Parent.Components
local DataConsumer = require(Components.DataConsumer)
local MemoryView = require(Components.Memory.MemoryView)

local extended = Roact.Component:extend("ServerMemory")

function extended.render(p)
	return Roact.createElement(MemoryView, {
		layoutOrder = p.props.layoutOrder,
		size = p.props.size,
		searchTerm = p.props.searchTerm,
		targetMemoryData = p.props.ServerMemoryData
	})
end

return DataConsumer(extended, "ServerMemoryData")
