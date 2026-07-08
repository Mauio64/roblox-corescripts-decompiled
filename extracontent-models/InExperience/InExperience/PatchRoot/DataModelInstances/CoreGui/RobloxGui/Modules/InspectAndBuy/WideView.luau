local Colors = require(script.Parent.Colors)
local Constants = require(script.Parent.Parent.TopBar.Constants)
local t1 = {
	UseContainerAspectRatio = false,
	ContainerBackgroundTransparency = 0.3,
	ContainerAspectRatio = 0.9,
	MaxAssetCardsPerRow = 4,
	AvatarHeadShotSize = 48,
	TopSizeY = 50,
	ClipsDescendants = true,
	AssetCardMaxSizeX = 190,
	AssetCardMaxSizeY = 279,
	BorderPaddingSize = 40,
	AssetTextMaxSize = 18,
	ContainerBackgroundColor = Colors.Black,
	ContainerSize = function(n1: number) -- line: 10
		-- upvalues: Constants (copy)
		return UDim2.new(0.7, 0, 0.95, -Constants.TopBarHeight * n1)
	end,
	ContainerAnchorPoint = Vector2.new(0.5, 0.5),
	ContainerPosition = function(n2: number) -- line: 15
		-- upvalues: Constants (copy)
		return UDim2.new(0.5, 0, 0.5, Constants.TopBarHeight * n2)
	end,
	PlayerViewportSize = UDim2.new(0.33, 0, 1, -42),
	AssetListSize = UDim2.new(0.67, 0, 1, -42),
	AssetListPosition = UDim2.new(0.33, 0, 0, 42),
	CloseButtonPosition = UDim2.new(0, 6, 0, -30),
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
	__newindex = function(_, _, _) -- line: 44
	end,
	__index = function(_, p5) -- line: 45
		error("WideView table has no value: " .. tostring(p5))
	end
})

return t1
