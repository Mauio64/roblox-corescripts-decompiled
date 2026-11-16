local parent = script.Parent.Parent.Parent.Parent.Parent

local React = require(parent.React)

local LayerCollectorContext = require(script.Parent.LayerCollectorContext)

return function()
	return (React.useContext(LayerCollectorContext))
end
