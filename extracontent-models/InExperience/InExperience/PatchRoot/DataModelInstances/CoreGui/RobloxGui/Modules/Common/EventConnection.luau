local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local v3 = Roact.Component:extend("EventConnection")

function v3.init(p1) -- line: 11
	p1.connection = nil
end
function v3.render(p2) -- line: 28
	-- upvalues: Roact (copy)
	return Roact.oneChild(p2.props[Roact.Children])
end
function v3.didMount(p3) -- line: 32
	p3.connection = p3.props.event:Connect(p3.props.callback)
end
function v3.didUpdate(p4, p5) -- line: 39
	if p4.props.event ~= p5.event or p4.props.callback ~= p5.callback then
		p4.connection:Disconnect()
		p4.connection = p4.props.event:Connect(p4.props.callback)
	end
end
function v3.willUnmount(p6) -- line: 47
	if p6.connection then
		p6.connection:Disconnect()
		p6.connection = nil
	end
end

return v3
