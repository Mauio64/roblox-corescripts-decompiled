local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent

local QRCodeDisplay = require(parent.QRCodeDisplay)
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local UserLib = require(parent.UserLib)

local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local LightTheme = UIBlox.App.Style.Themes.LightTheme
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local useLocalUserInfo = require(ProfileQRCode.Utils.useLocalUserInfo)
local useStyle = UIBlox.Core.Style.useStyle

local FFlagProfileQrCodeDeprecateUserRedux = require(ProfileQRCode.Flags.FFlagProfileQrCodeDeprecateUserRedux)

local DisplayQRCode = QRCodeDisplay.DisplayQRCode
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb

local SharedFlags = require(parent.SharedFlags)
local GetFFlagLuaAppEnableOpenTypeSupport = SharedFlags.GetFFlagLuaAppEnableOpenTypeSupport

local component_assetsdropshadow_56_8 = Images["component_assets/dropshadow_56_8"]

return function(props)
	local v = useLocalUserId()
	local v2 = useLocalUserInfo(v)
	local v3 = useStyle()
	local image

	if v then
		image = getStandardSizeAvatarHeadShotRbxthumb(v)
	end

	local createElement = React.createElement
	local v4 = {
		BorderSizePixel = 0,
		BackgroundTransparency = LightTheme.BackgroundUIDefault.Transparency,
		BackgroundColor3 = LightTheme.BackgroundUIDefault.Color,
		Size = UDim2.new(1, 0, 1, 0)
	}
	local children = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = 0,
		QRCodeWrapper = 0,
		Spacer1 = 0,
		DisplayName = 0,
		Username = 0,
		UICorner = 0
	}

	local createElement2 = React.createElement
	local v5

	if props.isSmallScreen then
		v5 = props.padding / 2
	else
		v5 = props.padding
	end

	local v6 = {
		PaddingTop = UDim.new(0, v5),
		PaddingRight = UDim.new(0, props.padding),
		PaddingBottom = 0,
		PaddingLeft = 0
	}
	local v7

	if props.isSmallScreen then
		v7 = props.padding / 2
	else
		v7 = props.padding
	end

	v6.PaddingBottom = UDim.new(0, v7)
	v6.PaddingLeft = UDim.new(0, props.padding)
	children.Padding = createElement2("UIPadding", v6)

	children.QRCodeWrapper = React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(0, props.qrCodeLength, 0, props.qrCodeLength),
			LayoutOrder = 1
		},
		{
			QRCode = React.createElement(DisplayQRCode, {
				toEncode = props.url,
				ecLevel = QRCodeDisplay.ECLevels.EC_LEVEL_4,
				sideLength = props.qrCodeLength,
				pixelColor = LightTheme.UIEmphasis.Color,
				qrCodeRotation = 15
			}),
			PlayerAvatar = React.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = LightTheme.BackgroundUIDefault.Color,
				BackgroundTransparency = LightTheme.BackgroundUIDefault.Transparency,
				Position = UDim2.fromScale(0.5, 0.5),
				Rotation = 15,
				Size = UDim2.fromOffset(44, 44),
				ZIndex = 3
			}, {
				Canvas = React.createElement("CanvasGroup", {
					BackgroundColor3 = LightTheme.BackgroundUIDefault.Color,
					BackgroundTransparency = LightTheme.BackgroundUIDefault.Transparency,
					BorderSizePixel = 0,
					ClipsDescendants = true,
					Size = UDim2.fromScale(1, 1)
				}, {
					Avatar = React.createElement("ImageLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = LightTheme.BackgroundUIDefault.Color,
						BackgroundTransparency = LightTheme.BackgroundUIDefault.Transparency,
						BorderSizePixel = 0,
						Image = image,
						Position = UDim2.fromScale(0.5, 0.5),
						Rotation = -15,
						Size = UDim2.fromOffset(60, 60),
						ZIndex = 2
					})
				}),
				UIStroke = React.createElement("UIStroke", {
					Color = LightTheme.BackgroundUIDefault.Color,
					Thickness = 2
				})
			}),
			BigShadow = React.createElement(ImageSetLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 70, 0, 70),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2,
				Image = component_assetsdropshadow_56_8,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(28, 28, 29, 29),
				ImageColor3 = v3.Theme.DropShadow.Color,
				ImageTransparency = v3.Theme.DropShadow.Transparency
			})
		}
	)

	children.Spacer1 = React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 0, 10),
		LayoutOrder = 2
	})

	children.DisplayName = React.createElement(StyledTextLabel, {
		layoutOrder = 3,
		text = v2.displayName,
		fontStyle = v3.Font.SubHeader1,
		lineHeight = 1,
		colorStyle = LightTheme.TextEmphasis,
		automaticSize = Enum.AutomaticSize.Y,
		textTruncate = Enum.TextTruncate.AtEnd,
		textXAlignment = Enum.TextXAlignment.Center,
		textYAlignment = Enum.TextYAlignment.Center,
		fluidSizing = false,
		richText = false,
		size = UDim2.new(1, 0, 0, 0)
	})

	local createElement3 = React.createElement
	local v8 = {
		size = UDim2.new(1, 0, 0, 0),
		layoutOrder = 4,
		text = 0,
		fontStyle = 0,
		lineHeight = 1,
		automaticSize = 0,
		colorStyle = 0,
		textTruncate = 0,
		textXAlignment = 0,
		textYAlignment = 0,
		fluidSizing = false,
		richText = false,
		openTypeFeatures = 0
	}
	local v9

	if FFlagProfileQrCodeDeprecateUserRedux then
		v9 = v2.username or ""
	else
		v9 = v2.username
	end

	v8.text = "@" .. v9
	v8.fontStyle = v3.Font.CaptionBody

	v8.automaticSize = Enum.AutomaticSize.Y
	v8.colorStyle = LightTheme.TextEmphasis
	v8.textTruncate = Enum.TextTruncate.AtEnd
	v8.textXAlignment = Enum.TextXAlignment.Center
	v8.textYAlignment = Enum.TextYAlignment.Center
	local openTypeFeatures

	if GetFFlagLuaAppEnableOpenTypeSupport() then
		openTypeFeatures = OpenTypeSupport:getUserNameStylisticAlternative()
	end

	v8.openTypeFeatures = openTypeFeatures
	children.Username = createElement3(StyledTextLabel, v8)

	children.UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0.05, 0) })
	return createElement("Frame", v4, children)
end
