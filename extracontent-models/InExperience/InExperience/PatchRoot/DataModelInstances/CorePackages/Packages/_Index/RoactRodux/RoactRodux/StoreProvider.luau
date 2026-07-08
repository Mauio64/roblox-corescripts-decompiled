local Roact = require(script.Parent.Parent.Roact)
local StoreContext = require(script.Parent.StoreContext)
local v3 = Roact.Component:extend("StoreProvider")

function v3.validateProps(p1) -- line: 7
	if p1.store == nil then
		return false, "Error initializing StoreProvider. Expected a `store` prop to be a Rodux store."
	end

	return true
end
function v3.init(p2, p3) -- line: 15
	p2.store = p3.store
end
function v3.render(p4) -- line: 19
	-- upvalues: Roact (copy), StoreContext (copy)
	return Roact.createElement(StoreContext.Provider, {
		value = p4.store
	}, Roact.oneChild(p4.props[Roact.Children]))
end

return v3
