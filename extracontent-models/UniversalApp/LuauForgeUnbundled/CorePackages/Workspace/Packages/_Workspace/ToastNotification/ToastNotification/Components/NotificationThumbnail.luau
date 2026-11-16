local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/dependencies")
local imagePile = dependencies.AppBlox.ImagePile
local react = dependencies.React
local uiBlox = dependencies.UIBlox
local loadableImage = uiBlox.App.Loading.LoadableImage
local useStyle = uiBlox.Core.Style.useStyle
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type")
local getRbxthumbWithTypeSizeAndOptions = dependencies.getRbxthumbWithTypeSizeAndOptions
local userLibConstants = dependencies.UserLibConstants

local NotificationsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/NotificationsCommon")
local constants = NotificationsCommon.constants
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/SharedFlags")

local toastNotificationHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/utils/toastNotificationHelper")

local images = uiBlox.App.ImageSet.Images
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local iconsgraphiclogomarkgradient_xlarge = images["icons/graphic/logomark-gradient_xlarge"]
local iconscommonsafety = images["icons/common/safety"]
local getFFlagEnableToastIconSupport = SharedFlags.GetFFlagEnableToastIconSupport

local fFlagNotificationThumbnailUseProfileFrameThumbnail = NotificationsCommon.FFlagNotificationThumbnailUseProfileFrameThumbnail

local useNotificationCardState = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/context/useNotificationCardState")

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

	return userLibConstants.RbxthumbTypes.GameIcon
end

local fn2 = not toastNotificationHelper.isUserThumbnail and function(p2): boolean
	return p2.idType == module2.SENDERThumbnailTypeEnum.User
end or toastNotificationHelper.isUserThumbnail

return function()
	local v5 = useNotificationCardState("thumbnail")

	if v5 == nil or #v5 == 0 then
		return nil
	end

	local v6 = useStyle()
	local v7 = {}
	local v8 = false

	for i, v9 in ipairs(v5) do
		v8 = not fn2(v9) or v8

		local id = tostring(v9.id)
		local v10 = if fFlagNotificationThumbnailUseProfileFrameThumbnail then getRbxthumbWithTypeSizeAndOptions(
			v9.id,
			fn(v9.idType),
			150,
			nil,
			nil,
			fn2(v9)
		) else getRbxthumbWithTypeSizeAndOptions(v9.id, fn(v9.idType), 150)
		v7[id] = v10
	end

	local v9 = {}

	if getFFlagEnableToastIconSupport() then
		local v10 = v5[1]

		if v10.idType == module2.SENDERThumbnailTypeEnum.Icon then
			if v10.id == constants.SafetyThumbnailId then
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
							ImageColor3 = v6.Theme.IconDefault.Color
						})
					}
				)
			end

			return react.createElement("Frame", {
				BackgroundTransparency = 0,
				Size = UDim2.fromScale(1, 1),
				SizeConstraint = Enum.SizeConstraint.RelativeXX,
				BackgroundColor3 = v6.Tokens.Color.Extended.Black.Black_100.Color3,
				BorderSizePixel = 0
			}, {
				UICorner = react.createElement("UICorner", {
					CornerRadius = UDim.new(0, 8)
				}),
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

	if v8 then
		local v10 = v5[1]

		if v10 == nil then
			return nil
		end

		local v11

		if fFlagNotificationThumbnailUseProfileFrameThumbnail then
			v11 = getRbxthumbWithTypeSizeAndOptions(v10.id, fn(v10.idType), 150, nil, nil, fn2(v10))
		else
			v11 = getRbxthumbWithTypeSizeAndOptions(v10.id, fn(v10.idType), 150)
		end

		local udim = UDim.new(0.5, 0)

		local createElement = react.createElement
		local v13 = {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			BorderSizePixel = 0
		}

		local createElement2 = react.createElement
		local v16 = {
			BackgroundTransparency = 1,
			Image = v11,
			Size = UDim2.fromScale(1, 1),
			cornerRadius = 0,
			showFailedStateWhenLoadingFailed = true,
			useShimmerAnimationWhileLoading = true,
			ZIndex = 1
		}

		if not fn2(v10) then
			udim = UDim.new(0, 8)
		end

		v16.cornerRadius = udim
		return createElement("Frame", v13, {
			Thumbnail = createElement2(loadableImage, v16)
		})
	end

	for k, v10 in v7 do
		table.insert(v9, {
			Image = v10,
			BackgroundColor3 = Color3.fromRGB(101, 102, 104)
		})
	end

	return react.createElement(imagePile, {
		images = v9,
		imageBorderColor = v6.Theme.BackgroundUIDefault.Color,
		imageBorderThickness = #v9 > 1 and 2 or 0
	})
end
