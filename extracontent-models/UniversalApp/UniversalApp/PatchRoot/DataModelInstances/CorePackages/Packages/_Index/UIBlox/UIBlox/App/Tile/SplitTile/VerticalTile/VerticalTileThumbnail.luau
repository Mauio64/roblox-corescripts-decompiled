local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent.Parent

local React = require(parent2.React)

local LoadableImage = require(parent.Loading.LoadableImage)
require(parent.Style.StyleTypes)

local udim = UDim.new(0, 8)

local function VerticalTileThumbnail(props)
	local aspectRatio = props.aspectRatio
	local isTopRounded = props.isTopRounded
	local isBottomRounded = props.isBottomRounded
	local thumbnail = props.thumbnail
	local border = props.border

	local v = isTopRounded and isBottomRounded
	local v2 = not v and (isTopRounded or isBottomRounded)
	local cornerRadius

	if border == nil then
		cornerRadius = udim
	else
		cornerRadius = border.CornerRadius
	end

	local createElement = React.createElement
	local size

	if aspectRatio then
		size = UDim2.new(1, 0, aspectRatio, 0)
	else
		size = UDim2.new(1, 0, 1, 0)
	end

	local sizeConstraint

	if aspectRatio then
		sizeConstraint = Enum.SizeConstraint.RelativeXX
	end

	local createElement2 = React.createElement
	local v3 = {
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, v2 and 0.5 or 1),
		ClipsDescendants = true,
		BackgroundTransparency = 1
	}

	local createElement3 = React.createElement
	local v4 = {
		BackgroundTransparency = 1,
		Image = thumbnail,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, v2 and 2 or 1),
		cornerRadius = 0,
		showFailedStateWhenLoadingFailed = true,
		useShimmerAnimationWhileLoading = true
	}
	local cornerRadius2

	if v or isTopRounded then
		cornerRadius2 = cornerRadius
	end

	v4.cornerRadius = cornerRadius2
	local v5 = {
		TopFrame = createElement2("Frame", v3, {
			TopImage = createElement3(LoadableImage, v4)
		}),
		BottomFrame = 0
	}
	local bottomFrame

	if v2 then
		local createElement4 = React.createElement
		local v6 = {
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.fromScale(1, 0.5),
			ClipsDescendants = true,
			BackgroundTransparency = 1
		}

		local createElement5 = React.createElement
		local v7 = {
			BackgroundTransparency = 1,
			Image = thumbnail,
			Position = UDim2.fromScale(0, -1),
			Size = UDim2.fromScale(1, 2),
			cornerRadius = 0,
			showFailedStateWhenLoadingFailed = true,
			useShimmerAnimationWhileLoading = true
		}

		if not (v or isBottomRounded) then
			cornerRadius = nil
		end

		v7.cornerRadius = cornerRadius
		bottomFrame = createElement4("Frame", v6, {
			BottomImage = createElement5(LoadableImage, v7)
		})
	end

	v5.BottomFrame = bottomFrame
	return createElement("Frame", {
		Size = size,
		SizeConstraint = sizeConstraint,
		BackgroundTransparency = 1
	}, v5)
end

return VerticalTileThumbnail
