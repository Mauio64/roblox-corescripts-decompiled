local Colors = require(script.Parent.Colors)
local Constants = require(script.Parent.Parent.TopBar.Constants)
local t1 = {
	ContainerBackgroundTransparency = 0,
	UseContainerAspectRatio = false,
	ContainerAspectRatio = nil,
	MaxAssetCardsPerRow = 3,
	AvatarHeadShotSize = 48,
	TopSizeY = 90,
	ClipsDescendants = false,
	AssetCardMaxSizeX = 108,
	AssetCardMaxSizeY = 157,
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
	PlayerViewportSize = UDim2.new(1, 0, 0.41, 0),
	AssetListSize = UDim2.new(1, 0, 0.59, -42),
	AssetListPosition = UDim2.new(0, 0, 0.41, 42),
	CloseButtonPosition = UDim2.new(0, 6, 0, -20),
	DetailsThumbnailFrameSize = UDim2.new(1, 0, 0.4, 0),
	DetailsThumbnailFramePosition = UDim2.new(0, 0, 0, 15),
	DetailsThumbnailAnchorPoint = Vector2.new(0.5, 0.5),
	DetailsThumbnailPosition = UDim2.new(0.5, 0, 0.5, 0),
	DetailsThumbnailARDominantAxis = Enum.DominantAxis.Height,
	DetailsFramePosition = UDim2.new(0, 15, 0.4, 15),
	DetailsFrameSize = UDim2.new(1, -30, 0.6, -30),
	DefaultCameraOffset = CFrame.new(0, 2, -5),
	ToolOffset = CFrame.new(0, 2, -8),
	TryOnPosition = UDim2.new(0, 0, 0, 15),
	TryOnSize = UDim2.new(1, 0, 0.4, 0)
}

setmetatable(t1, {
	__newindex = function(_, _, _) -- line: 44
	end,
	__index = function(_, p5) -- line: 45
		error("CompactView table has no value: " .. tostring(p5))
	end
})

return t1
