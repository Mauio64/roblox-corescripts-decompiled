local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local extended = Roact.Component:extend("RenderStep")

function extended.render(_): nil
	return nil
end

function extended.didMount(p)
	RunService:BindToRenderStep(p.props.name, p.props.priority, p.props.callback)
end

function extended.didUpdate(p, p2)
	if p.props.callback ~= p2.callback or p.props.name ~= p2.name then
		RunService:UnbindFromRenderStep(p2.name)
		RunService:BindToRenderStep(p.props.name, p.props.priority, p.props.callback)
	end
end

function extended.willUnmount(p)
	RunService:UnbindFromRenderStep(p.props.name)
end

return extended
