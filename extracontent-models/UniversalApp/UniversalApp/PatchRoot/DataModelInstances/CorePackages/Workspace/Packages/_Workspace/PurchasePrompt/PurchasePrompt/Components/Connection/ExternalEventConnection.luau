local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local Roact = require(Parent.PurchasePromptDeps).Roact
local v3 = Roact.Component:extend("ExternalEventConnection")

function v3.init(p1) -- line: 12
	p1.connection = nil
end
function v3.render(p2) -- line: 29
	-- upvalues: Roact (copy)
	return Roact.oneChild(p2.props[Roact.Children])
end
function v3.didMount(p3) -- line: 33
	p3.connection = p3.props.event:Connect(p3.props.callback)
end
function v3.didUpdate(p4, p5) -- line: 40
	if p4.props.event ~= p5.event or p4.props.callback ~= p5.callback then
		p4.connection:Disconnect()
		p4.connection = p4.props.event:Connect(p4.props.callback)
	end
end
function v3.willUnmount(p6) -- line: 48
	if p6.connection then
		p6.connection:Disconnect()
		p6.connection = nil
	end
end

return v3
