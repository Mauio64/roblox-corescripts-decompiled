local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gQK")
local useAXAnimateScrollFrame = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.AnimatedScrollingFrame.useAXAnimateScrollFrame

local module2 = require("@luauforge/deferred/gPP")

local fFlagAXItemDetailsSdui = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXItemDetailsSdui

local function fn(): nil
	return nil
end

return function(props)
	local renderContent = props.renderContent
	local renderTopBar = props.renderTopBar or fn
	local renderBottomBar = props.renderBottomBar or fn
	local topBarHeight = props.topBarHeight or 0
	local bottomBarHeight = props.bottomBarHeight or 0
	local v5 = React.useRef(nil)

	local v7 = if fFlagAXItemDetailsSdui then props.scrollingFrameRef or v5 else v5
	useAXAnimateScrollFrame(v7)

	local createElement = Roact.createElement
	local v10 = { TopBar = renderTopBar(), ScrollingContent = 0, BottomBar = 0 }
	local createElement2 = Roact.createElement
	v5 = fFlagAXItemDetailsSdui and props.scrollingFrameRef or v5
	local v12 = {
		ref = v5,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -(topBarHeight + bottomBarHeight)),
		Position = UDim2.new(0, 0, 0, topBarHeight),
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(1, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingEnabled = 0,
		Selectable = false
	}
	local v13 = if module2() then props.scrollingEnabled else nil
	v12.ScrollingEnabled = v13
	v10.ScrollingContent = createElement2("ScrollingFrame", v12, {
		Content = renderContent(props.bottomPadding)
	})

	v10.BottomBar = renderBottomBar()
	return createElement(module, {}, v10)
end
