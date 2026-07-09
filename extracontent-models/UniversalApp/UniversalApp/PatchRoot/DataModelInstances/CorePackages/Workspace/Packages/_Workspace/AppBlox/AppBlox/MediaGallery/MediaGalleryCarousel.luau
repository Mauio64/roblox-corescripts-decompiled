local Parent = script:FindFirstAncestor("AppBlox").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

require(script.Parent.MediaGalleryTypes)

local uDim2 = UDim2.fromScale(0.4, 0.512)
local uDim2_2 = UDim2.fromScale(0.25, 0.33)
local t1 = {
	numItemsShown = 3.5,
	itemAspectRatio = 1.7777777777777777,
	itemPadding = 16,
	borderRadius = UDim.new(0, 8)
}

local function MediaGalleryCarousel(t2: {[any]: any}) -- line: 40
	-- upvalues: Cryo (copy), t1 (copy), React (copy), Button (copy), ButtonType (copy), uDim2 (copy), ImageSetLabel (copy), uDim2_2 (copy), Images (copy)
	local v14 = Cryo.Dictionary.join(t1, t2)
	local v15, v16 = React.useState(Vector2.zero)
	local v17 = React.useCallback(function(p1) -- line: 44
		-- upvalues: v14 (copy), v16 (copy)
		local v23 = v14.itemPadding * (v14.numItemsShown - 1)
		local v24 = (p1.AbsoluteSize.X - v23) / v14.numItemsShown

		v16(Vector2.new(v24, v24 / v14.itemAspectRatio))
	end, {
		v14.itemAspectRatio,
		v14.numItemsShown
	})
	local v18 = React.useCallback(function(p2) -- line: 55
		-- upvalues: v14 (copy)
		if v14.onVideoPlayActivated and v14.items[p2].isYouTubeVideo then
			return v14.onVideoPlayActivated(p2)
		end

		if v14.onPreviewActivated then
			return v14.onPreviewActivated(p2)
		end
	end, {
		v14.items,
		v14.onVideoPlayActivated,
		v14.onPreviewActivated
	})
	local t3 = {}

	for v20, v21 in v14.items do
		t3["Item" .. v20] = React.createElement("ImageButton", {
			LayoutOrder = v20,
			Size = UDim2.fromOffset(v15.X, v15.Y),
			Image = v21.imageId,
			ScaleType = Enum.ScaleType.Crop,
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			[React.Event.Activated] = function() -- line: 82
				-- upvalues: v18 (copy), v20 (copy)
				v18(v20)
			end
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = v14.borderRadius
			}),
			PlayButton = if not v21.isYouTubeVideo then nil else React.createElement(Button, {
				buttonType = ButtonType.PrimaryContextual,
				size = uDim2,
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5),
				onActivated = function() -- line: 95
					-- upvalues: v18 (copy), v20 (copy)
					v18(v20)
				end
			}),
			PlayIcon = if not v21.isYouTubeVideo then nil else React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = uDim2_2,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = Images["icons/common/play"]
			})
		})
	end

	return React.createElement("ScrollingFrame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		ScrollBarImageTransparency = 1,
		ScrollingDirection = Enum.ScrollingDirection.X,
		ClipsDescendants = false,
		[React.Change.AbsoluteSize] = v17
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v14.itemPadding)
		}),
		Items = React.createElement(React.Fragment, {}, t3)
	})
end

return MediaGalleryCarousel
