local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/dependencies")
local react = dependencies.React
local uiBlox = dependencies.UIBlox
local useStyle = uiBlox.Core.Style.useStyle
local loadableImage = uiBlox.App.Loading.LoadableImage
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/type")
local getRbxthumbWithTypeSizeAndOptions = dependencies.getRbxthumbWithTypeSizeAndOptions
local userLibConstants = dependencies.UserLibConstants
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/constants")
local defineFastFlag = game:DefineFastFlag("EnableStreamAvatarImageUrlThumbnail", false)

local FFlagNotificationThumbnailUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/Flags/FFlagNotificationThumbnailUseProfileFrameThumbnail")

local images = uiBlox.App.ImageSet.Images
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local iconslogoblock = images["icons/logo/block"]
local iconscommonsafety = images["icons/common/safety"]

local useNotificationCardState = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/context/useNotificationCardState")

local function fn(idType)
	if idType == module2.SENDERThumbnailTypeEnum.Game then
		return userLibConstants.RbxthumbTypes.GameIcon
	end

	if idType == module2.SENDERThumbnailTypeEnum.User then
		return userLibConstants.RbxthumbTypes.AvatarHeadShot
	end

	if idType == module2.SENDERThumbnailTypeEnum.Group then
		return userLibConstants.RbxthumbTypes.GroupIcon
	end

	if idType == module2.SENDERThumbnailTypeEnum.Asset then
		return userLibConstants.RbxthumbTypes.Asset
	end

	if idType == module2.SENDERThumbnailTypeEnum.Bundle then
		return userLibConstants.RbxthumbTypes.BundleThumbnail
	end

	if idType == module2.SENDERThumbnailTypeEnum.GamePass then
		return userLibConstants.RbxthumbTypes.GamePass
	end

	if defineFastFlag and idType == module2.SENDERThumbnailTypeEnum.AvatarImageUrl then
		return userLibConstants.RbxthumbTypes.AvatarImageUrl
	end

	return userLibConstants.RbxthumbTypes.GameIcon
end

return function()
	local v5 = useNotificationCardState("thumbnail")

	if v5 == nil or #v5 == 0 then
		return nil
	end

	local v6 = v5[1]

	if v6 == nil or not defineFastFlag and v6.idType == module2.SENDERThumbnailTypeEnum.AvatarImageUrl then
		return nil
	end

	local v7 = useStyle()

	if v6.idType == module2.SENDERThumbnailTypeEnum.Icon then
		if v6.id == constants.SafetyThumbnailId then
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
						ImageColor3 = v7.Theme.IconDefault.Color
					})
				}
			)
		end

		return react.createElement("Frame", {
			BackgroundTransparency = 0,
			Size = UDim2.fromScale(1, 1),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			BackgroundColor3 = v7.Tokens.Color.System.Emphasis.Color3,
			BorderSizePixel = 0
		}, {
			UICorner = react.createElement("UICorner", {
				CornerRadius = UDim.new(0, 11)
			}),
			Icon = react.createElement(imageSetLabel, {
				Size = UDim2.fromScale(0.75, 0.75),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				LayoutOrder = 1,
				Image = iconslogoblock,
				BackgroundTransparency = 1,
				ImageColor3 = v7.Tokens.Color.Extended.White.White_100.Color3
			})
		})
	else
		local v8

		if defineFastFlag and fn(v6.idType) == userLibConstants.RbxthumbTypes.AvatarImageUrl then
			v8 = v6.id
		elseif FFlagNotificationThumbnailUseProfileFrameThumbnail then
			v8 = getRbxthumbWithTypeSizeAndOptions(
				v6.id,
				fn(v6.idType),
				150,
				nil,
				nil,
				v6.idType == module2.SENDERThumbnailTypeEnum.User or defineFastFlag and v6.idType == module2.SENDERThumbnailTypeEnum.AvatarImageUrl
			)
		else
			v8 = getRbxthumbWithTypeSizeAndOptions(v6.id, fn(v6.idType), 150)
		end

		local createElement = react.createElement
		local v10 = {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			BorderSizePixel = 0
		}

		local createElement2 = react.createElement
		local v13 = {
			BackgroundTransparency = 0,
			BackgroundColor3 = v7.Theme.BackgroundDefault.Color,
			Image = v8,
			Size = UDim2.fromScale(1, 1),
			cornerRadius = 0,
			showFailedStateWhenLoadingFailed = true,
			useShimmerAnimationWhileLoading = true,
			ZIndex = 1
		}
		local v14 = if v6.idType == module2.SENDERThumbnailTypeEnum.User or defineFastFlag and v6.idType == module2.SENDERThumbnailTypeEnum.AvatarImageUrl then UDim.new(0.5, 0) else UDim.new(0, 8)
		v13.cornerRadius = v14
		return createElement("Frame", v10, {
			Thumbnail = createElement2(loadableImage, v13)
		})
	end
end
