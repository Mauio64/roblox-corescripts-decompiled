local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local extended = Roact.Component:extend("RenderStep")

function extended.render(p2): nil
	return nil
end

function extended.didMount(p2)
	RunService:BindToRenderStep(p2.props.name, p2.props.priority, p2.props.callback)
end

function extended.didUpdate(p2, p3)
	if p2.props.callback ~= p3.callback or p2.props.name ~= p3.name then
		RunService:UnbindFromRenderStep(p3.name)
		RunService:BindToRenderStep(p2.props.name, p2.props.priority, p2.props.callback)
	end
end

function extended.willUnmount(p2)
	RunService:UnbindFromRenderStep(p2.props.name)
end

return extended
