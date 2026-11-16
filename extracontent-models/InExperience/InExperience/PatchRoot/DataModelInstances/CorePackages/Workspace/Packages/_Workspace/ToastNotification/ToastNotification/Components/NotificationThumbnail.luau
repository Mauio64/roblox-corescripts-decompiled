local parent = script.Parent.Parent

local context = parent.context
local dependencies = require(parent.dependencies)
local imagePile = dependencies.AppBlox.ImagePile
local react = dependencies.React
local uiBlox = dependencies.UIBlox
local loadableImage = uiBlox.App.Loading.LoadableImage
local useStyle = uiBlox.Core.Style.useStyle
local kind = require(parent.type)
local getRbxthumbWithTypeSizeAndOptions = dependencies.getRbxthumbWithTypeSizeAndOptions
local userLibConstants = dependencies.UserLibConstants

local parent2 = parent.Parent
local NotificationsCommon = require(parent2.NotificationsCommon)
local constants = NotificationsCommon.constants
local SharedFlags = require(parent2.SharedFlags)

local utils = parent.utils
local toastNotificationHelper = require(utils.toastNotificationHelper)

local images = uiBlox.App.ImageSet.Images
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local iconsgraphiclogomarkgradient_xlarge = images["icons/graphic/logomark-gradient_xlarge"]
local iconscommonsafety = images["icons/common/safety"]
local GetFFlagEnableToastIconSupport = SharedFlags.GetFFlagEnableToastIconSupport

local FFlagNotificationThumbnailUseProfileFrameThumbnail = NotificationsCommon.FFlagNotificationThumbnailUseProfileFrameThumbnail

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

	return userLibConstants.RbxthumbTypes.GameIcon
end

local fn2 = not toastNotificationHelper.isUserThumbnail and function(p): boolean
	return p.idType == kind.SENDERThumbnailTypeEnum.User
end or toastNotificationHelper.isUserThumbnail

return function()
	local v = useNotificationCardState("thumbnail")

	if v == nil or #v == 0 then
		return nil
	end

	local v2 = useStyle()
	local v3 = {}
	local v4 = false

	for _, v5 in ipairs(v) do
		v4 = not fn2(v5) or v4

		local id = tostring(v5.id)
		local v6

		if FFlagNotificationThumbnailUseProfileFrameThumbnail then
			v6 = getRbxthumbWithTypeSizeAndOptions(v5.id, fn(v5.idType), 150, nil, nil, fn2(v5))
		else
			v6 = getRbxthumbWithTypeSizeAndOptions(v5.id, fn(v5.idType), 150)
		end

		v3[id] = v6
	end

	local images2 = {}

	if GetFFlagEnableToastIconSupport() then
		local v5 = v[1]

		if v5.idType == kind.SENDERThumbnailTypeEnum.Icon then
			if v5.id == constants.SafetyThumbnailId then
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
							ImageColor3 = v2.Theme.IconDefault.Color
						})
					}
				)
			end

			return react.createElement("Frame", {
				BackgroundTransparency = 0,
				Size = UDim2.fromScale(1, 1),
				SizeConstraint = Enum.SizeConstraint.RelativeXX,
				BackgroundColor3 = v2.Tokens.Color.Extended.Black.Black_100.Color3,
				BorderSizePixel = 0
			}, {
				UICorner = react.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
				Icon = react.createElement(imageSetLabel, {
					Size = UDim2.fromScale(0.8, 0.8),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					LayoutOrder = 1,
					Image = iconsgraphiclogomarkgradient_xlarge,
					BackgroundTransparency = 1
				})
			})
		end
	end

	if v4 then
		local v5 = v[1]

		if v5 == nil then
			return nil
		end

		local image

		if FFlagNotificationThumbnailUseProfileFrameThumbnail then
			image = getRbxthumbWithTypeSizeAndOptions(v5.id, fn(v5.idType), 150, nil, nil, fn2(v5))
		else
			image = getRbxthumbWithTypeSizeAndOptions(v5.id, fn(v5.idType), 150)
		end

		local udim = UDim.new(0.5, 0)

		local createElement = react.createElement
		local v6 = {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			BorderSizePixel = 0
		}

		local createElement2 = react.createElement
		local v7 = {
			BackgroundTransparency = 1,
			Image = image,
			Size = UDim2.fromScale(1, 1),
			cornerRadius = 0,
			showFailedStateWhenLoadingFailed = true,
			useShimmerAnimationWhileLoading = true,
			ZIndex = 1
		}

		if not fn2(v5) then
			udim = UDim.new(0, 8)
		end

		v7.cornerRadius = udim
		return createElement("Frame", v6, {
			Thumbnail = createElement2(loadableImage, v7)
		})
	end

	for _, image in v3 do
		table.insert(images2, { Image = image, BackgroundColor3 = Color3.fromRGB(101, 102, 104) })
	end

	return react.createElement(imagePile, {
		images = images2,
		imageBorderColor = v2.Theme.BackgroundUIDefault.Color,
		imageBorderThickness = #images2 > 1 and 2 or 0
	})
end
