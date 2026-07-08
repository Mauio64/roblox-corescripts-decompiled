local Colors = require(script.Parent.Colors)
local Constants = require(script.Parent.Parent.TopBar.Constants)
local t1 = {
	ContainerBackgroundTransparency = 0,
	UseContainerAspectRatio = false,
	ContainerAspectRatio = nil,
	MaxAssetCardsPerRow = 4,
	AvatarHeadShotSize = 48,
	TopSizeY = 50,
	AssetCardMaxSizeX = 190,
	AssetCardMaxSizeY = 279,
	BorderPaddingSize = 20,
	AssetTextMaxSize = 14,
	ContainerBackgroundColor = Colors.Carbon,
	ContainerSize = function(n1: number) -- line: 10
		-- upvalues: Constants (copy)
		return UDim2.new(1, 0, 1, -Constants.TopBarHeight * n1)
	end,
	ContainerAnchorPoint = Vector2.new(0.5, 0),
	ContainerPosition = function(n2: number) -- line: 15
		-- upvalues: Constants (copy)
		return UDim2.new(0.5, 0, 0, Constants.TopBarHeight * n2)
	end,
	PlayerViewportSize = UDim2.new(0.33, 0, 1, -42),
	AssetListSize = UDim2.new(0.67, 0, 1, -42),
	AssetListPosition = UDim2.new(0.33, 0, 0, 42),
	CloseButtonPosition = UDim2.new(0, 6, 0, -20),
	DetailsThumbnailFrameSize = UDim2.new(0.4, 0, 1, -30),
	DetailsThumbnailFramePosition = UDim2.new(0, 25, 0, 30),
	DetailsThumbnailAnchorPoint = Vector2.new(0.5, 0),
	DetailsThumbnailPosition = UDim2.new(0.5, 0, 0, 0),
	DetailsThumbnailARDominantAxis = Enum.DominantAxis.Width,
	DetailsFramePosition = UDim2.new(0.4, 30, 0, 30),
	DetailsFrameSize = UDim2.new(0.6, -30, 1, -30),
	DefaultCameraOffset = CFrame.new(0, 2, -5),
	ToolOffset = CFrame.new(0, 2, -8),
	TryOnPosition = UDim2.new(0, 25, 0, 30),
	TryOnSize = UDim2.new(0.4, 0, 1, -30)
}

setmetatable(t1, {
	__newindex = function(_, _, _) -- line: 43
	end,
	__index = function(_, p5) -- line: 44
		error("WideLandscapeView table has no value: " .. tostring(p5))
	end
})

return t1
