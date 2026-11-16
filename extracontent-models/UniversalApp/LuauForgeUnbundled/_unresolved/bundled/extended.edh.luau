local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local withStyle = UIBlox.Style.withStyle
local module = require("@luauforge/bundled/edi")

local rect = Rect.new(8, 8, 9, 9)

local extended = Roact.Component:extend("LoadingBarWithTheme")

function extended:init()
	self.barRef = Roact.createRef()
end

function extended.render(p2)
	local zIndex = p2.props.ZIndex

	return withStyle(function(p3)
		return Roact.createElement(module, {
			Image = "LuaApp/buttons/buttonFill",
			ImageColor3 = p3.Theme.SystemPrimaryDefault.Color,
			ImageTransparency = p3.Theme.SystemPrimaryDefault.Transparency,
			ScaleType = "Slice",
			SliceCenter = rect,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = zIndex,
			[Roact.Ref] = p2.barRef
		})
	end)
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
