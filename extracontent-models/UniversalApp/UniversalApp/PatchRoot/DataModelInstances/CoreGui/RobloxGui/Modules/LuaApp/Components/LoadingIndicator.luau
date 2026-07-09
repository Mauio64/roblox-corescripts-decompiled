local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(CorePackages.Workspace.Packages.AppChat.Constants)
local ExternalEventConnection = require(Modules.Common.RoactUtilities.ExternalEventConnection)
local Roact = require(Modules.Common.Roact)
local GRAY3 = Constants.Color.GRAY3
local BLUE_PRIMARY = Constants.Color.BLUE_PRIMARY
local v11 = Roact.PureComponent:extend("LoadingIndicator")

v11.defaultProps = {
	AnimationSpeedMultiplier = 1.75,
	DotScale = 0.7,
	DotColor = GRAY3,
	DotHighlightColor = BLUE_PRIMARY,
	Size = UDim2.new(0, 70, 0, 16)
}

function v11.init(p1) -- line: 32
	p1.state = {
		timer = true
	}

	function p1.renderSteppedCallback(_) -- line: 37
		-- upvalues: p1 (copy)
		local t1 = {
			timer = not p1.state.timer
		}

		p1:setState(t1)
	end
end
function v11.render(p3) -- line: 45
	-- upvalues: Workspace (copy), Roact (copy), ExternalEventConnection (copy), RunService (copy)
	local AnimationSpeedMultiplier = p3.props.AnimationSpeedMultiplier
	local DotColor = p3.props.DotColor
	local DotHighlightColor = p3.props.DotHighlightColor
	local DotScale = p3.props.DotScale
	local propsSize = p3.props.Size
	local v19 = Workspace.DistributedGameTime * AnimationSpeedMultiplier % 3
	local t2 = {
		RatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = 4.375,
			AspectType = Enum.AspectType.FitWithinMaxSize
		})
	}

	for i = 1, 3 do
		local v22 = DotColor
		local v23 = DotScale
		local v24 = (i - 1) / 2

		if v19 >= i - 1 and v19 <= i then
			local v25 = math.sin(3.141592653589793 * (v19 % 1))

			v23 += (1 - v23) * v25
			v22 = DotColor:lerp(DotHighlightColor, v25)
		end

		t2[i] = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(v24, 0.5),
			BackgroundColor3 = v22,
			Size = UDim2.new(DotScale, 0, v23, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			Position = UDim2.new(v24, 0, 0.5, 0)
		})
	end

	t2.RenderStepped = Roact.createElement(ExternalEventConnection, {
		callback = p3.renderSteppedCallback,
		event = RunService.renderStepped
	})

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = p3.props.AnchorPoint,
		Position = p3.props.Position,
		Size = propsSize
	}, t2)
end

return v11
