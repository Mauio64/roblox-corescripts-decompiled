local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local rect = Rect.new(8, 8, 9, 9)
local v9 = Roact.Component:extend("LoadingBarWithTheme")

function v9.init(p1) -- line: 21
	-- upvalues: Roact (copy)
	p1.barRef = Roact.createRef()
end
function v9.render(p2) -- line: 25
	-- upvalues: withStyle (copy), Roact (copy), DEPRECATED_ImageSetLabel (copy), rect (copy)
	local propsZIndex = p2.props.ZIndex

	return withStyle(function(p3) -- line: 28
		-- upvalues: Roact (copy), DEPRECATED_ImageSetLabel (copy), rect (copy), propsZIndex (copy), p2 (copy)
		return Roact.createElement(DEPRECATED_ImageSetLabel, {
			Image = "LuaApp/buttons/buttonFill",
			ImageColor3 = p3.Theme.SystemPrimaryDefault.Color,
			ImageTransparency = p3.Theme.SystemPrimaryDefault.Transparency,
			ScaleType = "Slice",
			SliceCenter = rect,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = propsZIndex,
			[Roact.Ref] = p2.barRef
		})
	end)
end
function v9.didMount(p4) -- line: 43
	-- upvalues: RunService (copy), Workspace (copy)
	p4.connection = RunService.RenderStepped:Connect(function() -- line: 44
		-- upvalues: Workspace (copy), p4 (copy)
		local DistributedGameTime = Workspace.DistributedGameTime
		local current = p4.barRef.current
		local v18 = (1 - math.cos(2 * DistributedGameTime * 5.026548245743669)) * 7.5

		current.Size = UDim2.new(0, v18 + 4, 0, 4)

		local v19 = math.cos(DistributedGameTime * 5.026548245743669) * 40

		current.Position = UDim2.new(0.5, v19 - v18 / 2 - 2, 0.5, 0)
	end)
end
function v9.willUnmount(p5) -- line: 57
	p5.connection:Disconnect()
end

return v9
