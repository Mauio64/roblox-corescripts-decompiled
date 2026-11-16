local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Parent.Components
local DataConsumer = require(Components.DataConsumer)
local MemoryView = require(Components.Memory.MemoryView)

local extended = Roact.Component:extend("ClientMemory")

function extended.render(p)
	return Roact.createElement(MemoryView, {
		layoutOrder = p.props.layoutOrder,
		size = p.props.size,
		searchTerm = p.props.searchTerm,
		targetMemoryData = p.props.ClientMemoryData
	})
end

return DataConsumer(extended, "ClientMemoryData")
