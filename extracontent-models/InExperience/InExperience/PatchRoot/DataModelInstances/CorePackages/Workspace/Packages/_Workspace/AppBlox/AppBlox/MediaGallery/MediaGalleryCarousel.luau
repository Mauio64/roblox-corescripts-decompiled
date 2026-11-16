local parent = script:FindFirstAncestor("AppBlox").Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)

local UIBlox = require(parent.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

require(script.Parent.MediaGalleryTypes)

local udim = UDim2.fromScale(0.4, 0.512)
local udim2 = UDim2.fromScale(0.25, 0.33)

local v = {
	numItemsShown = 3.5,
	itemAspectRatio = 16 / 9,
	itemPadding = 16,
	borderRadius = UDim.new(0, 8)
}

local function MediaGalleryCarousel(p)
	local joined = Cryo.Dictionary.join(v, p)
	local state, setState = React.useState(Vector2.zero)

	local v2 = React.useCallback(function(p2)
		local v2 = joined.itemPadding * (joined.numItemsShown - 1)

		local v3 = (p2.AbsoluteSize.X - v2) / joined.numItemsShown

		setState(Vector2.new(v3, v3 / joined.itemAspectRatio))
	end, { joined.itemAspectRatio, joined.numItemsShown })

	local v3 = React.useCallback(function(p2)
		if joined.onVideoPlayActivated and joined.items[p2].isYouTubeVideo then
			return joined.onVideoPlayActivated(p2)
		end

		if joined.onPreviewActivated then
			return joined.onPreviewActivated(p2)
		end
	end, { joined.items, joined.onVideoPlayActivated, joined.onPreviewActivated })

	local children = {}

	for k, item in joined.items do
		local v4 = "Item" .. k
		local createElement = React.createElement
		local v5 = {
			LayoutOrder = k,
			Size = UDim2.fromOffset(state.X, state.Y),
			Image = item.imageId,
			ScaleType = Enum.ScaleType.Crop,
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			[React.Event.Activated] = function()
				v3(k)
			end
		}
		local v6 = {
			Corner = React.createElement("UICorner", { CornerRadius = joined.borderRadius }),
			PlayButton = 0,
			PlayIcon = 0
		}
		local playButton

		if item.isYouTubeVideo then
			playButton = React.createElement(Button, {
				buttonType = ButtonType.PrimaryContextual,
				size = udim,
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5),
				onActivated = function()
					v3(k)
				end
			})
		end

		v6.PlayButton = playButton
		local playIcon

		if item.isYouTubeVideo then
			playIcon = React.createElement(ImageSetLabel, {
				Size = udim2,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = Images["icons/common/play"],
				BackgroundTransparency = 1,
				ZIndex = 2
			})
		end

		v6.PlayIcon = playIcon
		children[v4] = createElement("ImageButton", v5, v6)
	end

	return React.createElement("ScrollingFrame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		ScrollBarImageTransparency = 1,
		ScrollingDirection = Enum.ScrollingDirection.X,
		ClipsDescendants = false,
		[React.Change.AbsoluteSize] = v2
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, joined.itemPadding)
		}),
		Items = React.createElement(React.Fragment, {}, children)
	})
end

return MediaGalleryCarousel
