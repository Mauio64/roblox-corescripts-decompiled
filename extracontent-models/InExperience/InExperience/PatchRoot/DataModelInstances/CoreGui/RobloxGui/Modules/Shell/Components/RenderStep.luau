local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local v3 = require(CorePackages.Packages.Roact).Component:extend("RenderStep")

function v3.render(_) -- line: 23
	return nil
end
function v3.didMount(p2) -- line: 27
	-- upvalues: RunService (copy)
	RunService:BindToRenderStep(p2.props.name, p2.props.priority, p2.props.callback)
end
function v3.didUpdate(p3, p4) -- line: 31
	-- upvalues: RunService (copy)
	if p3.props.callback ~= p4.callback or p3.props.name ~= p4.name then
		RunService:UnbindFromRenderStep(p4.name)
		RunService:BindToRenderStep(p3.props.name, p3.props.priority, p3.props.callback)
	end
end
function v3.willUnmount(p5) -- line: 38
	-- upvalues: RunService (copy)
	RunService:UnbindFromRenderStep(p5.props.name)
end

return v3
