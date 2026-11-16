local parent = script.Parent.Parent.Parent.Parent.Parent

local Roact = require(parent.Roact)

local LayerCollectorContext = require(script.Parent.LayerCollectorContext)

local function LayerCollectorConsumer(render)
	return Roact.createElement(LayerCollectorContext.Consumer, { render = render })
end

return LayerCollectorConsumer
