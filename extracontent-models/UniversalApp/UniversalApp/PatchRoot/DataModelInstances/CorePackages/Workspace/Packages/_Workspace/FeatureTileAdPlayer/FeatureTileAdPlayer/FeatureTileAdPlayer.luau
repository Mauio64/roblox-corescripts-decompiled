local Parent = script:FindFirstAncestor("FeatureTileAdPlayer").Parent
local React = require(Parent.React)
local FullscreenPageWithSafeArea = require(Parent.AppBlox).FullscreenPageWithSafeArea

local function FeatureTileAdPlayer(_: {[any]: any}) -- line: 7
	-- upvalues: React (copy), FullscreenPageWithSafeArea (copy)
	error("not implemented")

	return React.createElement(FullscreenPageWithSafeArea, {
		BackgroundTransparency = 1,
		includeStatusBar = true
	})
end

return FeatureTileAdPlayer
