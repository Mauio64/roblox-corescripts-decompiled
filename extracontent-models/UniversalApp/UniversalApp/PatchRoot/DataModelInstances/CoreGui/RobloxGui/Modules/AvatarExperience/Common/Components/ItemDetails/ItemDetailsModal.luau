local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local CenteredModalView = require(Modules.AvatarExperience.Common.Components.CenteredModalView)
local useAXAnimateScrollFrame = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.AnimatedScrollingFrame.useAXAnimateScrollFrame
local GetFFlagAXItemDetailsScrollingEnabledCallback = require(Modules.AvatarExperience.Flags.GetFFlagAXItemDetailsScrollingEnabledCallback)
local v8 = game:DefineFastFlag("AXMIgrateItemDetailsModalToAutofocus", false)

local function v9() -- line: 35
	return nil
end

return function(t1: {[any]: any}) -- line: 39
	-- upvalues: v9 (copy), v8 (copy), React (copy), useAXAnimateScrollFrame (copy), Roact (copy), CenteredModalView (copy), GetFFlagAXItemDetailsScrollingEnabledCallback (copy)
	local renderContent = t1.renderContent
	local v12 = t1.renderTopBar or v9
	local v13 = t1.renderBottomBar or v9
	local v14 = t1.topBarHeight or 0
	local v15 = t1.bottomBarHeight or 0
	local v16 = nil

	if v8 then
		v16 = React.useRef(nil)
		useAXAnimateScrollFrame(v16)
	end

	return Roact.createElement(CenteredModalView, {}, {
		TopBar = v12(),
		ScrollingContent = Roact.createElement("ScrollingFrame", {
			BackgroundTransparency = 1,
			ScrollBarThickness = 0,
			ref = if not v8 then nil else v16,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Size = UDim2.new(1, 0, 1, -(v14 + v15)),
			Position = UDim2.new(0, 0, 0, v14),
			CanvasSize = UDim2.new(1, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollingEnabled = if not GetFFlagAXItemDetailsScrollingEnabledCallback() then nil else t1.scrollingEnabled,
			Selectable = not v8 and nil
		}, {
			Content = renderContent()
		}),
		BottomBar = v13()
	})
end
