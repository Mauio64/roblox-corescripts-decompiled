local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/MediaGalleryTypes")

local udim = UDim2.fromScale(0.4, 0.512)
local udim2 = UDim2.fromScale(0.25, 0.33)

local v5 = {
	numItemsShown = 3.5,
	itemAspectRatio = 16 / 9,
	itemPadding = 16,
	borderRadius = UDim.new(0, 8)
}

local function MediaGalleryCarousel(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local state, setState = React.useState(Vector2.zero)

	local v6 = React.useCallback(function(p3)
		local v7 = joined.itemPadding * (joined.numItemsShown - 1)

		local v8 = (p3.AbsoluteSize.X - v7) / joined.numItemsShown

		setState(Vector2.new(v8, v8 / joined.itemAspectRatio))
	end, { joined.itemAspectRatio, joined.numItemsShown })

	local v7 = React.useCallback(function(p3)
		if joined.onVideoPlayActivated and joined.items[p3].isYouTubeVideo then
			return joined.onVideoPlayActivated(p3)
		end

		if joined.onPreviewActivated then
			return joined.onPreviewActivated(p3)
		end
	end, { joined.items, joined.onVideoPlayActivated, joined.onPreviewActivated })

	local children = {}

	for k, item in joined.items do
		local v8 = "Item" .. k
		local createElement = React.createElement
		local v10 = {
			LayoutOrder = k,
			Size = UDim2.fromOffset(state.X, state.Y),
			Image = item.imageId,
			ScaleType = Enum.ScaleType.Crop,
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			[React.Event.Activated] = function()
				v7(k)
			end
		}
		local v11 = {
			Corner = React.createElement("UICorner", {
				CornerRadius = joined.borderRadius
			}),
			PlayButton = 0,
			PlayIcon = 0
		}
		local v12

		if item.isYouTubeVideo then
			v12 = React.createElement(button, {
				buttonType = buttonType.PrimaryContextual,
				size = udim,
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5),
				onActivated = function()
					v7(k)
				end
			})
		end

		v11.PlayButton = v12

		local v13 = if item.isYouTubeVideo then React.createElement(imageSetLabel, {
			Size = udim2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = images["icons/common/play"],
			BackgroundTransparency = 1,
			ZIndex = 2
		}) else nil
		v11.PlayIcon = v13
		children[v8] = createElement("ImageButton", v10, v11)
	end

	return React.createElement("ScrollingFrame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		ScrollBarImageTransparency = 1,
		ScrollingDirection = Enum.ScrollingDirection.X,
		ClipsDescendants = false,
		[React.Change.AbsoluteSize] = v6
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
