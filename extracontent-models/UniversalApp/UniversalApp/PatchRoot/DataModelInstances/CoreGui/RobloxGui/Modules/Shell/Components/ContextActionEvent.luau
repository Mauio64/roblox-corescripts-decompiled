local ContextActionService = game:GetService("ContextActionService")
local CorePackages = game:GetService("CorePackages")
local v3 = require(CorePackages.Packages.Roact).Component:extend("ContextActionEvent")

function v3.render(_) -- line: 29
	return nil
end
function v3.didMount(p2) -- line: 33
	-- upvalues: ContextActionService (copy)
	if p2.props.actionPriority then
		ContextActionService:BindCoreActionAtPriority(p2.props.name, p2.props.callback, false, 2000 + p2.props.actionPriority, unpack(p2.props.binds))

		return
	end

	ContextActionService:BindCoreAction(p2.props.name, p2.props.callback, false, unpack(p2.props.binds))
end
function v3.didUpdate(p3, p4) -- line: 41
	-- upvalues: ContextActionService (copy)
	if p3.props.callback ~= p4.callback or p3.props.name ~= p4.name then
		ContextActionService:UnbindCoreAction(p4.name)

		if p3.props.actionPriority then
			ContextActionService:BindCoreActionAtPriority(p3.props.name, p3.props.callback, false, 2000 + p3.props.actionPriority, unpack(p3.props.binds))

			return
		end

		ContextActionService:BindCoreAction(p3.props.name, p3.props.callback, false, unpack(p3.props.binds))
	end
end
function v3.willUnmount(p5) -- line: 52
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction(p5.props.name)
end

return v3
