local ParentParent = script.Parent.Parent
local context = ParentParent.context
local dependencies = require(ParentParent.dependencies)
local ImagePile = dependencies.AppBlox.ImagePile
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local LoadableImage = UIBlox.App.Loading.LoadableImage
local useStyle = UIBlox.Core.Style.useStyle
local type = require(ParentParent.type)
local getRbxthumbWithTypeSizeAndOptions = dependencies.getRbxthumbWithTypeSizeAndOptions
local UserLibConstants = dependencies.UserLibConstants
local ParentParentParent = ParentParent.Parent
local NotificationsCommon = require(ParentParentParent.NotificationsCommon)
local constants = NotificationsCommon.constants
local SharedFlags = require(ParentParentParent.SharedFlags)
local utils = ParentParent.utils
local toastNotificationHelper = require(utils.toastNotificationHelper)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v20 = Images["icons/graphic/logomark-gradient_xlarge"]
local v21 = Images["icons/common/safety"]
local GetFFlagEnableToastIconSupport = SharedFlags.GetFFlagEnableToastIconSupport
local FFlagNotificationThumbnailUseProfileFrameThumbnail = NotificationsCommon.FFlagNotificationThumbnailUseProfileFrameThumbnail
local useNotificationCardState = require(context.useNotificationCardState)

local function v25(p1) -- line: 32
	-- upvalues: type (copy), UserLibConstants (copy)
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

	return UserLibConstants.RbxthumbTypes.GameIcon
end

local v26 = not toastNotificationHelper.isUserThumbnail and function(p2) -- line: 50
	-- upvalues: type (copy)
	return p2.idType == type.SENDERThumbnailTypeEnum.User
end or toastNotificationHelper.isUserThumbnail

return function() -- line: 54
	-- upvalues: useNotificationCardState (copy), useStyle (copy), v26 (copy), FFlagNotificationThumbnailUseProfileFrameThumbnail (copy), getRbxthumbWithTypeSizeAndOptions (copy), v25 (copy), GetFFlagEnableToastIconSupport (copy), type (copy), constants (copy), React (copy), ImageSetLabel (copy), v21 (copy), v20 (copy), ImagePile (copy), LoadableImage (copy)
	local v29 = useNotificationCardState("thumbnail")

	if v29 == nil or #v29 == 0 then
		return nil
	end

	local v30 = useStyle()
	local t1 = {}
	local v32 = false

	for _, v in ipairs(v29) do
		if not v26(v) then
			v32 = true
		end

		t1[tostring(v.id)] = if not FFlagNotificationThumbnailUseProfileFrameThumbnail then getRbxthumbWithTypeSizeAndOptions(v.id, v25(v.idType), 150) else getRbxthumbWithTypeSizeAndOptions(v.id, v25(v.idType), 150, nil, nil, v26(v))
	end

	local t2 = {}

	if GetFFlagEnableToastIconSupport() then
		local v36 = v29[1]

		if v36.idType == type.SENDERThumbnailTypeEnum.Icon then
			if v36.id == constants.SafetyThumbnailId then
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
						Image = v21,
						ImageColor3 = v30.Theme.IconDefault.Color
					})
				})
			end

			return React.createElement("Frame", {
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				SizeConstraint = Enum.SizeConstraint.RelativeXX,
				BackgroundColor3 = v30.Tokens.Color.Extended.Black.Black_100.Color3
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 8)
				}),
				Icon = React.createElement(ImageSetLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(0.8, 0.8),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Image = v20
				})
			})
		end
	end

	if not v32 then
		for _, v38 in t1 do
			table.insert(t2, {
				Image = v38,
				BackgroundColor3 = Color3.fromRGB(101, 102, 104)
			})
		end

		return React.createElement(ImagePile, {
			images = t2,
			imageBorderColor = v30.Theme.BackgroundUIDefault.Color,
			imageBorderThickness = not (#t2 > 1) and 0 or 2
		})
	end

	local v39 = v29[1]

	if v39 == nil then
		return nil
	end

	local v40 = if not FFlagNotificationThumbnailUseProfileFrameThumbnail then getRbxthumbWithTypeSizeAndOptions(v39.id, v25(v39.idType), 150) else getRbxthumbWithTypeSizeAndOptions(v39.id, v25(v39.idType), 150, nil, nil, v26(v39))
	local uDim = UDim.new(0.5, 0)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		SizeConstraint = Enum.SizeConstraint.RelativeXX
	}, {
		Thumbnail = React.createElement(LoadableImage, {
			BackgroundTransparency = 1,
			showFailedStateWhenLoadingFailed = true,
			useShimmerAnimationWhileLoading = true,
			ZIndex = 1,
			Image = v40,
			Size = UDim2.fromScale(1, 1),
			cornerRadius = if not v26(v39) then UDim.new(0, 8) else uDim
		})
	})
end
