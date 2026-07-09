local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("AppBlox").Parent
local Roact = require(Parent.Roact)
local rect = Rect.new(1, 0, 2, 3)
local v6 = Roact.Component:extend("LoadingBar")

function v6.init(p1) -- line: 16
	-- upvalues: Roact (copy)
	p1.barRef = Roact.createRef()
end
function v6.render(p2) -- line: 20
	-- upvalues: Roact (copy), rect (copy)
	local propsZIndex = p2.props.ZIndex

	return Roact.createElement("ImageLabel", {
		Image = "rbxasset://textures/ui/LuaApp/9-slice/gr-loading-indicator.png",
		ScaleType = "Slice",
		SliceCenter = rect,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = propsZIndex,
		[Roact.Ref] = p2.barRef
	})
end
function v6.didMount(p3) -- line: 34
	-- upvalues: RunService (copy), Workspace (copy)
	p3.connection = RunService.RenderStepped:Connect(function() -- line: 35
		-- upvalues: Workspace (copy), p3 (copy)
		local DistributedGameTime = Workspace.DistributedGameTime
		local current = p3.barRef.current
		local v14 = (1 - math.cos(2 * DistributedGameTime * 5.026548245743669)) * 7.5

		current.Size = UDim2.new(0, v14 + 4, 0, 4)

		local v15 = math.cos(DistributedGameTime * 5.026548245743669) * 40

		current.Position = UDim2.new(0.5, v15 - v14 / 2 - 2, 0.5, 0)
	end)
end
function v6.willUnmount(p4) -- line: 48
	p4.connection:Disconnect()
end

return v6
