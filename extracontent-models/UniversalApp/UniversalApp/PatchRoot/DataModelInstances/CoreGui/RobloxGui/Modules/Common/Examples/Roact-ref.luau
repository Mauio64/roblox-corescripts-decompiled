local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local v3 = Roact.Component:extend("App")

function v3.init(p1) -- line: 21
	-- upvalues: Roact (copy)
	p1.ref = Roact.createRef()
end
function v3.render(p2) -- line: 25
	-- upvalues: Roact (copy)
	return Roact.createElement("Frame", {
		Size = UDim2.new(0, 123, 0, 123),
		[Roact.Ref] = p2.ref
	})
end
function v3.didMount(p3) -- line: 33
	print("Roblox Instance:", p3.ref.current)
	print("Roblox Instance Size:", p3.ref.current.Size)
end

return function() -- line: 38
	-- upvalues: Roact (copy), v3 (copy)
	local v7 = Roact.createElement(v3)

	Roact.mount(v7, nil, "SomeName")
end
