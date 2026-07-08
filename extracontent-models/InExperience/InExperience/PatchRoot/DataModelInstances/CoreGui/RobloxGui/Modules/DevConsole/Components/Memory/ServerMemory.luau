local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Components = script.Parent.Parent.Parent.Components
local DataConsumer = require(Components.DataConsumer)
local MemoryView = require(Components.Memory.MemoryView)
local v6 = Roact.Component:extend("ServerMemory")

function v6.render(p1) -- line: 10
	-- upvalues: Roact (copy), MemoryView (copy)
	return Roact.createElement(MemoryView, {
		layoutOrder = p1.props.layoutOrder,
		size = p1.props.size,
		searchTerm = p1.props.searchTerm,
		targetMemoryData = p1.props.ServerMemoryData
	})
end

return DataConsumer(v6, "ServerMemoryData")
