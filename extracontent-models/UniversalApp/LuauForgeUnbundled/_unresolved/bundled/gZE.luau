local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)

local extended = Roact.Component:extend("PageObjectManagerProvider")
local context = Roact.createContext(nil)

function extended.render(p2)
	return Roact.createElement(
		context.Provider,
		{ value = p2.props.pageObjectManager },
		p2.props[Roact.Children]
	)
end

return { Provider = extended, Consumer = context.Consumer }
