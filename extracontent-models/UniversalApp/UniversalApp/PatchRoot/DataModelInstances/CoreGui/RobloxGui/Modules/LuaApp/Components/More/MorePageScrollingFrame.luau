local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local FitChildren = require(Modules.LuaApp.FitChildren)
local FFlagAppIaScrollAway = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAppIaScrollAway
local v8 = Roact.PureComponent:extend("MorePageScrollingFrame")

v8.defaultProps = {
	maxWidth = 1e999
}

function v8.render(p1) -- line: 18
	-- upvalues: FFlagAppIaScrollAway (copy), Roact (copy), FitChildren (copy), AppNavBar (copy)
	local propsPosition = p1.props.Position
	local propsSize = p1.props.Size
	local maxWidth = p1.props.maxWidth
	local v13 = if not FFlagAppIaScrollAway then nil else p1.props.topBarHeight

	return Roact.createElement(FitChildren.FitScrollingFrame, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		Selectable = false,
		Position = propsPosition,
		Size = propsSize,
		CanvasSize = UDim2.new(1, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		fitFields = {
			CanvasSize = FitChildren.FitAxis.Height
		}
	}, { Roact.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = if not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled() then UDim2.fromScale(0.5, 0) else UDim2.new(0.5, 0, 0, v13),
		AnchorPoint = Vector2.new(0.5, 0)
	}, {
		UISizeConstraint = Roact.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(maxWidth, 1e999)
		}),
		Roact.createFragment(p1.props[Roact.Children])
	}) })
end

if FFlagAppIaScrollAway and AppNavBar.getScrollAwayEnabled() then
	v8 = RoactRodux.connect(function(p2, _) -- line: 58
		return {
			topBarHeight = p2.TopBar.topBarHeight
		}
	end)(v8)
end

return v8
