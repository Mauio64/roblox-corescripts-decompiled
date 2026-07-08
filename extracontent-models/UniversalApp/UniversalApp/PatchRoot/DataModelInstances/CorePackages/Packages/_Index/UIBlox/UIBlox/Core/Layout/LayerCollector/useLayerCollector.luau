local ParentParent = script.Parent.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local LayerCollectorContext = require(script.Parent.LayerCollectorContext)

return function() -- line: 9
	-- upvalues: React (copy), LayerCollectorContext (copy)
	return (React.useContext(LayerCollectorContext))
end
