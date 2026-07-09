local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local v3 = Roact.Component:extend("ContextProvider")

function v3.init(p1) -- line: 18
	p1._context = {
		someValue = 5
	}
end
function v3.render(p2) -- line: 25
	-- upvalues: Roact (copy)
	return Roact.oneChild(p2.props[Roact.Children])
end

local v4 = Roact.Component:extend("ContextReader")

function v4.init(p3) -- line: 32
	print("Context value of", p3._context.someValue)
end
function v4.render(_) -- line: 37
	return nil
end

return function() -- line: 41
	-- upvalues: Roact (copy), v3 (copy), v4 (copy)
	local v9 = Roact.createElement(v3, {}, {
		SomeChild = Roact.createElement(v4)
	})

	Roact.mount(v9, nil, "SomeName")
end
