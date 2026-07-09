local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useAdaptiveScrolling = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Hooks.useAdaptiveScrolling
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AXRefreshScrollingFrameWithLoadMore = require(Modules.AvatarExperience.Common.Components.AXRefreshScrollingFrameWithLoadMore)

local function EditEmotesScrollingContent(t1: {[any]: any}) -- line: 20
	-- upvalues: useAdaptiveScrolling (copy), React (copy), AXRefreshScrollingFrameWithLoadMore (copy), AvatarScreen (copy)
	local v9 = useAdaptiveScrolling()
	local v10 = React.useCallback(function(p1) -- line: 23
		-- upvalues: t1 (copy), v9 (copy)
		if t1.onCanvasPositionChanged then
			t1.onCanvasPositionChanged(p1)
		end

		if v9 and v9.onCanvasYChanged and p1 then
			v9.onCanvasYChanged(p1.CanvasPosition.Y)
		end
	end, {
		v9,
		t1.onCanvasPositionChanged
	})

	return React.createElement(AXRefreshScrollingFrameWithLoadMore, {
		createEndOfScrollElement = true,
		preventInitialLoadMore = true,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0, 0),
		parentAppPage = AvatarScreen.EditEmotes,
		ScrollingEnabled = not v9 or v9.scrollingEnabledBinding,
		onCanvasPositionChanged = v10,
		onThresholdReached = t1.onThresholdReached
	}, t1.children)
end

return EditEmotesScrollingContent
