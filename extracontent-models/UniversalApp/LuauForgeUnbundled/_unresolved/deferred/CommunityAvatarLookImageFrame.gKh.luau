local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local module = require("@luauforge/bundled/ciE")

require("@luauforge/bundled/dPs")

local loadableImage = UIBlox.App.Loading.LoadableImage

local getRbxthumbWithTypeSizeAndOptions = module.Utils.getRbxthumbWithTypeSizeAndOptions

local function CommunityAvatarLookImageFrame(props)
	local lookId = props.lookId
	local size = props.size
	local layoutOrder = props.layoutOrder

	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(lookId, "Look", 420)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, size),
		SizeConstraint = Enum.SizeConstraint.RelativeXY,
		LayoutOrder = layoutOrder,
		ZIndex = 0
	}, {
		CommunityAvatarImage = Roact.createElement(loadableImage, {
			BackgroundTransparency = 1,
			Image = rbxthumbWithTypeSizeAndOptions,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.fromOffset(size, size),
			useShimmerAnimationWhileLoading = true
		})
	})
end

return CommunityAvatarLookImageFrame
