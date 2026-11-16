local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Parent.Components
local DataConsumer = require(Components.DataConsumer)
local NetworkView = require(script.Parent.NetworkView)

local extended = Roact.Component:extend("ServerNetwork")

function extended:init(_)
	self.state = { targetNetworkData = self.props.ServerNetworkData }
end

function extended.render(p)
	local layoutOrder = p.props.layoutOrder
	local searchTerm = p.props.searchTerm
	local size = p.props.size

	return Roact.createElement(NetworkView, {
		size = size,
		searchTerm = searchTerm,
		layoutOrder = layoutOrder,
		targetNetworkData = p.state.targetNetworkData
	})
end

return DataConsumer(extended, "ServerNetworkData")
