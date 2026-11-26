local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local module = require("@luauforge/bundled/dKz")
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")

local fFlagAppIaScrollAway = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAppIaScrollAway

local extended = Roact.PureComponent:extend("MorePageScrollingFrame")

extended.defaultProps = { maxWidth = 1e999 }

function extended.render(p2)
	local position = p2.props.Position
	local size = p2.props.Size
	local maxWidth = p2.props.maxWidth
	local topBarHeight = if fFlagAppIaScrollAway then p2.props.topBarHeight else nil

	local createElement = Roact.createElement
	local fitScrollingFrame = FitChildren.FitScrollingFrame
	local v5 = {
		Position = position,
		Size = size,
		CanvasSize = UDim2.new(1, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		Selectable = false,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		fitFields = { CanvasSize = FitChildren.FitAxis.Height }
	}

	local createElement2 = Roact.createElement
	local v8 = {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = 0,
		AnchorPoint = 0,
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}
	local v9 = if fFlagAppIaScrollAway and module.getScrollAwayEnabled() then UDim2.new(0.5, 0, 0, topBarHeight) else UDim2.fromScale(0.5, 0)
	v8.Position = v9

	v8.AnchorPoint = Vector2.new(0.5, 0)
	return createElement(fitScrollingFrame, v5, { createElement2("Frame", v8, {
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(maxWidth, 1e999)
			}),
			Roact.createFragment(p2.props[Roact.Children])
		}) })
end

if fFlagAppIaScrollAway and module.getScrollAwayEnabled() then
	extended = RoactRodux.connect(function(p2, p3)
		return { topBarHeight = p2.TopBar.topBarHeight }
	end)(extended)
end

return extended
