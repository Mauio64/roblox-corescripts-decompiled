local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Roact")

local rect = Rect.new(1, 0, 2, 3)

local extended = Roact.Component:extend("LoadingBar")

function extended:init()
	self.barRef = Roact.createRef()
end

function extended.render(p2)
	local zIndex = p2.props.ZIndex

	return Roact.createElement("ImageLabel", {
		Image = "rbxasset://textures/ui/LuaApp/9-slice/gr-loading-indicator.png",
		ScaleType = "Slice",
		SliceCenter = rect,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = zIndex,
		[Roact.Ref] = p2.barRef
	})
end

function extended:didMount()
	self.connection = RunService.RenderStepped:Connect(function()
		local distributedGameTime = Workspace.DistributedGameTime
		local current = self.barRef.current

		local v5 = (1 - math.cos(2 * distributedGameTime * 5.026548245743669)) * 7.5
		current.Size = UDim2.new(0, v5 + 4, 0, 4)

		local v6 = math.cos(distributedGameTime * 5.026548245743669) * 40
		current.Position = UDim2.new(0.5, v6 - v5 / 2 - 2, 0.5, 0)
	end)
end

function extended.willUnmount(p2)
	p2.connection:Disconnect()
end

return extended
