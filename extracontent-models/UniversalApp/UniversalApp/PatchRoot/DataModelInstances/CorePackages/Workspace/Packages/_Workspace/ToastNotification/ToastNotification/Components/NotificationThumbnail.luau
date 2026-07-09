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
local constants = require(ParentParentParent.NotificationsCommon).constants
local SharedFlags = require(ParentParentParent.SharedFlags)
local utils = ParentParent.utils
local toastNotificationHelper = require(utils.toastNotificationHelper)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v19 = Images["icons/graphic/logomark-gradient_xlarge"]
local v20 = Images["icons/common/safety"]
local GetFFlagEnableToastIconSupport = SharedFlags.GetFFlagEnableToastIconSupport
local useNotificationCardState = require(context.useNotificationCardState)

local function v23(p1) -- line: 30
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

local v24 = not toastNotificationHelper.isUserThumbnail and function(p2) -- line: 48
	-- upvalues: type (copy)
	return p2.idType == type.SENDERThumbnailTypeEnum.User
end or toastNotificationHelper.isUserThumbnail

return function() -- line: 52
	-- upvalues: useNotificationCardState (copy), useStyle (copy), v24 (copy), getRbxthumbWithTypeSizeAndOptions (copy), v23 (copy), GetFFlagEnableToastIconSupport (copy), type (copy), constants (copy), React (copy), ImageSetLabel (copy), v20 (copy), v19 (copy), ImagePile (copy), LoadableImage (copy)
	local v27 = useNotificationCardState("thumbnail")

	if v27 == nil or #v27 == 0 then
		return nil
	end

	local v28 = useStyle()
	local t1 = {}
	local v30 = false

	for _, v in ipairs(v27) do
		if not v24(v) then
			v30 = true
		end

		t1[tostring(v.id)] = getRbxthumbWithTypeSizeAndOptions(v.id, v23(v.idType), 150)
	end

	local t2 = {}

	if GetFFlagEnableToastIconSupport() then
		local v34 = v27[1]

		if v34.idType == type.SENDERThumbnailTypeEnum.Icon then
			if v34.id == constants.SafetyThumbnailId then
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
						Image = v20,
						ImageColor3 = v28.Theme.IconDefault.Color
					})
				})
			end

			return React.createElement("Frame", {
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				SizeConstraint = Enum.SizeConstraint.RelativeXX,
				BackgroundColor3 = v28.Tokens.Color.Extended.Black.Black_100.Color3
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
					Image = v19
				})
			})
		end
	end

	if not v30 then
		for _, v36 in t1 do
			table.insert(t2, {
				Image = v36,
				BackgroundColor3 = Color3.fromRGB(101, 102, 104)
			})
		end

		return React.createElement(ImagePile, {
			images = t2,
			imageBorderColor = v28.Theme.BackgroundUIDefault.Color,
			imageBorderThickness = not (#t2 > 1) and 0 or 2
		})
	end

	local v37 = v27[1]

	if v37 == nil then
		return nil
	end

	local v38 = getRbxthumbWithTypeSizeAndOptions(v37.id, v23(v37.idType), 150)
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
			Image = v38,
			Size = UDim2.fromScale(1, 1),
			cornerRadius = if not v24(v37) then UDim.new(0, 8) else uDim
		})
	})
end
