local CorePackages = game:GetService("CorePackages")
local v2 = require(CorePackages.Packages.Roact).Component:extend("EventConnection")

function v2.init(p1) -- line: 7
	p1.connection = nil
end
function v2.didMount(p2) -- line: 11
	p2.connection = p2.props.event:Connect(p2.props.callback)
end
function v2.render(_) -- line: 15
	return nil
end
function v2.didUpdate(p4, p5) -- line: 19
	if p4.props.event ~= p5.event or p4.props.callback ~= p5.callback then
		p4.connection:Disconnect()
		p4.connection = p4.props.event:Connect(p4.props.callback)
	end
end
function v2.willUnmount(p6) -- line: 27
	if p6.connection then
		p6.connection:Disconnect()
		p6.connection = nil
	end
end

return v2
