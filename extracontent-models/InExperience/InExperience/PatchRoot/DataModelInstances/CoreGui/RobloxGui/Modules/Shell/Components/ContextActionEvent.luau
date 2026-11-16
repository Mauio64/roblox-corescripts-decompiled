local ContextActionService = game:GetService("ContextActionService")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local extended = Roact.Component:extend("ContextActionEvent")

function extended.render(_): nil
	return nil
end

function extended.didMount(p)
	if p.props.actionPriority then
		ContextActionService:BindCoreActionAtPriority(
			p.props.name,
			p.props.callback,
			false,
			2000 + p.props.actionPriority,
			unpack(p.props.binds)
		)
	else
		ContextActionService:BindCoreAction(p.props.name, p.props.callback, false, unpack(p.props.binds))
	end
end

function extended.didUpdate(p, p2)
	if p.props.callback ~= p2.callback or p.props.name ~= p2.name then
		ContextActionService:UnbindCoreAction(p2.name)

		if p.props.actionPriority then
			ContextActionService:BindCoreActionAtPriority(
				p.props.name,
				p.props.callback,
				false,
				2000 + p.props.actionPriority,
				unpack(p.props.binds)
			)
		else
			ContextActionService:BindCoreAction(p.props.name, p.props.callback, false, unpack(p.props.binds))
		end
	end
end

function extended.willUnmount(p)
	ContextActionService:UnbindCoreAction(p.props.name)
end

return extended
