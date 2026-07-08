local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local LayoutValuesContext = require(script.Parent.LayoutValuesContext)

local function layoutValuesProvider(p1) -- line: 7
	-- upvalues: Roact (copy), LayoutValuesContext (copy)
	return Roact.createElement(LayoutValuesContext.Provider, {
		value = p1.layoutValues
	}, Roact.oneChild(p1[Roact.Children]))
end
local function withLayoutValues(p2) -- line: 13
	-- upvalues: Roact (copy), LayoutValuesContext (copy)
	assert(type(p2) == "function", "Expect withLayoutValues callback to be a function.")

	return Roact.createElement(LayoutValuesContext.Consumer, {
		render = p2
	})
end

return {
	Provider = layoutValuesProvider,
	Consumer = LayoutValuesContext.Consumer,
	WithLayoutValues = withLayoutValues
}
