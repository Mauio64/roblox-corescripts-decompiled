local Parent = script:FindFirstAncestor("RoactUtils").Parent
local GetFFlagMigrateRoactUtilsToReactUtils = require(Parent.SharedFlags).GetFFlagMigrateRoactUtilsToReactUtils
local ReactUtils = require(Parent.ReactUtils)

if GetFFlagMigrateRoactUtilsToReactUtils() then
	return ReactUtils.EventConnection
end

local Roact = require(Parent.Roact)
local v5 = Roact.Component:extend("ExternalEventConnection")

function v5.init(p1) -- line: 17
	p1.connection = nil
end
function v5.render(p2) -- line: 34
	-- upvalues: Roact (copy)
	return Roact.oneChild(p2.props[Roact.Children])
end
function v5.didMount(p3) -- line: 38
	p3.connection = p3.props.event:Connect(p3.props.callback)
end
function v5.didUpdate(p4, p5) -- line: 45
	if p4.props.event ~= p5.event or p4.props.callback ~= p5.callback then
		p4.connection:Disconnect()
		p4.connection = p4.props.event:Connect(p4.props.callback)
	end
end
function v5.willUnmount(p6) -- line: 53
	if p6.connection then
		p6.connection:Disconnect()
		p6.connection = nil
	end
end

return v5
