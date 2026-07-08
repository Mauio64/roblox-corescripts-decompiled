local ParentParent = script.Parent.Parent
local context = ParentParent.context
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local useStyle = UIBlox.Core.Style.useStyle
local LoadableImage = UIBlox.App.Loading.LoadableImage
local type = require(ParentParent.type)
local getRbxthumbWithTypeSizeAndOptions = dependencies.getRbxthumbWithTypeSizeAndOptions
local UserLibConstants = dependencies.UserLibConstants
local constants = require(ParentParent.constants)
local v12 = game:DefineFastFlag("EnableStreamAvatarImageUrlThumbnail", false)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v15 = Images["icons/logo/block"]
local v16 = Images["icons/common/safety"]
local useNotificationCardState = require(context.useNotificationCardState)

local function v18(p1) -- line: 21
	-- upvalues: type (copy), UserLibConstants (copy), v12 (copy)
	if p1 == type.SENDERThumbnailTypeEnum.Game then
		return UserLibConstants.RbxthumbTypes.GameIcon
	end

	if p1 == type.SENDERThumbnailTypeEnum.User then
		return UserLibConstants.RbxthumbTypes.AvatarHeadShot
	end

	if p1 == type.SENDERThumbnailTypeEnum.Group then
		return UserLibConstants.RbxthumbTypes.GroupIcon
	end

	if p1 == type.SENDERThumbnailTypeEnum.Asset then
		return UserLibConstants.RbxthumbTypes.Asset
	end

	if p1 == type.SENDERThumbnailTypeEnum.Bundle then
		return UserLibConstants.RbxthumbTypes.BundleThumbnail
	end

	if p1 == type.SENDERThumbnailTypeEnum.GamePass then
		return UserLibConstants.RbxthumbTypes.GamePass
	end

	if v12 and p1 == type.SENDERThumbnailTypeEnum.AvatarImageUrl then
		return UserLibConstants.RbxthumbTypes.AvatarImageUrl
	end

	return UserLibConstants.RbxthumbTypes.GameIcon
end

return function() -- line: 52
	-- upvalues: useNotificationCardState (copy), v12 (copy), type (copy), useStyle (copy), constants (copy), React (copy), ImageSetLabel (copy), v16 (copy), v15 (copy), v18 (copy), UserLibConstants (copy), getRbxthumbWithTypeSizeAndOptions (copy), LoadableImage (copy)
	local v21 = useNotificationCardState("thumbnail")

	if v21 == nil or #v21 == 0 then
		return nil
	end

	local v22 = v21[1]

	if v22 == nil then
		return nil
	end

	if not v12 and v22.idType == type.SENDERThumbnailTypeEnum.AvatarImageUrl then
		return nil
	end

	local v23 = useStyle()

	if v22.idType == type.SENDERThumbnailTypeEnum.Icon then
		if v22.id == constants.SafetyThumbnailId then
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				SizeConstraint = Enum.SizeConstraint.RelativeXX
			}, {
				Icon = React.createElement(ImageSetLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Image = v16,
					ImageColor3 = v23.Theme.IconDefault.Color
				})
			})
		end

		return React.createElement("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			BackgroundColor3 = v23.Tokens.Color.System.Emphasis.Color3
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 11)
			}),
			Icon = React.createElement(ImageSetLabel, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0.75, 0.75),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = v15,
				ImageColor3 = v23.Tokens.Color.Extended.White.White_100.Color3
			})
		})
	end

	local v24 = if not v12 or v18(v22.idType) ~= UserLibConstants.RbxthumbTypes.AvatarImageUrl then getRbxthumbWithTypeSizeAndOptions(v22.id, v18(v22.idType), 150) else v22.id

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		SizeConstraint = Enum.SizeConstraint.RelativeXX
	}, {
		Thumbnail = React.createElement(LoadableImage, {
			BackgroundTransparency = 0,
			showFailedStateWhenLoadingFailed = true,
			useShimmerAnimationWhileLoading = true,
			ZIndex = 1,
			BackgroundColor3 = v23.Theme.BackgroundDefault.Color,
			Image = v24,
			Size = UDim2.fromScale(1, 1),
			cornerRadius = if not (v22.idType == type.SENDERThumbnailTypeEnum.User or v12 and v22.idType == type.SENDERThumbnailTypeEnum.AvatarImageUrl) then UDim.new(0, 8) else UDim.new(0.5, 0)
		})
	})
end
