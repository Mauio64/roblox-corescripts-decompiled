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
local FFlagNotificationThumbnailUseProfileFrameThumbnail = require(ParentParent.Flags.FFlagNotificationThumbnailUseProfileFrameThumbnail)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v16 = Images["icons/logo/block"]
local v17 = Images["icons/common/safety"]
local useNotificationCardState = require(context.useNotificationCardState)

local function v19(p1) -- line: 24
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

return function() -- line: 55
	-- upvalues: useNotificationCardState (copy), v12 (copy), type (copy), useStyle (copy), constants (copy), React (copy), ImageSetLabel (copy), v17 (copy), v16 (copy), v19 (copy), UserLibConstants (copy), FFlagNotificationThumbnailUseProfileFrameThumbnail (copy), getRbxthumbWithTypeSizeAndOptions (copy), LoadableImage (copy)
	local v22 = useNotificationCardState("thumbnail")

	if v22 == nil or #v22 == 0 then
		return nil
	end

	local v23 = v22[1]

	if v23 == nil then
		return nil
	end

	if not v12 and v23.idType == type.SENDERThumbnailTypeEnum.AvatarImageUrl then
		return nil
	end

	local v24 = useStyle()

	if v23.idType == type.SENDERThumbnailTypeEnum.Icon then
		if v23.id == constants.SafetyThumbnailId then
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
					Image = v17,
					ImageColor3 = v24.Theme.IconDefault.Color
				})
			})
		end

		return React.createElement("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			BackgroundColor3 = v24.Tokens.Color.System.Emphasis.Color3
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
				Image = v16,
				ImageColor3 = v24.Tokens.Color.Extended.White.White_100.Color3
			})
		})
	end

	local v25 = if not v12 or v19(v23.idType) ~= UserLibConstants.RbxthumbTypes.AvatarImageUrl then if not FFlagNotificationThumbnailUseProfileFrameThumbnail then getRbxthumbWithTypeSizeAndOptions(v23.id, v19(v23.idType), 150) else getRbxthumbWithTypeSizeAndOptions(v23.id, v19(v23.idType), 150, nil, nil, v23.idType == type.SENDERThumbnailTypeEnum.User or v12 and v23.idType == type.SENDERThumbnailTypeEnum.AvatarImageUrl) else v23.id

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
			BackgroundColor3 = v24.Theme.BackgroundDefault.Color,
			Image = v25,
			Size = UDim2.fromScale(1, 1),
			cornerRadius = if not (v23.idType == type.SENDERThumbnailTypeEnum.User or v12 and v23.idType == type.SENDERThumbnailTypeEnum.AvatarImageUrl) then UDim.new(0, 8) else UDim.new(0.5, 0)
		})
	})
end
