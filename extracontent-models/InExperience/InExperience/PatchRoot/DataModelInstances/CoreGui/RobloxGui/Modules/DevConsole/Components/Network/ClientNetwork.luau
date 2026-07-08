local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Components = script.Parent.Parent.Parent.Components
local DataConsumer = require(Components.DataConsumer)
local NetworkView = require(script.Parent.NetworkView)
local v6 = Roact.Component:extend("ClientNetwork")

function v6.init(p1, _) -- line: 10
	p1.state = {
		targetNetworkData = p1.props.ClientNetworkData
	}
end
function v6.render(p3) -- line: 16
	-- upvalues: Roact (copy), NetworkView (copy)
	local layoutOrder = p3.props.layoutOrder
	local searchTerm = p3.props.searchTerm
	local size = p3.props.size

	return Roact.createElement(NetworkView, {
		size = size,
		searchTerm = searchTerm,
		layoutOrder = layoutOrder,
		targetNetworkData = p3.state.targetNetworkData
	})
end

return DataConsumer(v6, "ClientNetworkData")
