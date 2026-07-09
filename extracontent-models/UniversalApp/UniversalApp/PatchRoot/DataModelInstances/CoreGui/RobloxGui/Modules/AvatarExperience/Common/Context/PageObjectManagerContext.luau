local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local v3 = Roact.Component:extend("PageObjectManagerProvider")
local v4 = Roact.createContext(nil)

function v3.render(p1) -- line: 8
	-- upvalues: Roact (copy), v4 (copy)
	return Roact.createElement(v4.Provider, {
		value = p1.props.pageObjectManager
	}, p1.props[Roact.Children])
end

return {
	Provider = v3,
	Consumer = v4.Consumer
}
