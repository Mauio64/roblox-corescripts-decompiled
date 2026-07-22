local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)
local React = require(MomentsParent.React)
local View = Foundation.View
local Constants = require(Moments.Constants)
local useChromeRatio = require(Moments.Hooks.useChromeRatio)
local FFlagMomentsUseCompositionLibrary = require(Moments.Flags.FFlagMomentsUseCompositionLibrary)

local function ImmersiveHeaderChrome(t1: {[any]: any}) -- line: 21
	-- upvalues: useChromeRatio (copy), React (copy), Constants (copy), FFlagMomentsUseCompositionLibrary (copy), View (copy)
	local v11 = useChromeRatio()
	local v12, v13 = React.useBinding(0)
	local v14 = React.useCallback(function(p1) -- line: 24
		-- upvalues: v13 (copy)
		v13(p1.AbsoluteSize.Y)
	end, {})
	local v15 = React.joinBindings({
		ratio = v11,
		height = v12
	}):map(function(t2: {[any]: any}) -- line: 31
		return UDim2.new(0, 0, 0, (t2.ratio - 1) * t2.height)
	end)
	local t3 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = v15,
		Interactable = v11:map(function(n1: number) -- line: 42
			return n1 > 0.01
		end),
		ZIndex = Constants.DisplayOrder.FeedTopBar,
		[React.Change.AbsoluteSize] = v14,
		[React.Tag] = "data-testid=--moments-immersive-header-chrome"
	}
	local s1 = "Frame"

	if not FFlagMomentsUseCompositionLibrary then
		s1 = "CanvasGroup"
		t3.GroupTransparency = v11:map(function(n2: number) -- line: 55
			return 1 - n2
		end)
	end

	return React.createElement(s1, t3, {
		Header = React.createElement(View, {
			tag = "size-full-0 auto-y"
		}, t1.children)
	})
end

return ImmersiveHeaderChrome
