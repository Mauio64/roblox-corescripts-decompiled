local parent = script.Parent.Parent
local context = parent.context
local dependencies = require(parent.dependencies)
local react = dependencies.React
local uiBlox = dependencies.UIBlox
local useStyle = uiBlox.Core.Style.useStyle
local loadableImage = uiBlox.App.Loading.LoadableImage
local kind = require(parent.type)
local getRbxthumbWithTypeSizeAndOptions = dependencies.getRbxthumbWithTypeSizeAndOptions
local userLibConstants = dependencies.UserLibConstants
local constants = require(parent.constants)
local defineFastFlag = game:DefineFastFlag("EnableStreamAvatarImageUrlThumbnail", false)

local FFlagNotificationThumbnailUseProfileFrameThumbnail = require(parent.Flags.FFlagNotificationThumbnailUseProfileFrameThumbnail)

local images = uiBlox.App.ImageSet.Images
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local iconslogoblock = images["icons/logo/block"]
local iconscommonsafety = images["icons/common/safety"]

local useNotificationCardState = require(context.useNotificationCardState)

local function fn(idType)
	if idType == kind.SENDERThumbnailTypeEnum.Game then
		return userLibConstants.RbxthumbTypes.GameIcon
	end

	if idType == kind.SENDERThumbnailTypeEnum.User then
		return userLibConstants.RbxthumbTypes.AvatarHeadShot
	end

	if idType == kind.SENDERThumbnailTypeEnum.Group then
		return userLibConstants.RbxthumbTypes.GroupIcon
	end

	if idType == kind.SENDERThumbnailTypeEnum.Asset then
		return userLibConstants.RbxthumbTypes.Asset
	end

	if idType == kind.SENDERThumbnailTypeEnum.Bundle then
		return userLibConstants.RbxthumbTypes.BundleThumbnail
	end

	if idType == kind.SENDERThumbnailTypeEnum.GamePass then
		return userLibConstants.RbxthumbTypes.GamePass
	end

	if defineFastFlag and idType == kind.SENDERThumbnailTypeEnum.AvatarImageUrl then
		return userLibConstants.RbxthumbTypes.AvatarImageUrl
	end

	return userLibConstants.RbxthumbTypes.GameIcon
end

local function fn2(p) -- 2 equivalent calls inferred from this helper
	return p.idType == kind.SENDERThumbnailTypeEnum.User
		or defineFastFlag and p.idType == kind.SENDERThumbnailTypeEnum.AvatarImageUrl
end

return function()
	local v = useNotificationCardState("thumbnail")

	if v == nil or #v == 0 then
		return nil
	end

	local v2 = v[1]

	if v2 == nil or not defineFastFlag and v2.idType == kind.SENDERThumbnailTypeEnum.AvatarImageUrl then
		return nil
	end

	local v3 = useStyle()

	if v2.idType == kind.SENDERThumbnailTypeEnum.Icon then
		if v2.id == constants.SafetyThumbnailId then
			return react.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					BorderSizePixel = 0
				},
				{
					Icon = react.createElement(imageSetLabel, {
						Size = UDim2.fromScale(1, 1),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						LayoutOrder = 1,
						Image = iconscommonsafety,
						BackgroundTransparency = 1,
						ImageColor3 = v3.Theme.IconDefault.Color
					})
				}
			)
		end

		return react.createElement("Frame", {
			BackgroundTransparency = 0,
			Size = UDim2.fromScale(1, 1),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			BackgroundColor3 = v3.Tokens.Color.System.Emphasis.Color3,
			BorderSizePixel = 0
		}, {
			UICorner = react.createElement("UICorner", { CornerRadius = UDim.new(0, 11) }),
			Icon = react.createElement(imageSetLabel, {
				Size = UDim2.fromScale(0.75, 0.75),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				LayoutOrder = 1,
				Image = iconslogoblock,
				BackgroundTransparency = 1,
				ImageColor3 = v3.Tokens.Color.Extended.White.White_100.Color3
			})
		})
	else
		local image

		if defineFastFlag and fn(v2.idType) == userLibConstants.RbxthumbTypes.AvatarImageUrl then
			image = v2.id
		elseif FFlagNotificationThumbnailUseProfileFrameThumbnail then
			image = getRbxthumbWithTypeSizeAndOptions(v2.id, fn(v2.idType), 150, nil, nil, fn2(v2)) -- inferred equivalent call
		else
			image = getRbxthumbWithTypeSizeAndOptions(v2.id, fn(v2.idType), 150)
		end

		local createElement = react.createElement
		local v4 = {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			BorderSizePixel = 0
		}

		local createElement2 = react.createElement
		local v5 = {
			BackgroundTransparency = 0,
			BackgroundColor3 = v3.Theme.BackgroundDefault.Color,
			Image = image,
			Size = UDim2.fromScale(1, 1),
			cornerRadius = 0,
			showFailedStateWhenLoadingFailed = true,
			useShimmerAnimationWhileLoading = true,
			ZIndex = 1
		}
		local cornerRadius

		if fn2(v2) then -- inferred equivalent call
			cornerRadius = UDim.new(0.5, 0)
		else
			cornerRadius = UDim.new(0, 8)
		end

		v5.cornerRadius = cornerRadius
		return createElement("Frame", v4, {
			Thumbnail = createElement2(loadableImage, v5)
		})
	end
end
