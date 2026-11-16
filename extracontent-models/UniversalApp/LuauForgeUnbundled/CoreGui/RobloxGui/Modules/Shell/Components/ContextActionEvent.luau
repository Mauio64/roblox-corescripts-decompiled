local ContextActionService = game:GetService("ContextActionService")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local extended = Roact.Component:extend("ContextActionEvent")

function extended.render(p2): nil
	return nil
end

function extended.didMount(p2)
	if p2.props.actionPriority then
		ContextActionService:BindCoreActionAtPriority(
			p2.props.name,
			p2.props.callback,
			false,
			2000 + p2.props.actionPriority,
			unpack(p2.props.binds)
		)
	else
		ContextActionService:BindCoreAction(p2.props.name, p2.props.callback, false, unpack(p2.props.binds))
	end
end

function extended.didUpdate(p2, p3)
	if p2.props.callback ~= p3.callback or p2.props.name ~= p3.name then
		ContextActionService:UnbindCoreAction(p3.name)

		if p2.props.actionPriority then
			ContextActionService:BindCoreActionAtPriority(
				p2.props.name,
				p2.props.callback,
				false,
				2000 + p2.props.actionPriority,
				unpack(p2.props.binds)
			)
		else
			ContextActionService:BindCoreAction(
				p2.props.name,
				p2.props.callback,
				false,
				unpack(p2.props.binds)
			)
		end
	end
end

function extended.willUnmount(p2)
	ContextActionService:UnbindCoreAction(p2.props.name)
end

return extended
