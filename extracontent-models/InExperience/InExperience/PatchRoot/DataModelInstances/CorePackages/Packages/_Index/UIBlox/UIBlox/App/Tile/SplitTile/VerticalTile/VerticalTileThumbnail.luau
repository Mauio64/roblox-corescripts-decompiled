local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent
local React = require(ParentParent2.React)
local LoadableImage = require(ParentParent.Loading.LoadableImage)

require(ParentParent.Style.StyleTypes)

local uDim = UDim.new(0, 8)

local function VerticalTileThumbnail(t1: {[any]: any}) -- line: 27
	-- upvalues: uDim (copy), React (copy), LoadableImage (copy)
	local aspectRatio = t1.aspectRatio
	local isTopRounded = t1.isTopRounded
	local isBottomRounded = t1.isBottomRounded
	local thumbnail = t1.thumbnail
	local border = t1.border
	local v13 = isTopRounded and isBottomRounded
	local v14 = not v13 and (isTopRounded or isBottomRounded)
	local v15 = if border == nil then uDim else border.CornerRadius

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = if not aspectRatio then UDim2.new(1, 0, 1, 0) else UDim2.new(1, 0, aspectRatio, 0),
		SizeConstraint = if not aspectRatio then nil else Enum.SizeConstraint.RelativeXX
	}, {
		TopFrame = React.createElement("Frame", {
			ClipsDescendants = true,
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.fromScale(1, v14 and 0.5 or 1)
		}, {
			TopImage = React.createElement(LoadableImage, {
				BackgroundTransparency = 1,
				showFailedStateWhenLoadingFailed = true,
				useShimmerAnimationWhileLoading = true,
				Image = thumbnail,
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(1, v14 and 2 or 1),
				cornerRadius = if not v13 and not isTopRounded then nil else v15
			})
		}),
		BottomFrame = if not v14 then nil else React.createElement("Frame", {
			ClipsDescendants = true,
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.fromScale(1, 0.5)
		}, {
			BottomImage = React.createElement(LoadableImage, {
				BackgroundTransparency = 1,
				showFailedStateWhenLoadingFailed = true,
				useShimmerAnimationWhileLoading = true,
				Image = thumbnail,
				Position = UDim2.fromScale(0, -1),
				Size = UDim2.fromScale(1, 2),
				cornerRadius = if not v13 and not isBottomRounded then nil else v15
			})
		})
	})
end

return VerticalTileThumbnail
