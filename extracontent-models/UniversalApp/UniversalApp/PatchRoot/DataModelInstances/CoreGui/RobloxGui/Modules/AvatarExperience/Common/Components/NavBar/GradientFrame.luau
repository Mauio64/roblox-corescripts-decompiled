local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local useStyle = UIBlox.Core.Style.useStyle
local GetFFlagAXEnableAutomaticSizeGradientFrame = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableAutomaticSizeGradientFrame)

local function GradientFrame(t1: {[any]: any}) -- line: 28
	-- upvalues: GetFFlagAXEnableAutomaticSizeGradientFrame (copy), useStyle (copy), React (copy)
	local frameRef = t1.frameRef
	local gradientStyle = t1.gradientStyle
	local v11 = if GetFFlagAXEnableAutomaticSizeGradientFrame() then nil else t1.height
	local t1ZIndex = t1.ZIndex
	local Theme = useStyle().Theme
	local v14 = gradientStyle and gradientStyle.Color or Theme.BackgroundDefault.Color
	local v15 = gradientStyle and gradientStyle.Transparency or Theme.BackgroundDefault.Transparency

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = t1ZIndex,
		ref = frameRef
	}, {
		Left = React.createElement("Frame", {
			BackgroundTransparency = v15,
			BackgroundColor3 = v14,
			Size = UDim2.new(0, 50, not GetFFlagAXEnableAutomaticSizeGradientFrame() and 0 or 1, if not GetFFlagAXEnableAutomaticSizeGradientFrame() then v11 else 0)
		}, {
			Gradient = React.createElement("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}),
		Right = React.createElement("Frame", {
			BackgroundTransparency = v15,
			BackgroundColor3 = v14,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.new(0, 50, not GetFFlagAXEnableAutomaticSizeGradientFrame() and 0 or 1, if not GetFFlagAXEnableAutomaticSizeGradientFrame() then v11 else 0)
		}, {
			Gradient = React.createElement("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0)
				})
			})
		})
	})
end

return GradientFrame
