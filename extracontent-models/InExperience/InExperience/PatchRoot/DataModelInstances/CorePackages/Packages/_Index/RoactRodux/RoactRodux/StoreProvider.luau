local Roact = require(script.Parent.Parent.Roact)

local StoreContext = require(script.Parent.StoreContext)

local extended = Roact.Component:extend("StoreProvider")

function extended.validateProps(p)
	if p.store == nil then
		return false, "Error initializing StoreProvider. Expected a `store` prop to be a Rodux store."
	end

	return true
end

function extended:init(p)
	self.store = p.store
end

function extended.render(p)
	return Roact.createElement(StoreContext.Provider, { value = p.store }, Roact.oneChild(p.props[Roact.Children]))
end

return extended
