local ParentParent = script.Parent.Parent.Parent.Parent.Parent
local Roact = require(ParentParent.Roact)
local LayerCollectorContext = require(script.Parent.LayerCollectorContext)

local function LayerCollectorConsumer(p1) -- line: 9
	-- upvalues: Roact (copy), LayerCollectorContext (copy)
	return Roact.createElement(LayerCollectorContext.Consumer, {
		render = p1
	})
end

return LayerCollectorConsumer
