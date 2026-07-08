local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local useTokens = require(ServerDrivenUiParent.Foundation).Hooks.useTokens
local Cryo = require(ServerDrivenUiParent.Cryo)
local LoadableImage = require(ServerDrivenUiParent.UIBlox).App.Loading.LoadableImage
local SduiTile = require(ServerDrivenUi.Content.SduiTile)
local FFlagSduiTileImagePaddingInset = require(ServerDrivenUiParent.SharedFlags).FFlagSduiTileImagePaddingInset

local function SduiBadgeTile(p1) -- line: 20
	-- upvalues: useTokens (copy), FFlagSduiTileImagePaddingInset (copy), Cryo (copy), React (copy), LoadableImage (copy), SduiTile (copy)
	local v11 = useTokens()
	local v12 = p1.cornerRadius or v11.Radius.Medium
	local v13 = p1.imageCornerRadius or 1000
	local v14 = p1.imagePadding or v11.Padding.Medium
	local v15 = p1.isContained == nil or p1.isContained
	local v16

	if FFlagSduiTileImagePaddingInset then
		v16 = Cryo.Dictionary.join(p1, {
			testId = "--sdui-badge-tile",
			imagePadding = v14,
			imageCornerRadius = v13,
			isContained = v15
		})
	else
		local v17 = not v15 and 0 or v12
		local v18 = React.createElement("Frame", {
			BorderSizePixel = 0,
			ClipsDescendants = true,
			ZIndex = -3,
			Size = UDim2.new(1, 0, 1, v17),
			BackgroundColor3 = p1.thumbnailBackgroundStyle and p1.thumbnailBackgroundStyle.Color3 or nil,
			BackgroundTransparency = p1.thumbnailBackgroundStyle and p1.thumbnailBackgroundStyle.Transparency or 1
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v12)
			}),
			ThumbnailFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -2 * v14, 1, -2 * v14 - v17),
				Position = if not v14 then nil else UDim2.fromOffset(v14, v14)
			}, {
				Thumbnail = if not p1.imageComponent then if not p1.image then nil else React.createElement(LoadableImage, {
					BackgroundTransparency = 1,
					showFailedStateWhenLoadingFailed = true,
					useShimmerAnimationWhileLoading = true,
					Image = p1.image,
					Size = UDim2.new(1, 0, 1, 0),
					cornerRadius = UDim.new(0, v13)
				}) else p1.imageComponent
			})
		})

		v16 = Cryo.Dictionary.join(p1, {
			testId = "--sdui-badge-tile",
			imageComponent = v18,
			isContained = v15
		})
	end

	return React.createElement(SduiTile, v16)
end

return React.memo(SduiBadgeTile)
