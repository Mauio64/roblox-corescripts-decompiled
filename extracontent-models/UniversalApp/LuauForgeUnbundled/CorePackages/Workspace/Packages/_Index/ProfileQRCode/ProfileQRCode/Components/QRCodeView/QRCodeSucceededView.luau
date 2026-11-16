local QRCodeDisplay = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/QRCodeDisplay")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/UIBlox")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/UserLib")

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local lightTheme = UIBlox.App.Style.Themes.LightTheme
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local openTypeSupport = UIBlox.Utility.OpenTypeSupport

local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/RobloxAppHooks").useLocalUserId
local useLocalUserInfo = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Utils/useLocalUserInfo")
local useStyle = UIBlox.Core.Style.useStyle

local FFlagProfileQrCodeDeprecateUserRedux = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Flags/FFlagProfileQrCodeDeprecateUserRedux")

local displayQRCode = QRCodeDisplay.DisplayQRCode
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb

local getFFlagLuaAppEnableOpenTypeSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/SharedFlags").GetFFlagLuaAppEnableOpenTypeSupport

local component_assetsdropshadow_56_8 = images["component_assets/dropshadow_56_8"]

return function(props)
	local v5 = useLocalUserId()
	local v6 = useLocalUserInfo(v5)
	local v7 = useStyle()

	local v8 = if v5 then getStandardSizeAvatarHeadShotRbxthumb(v5) else nil

	local createElement = React.createElement
	local v10 = {
		BorderSizePixel = 0,
		BackgroundTransparency = lightTheme.BackgroundUIDefault.Transparency,
		BackgroundColor3 = lightTheme.BackgroundUIDefault.Color,
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
	local newUDim = UDim.new
	local v14 = if props.isSmallScreen then props.padding / 2 else props.padding
	local v12 = {
		PaddingTop = newUDim(0, v14),
		PaddingRight = UDim.new(0, props.padding),
		PaddingBottom = 0,
		PaddingLeft = 0
	}
	local newUDim2 = UDim.new
	local v16 = if props.isSmallScreen then props.padding / 2 else props.padding
	v12.PaddingBottom = newUDim2(0, v16)
	v12.PaddingLeft = UDim.new(0, props.padding)
	children.Padding = createElement2("UIPadding", v12)

	children.QRCodeWrapper = React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(0, props.qrCodeLength, 0, props.qrCodeLength),
			LayoutOrder = 1
		},
		{
			QRCode = React.createElement(displayQRCode, {
				toEncode = props.url,
				ecLevel = QRCodeDisplay.ECLevels.EC_LEVEL_4,
				sideLength = props.qrCodeLength,
				pixelColor = lightTheme.UIEmphasis.Color,
				qrCodeRotation = 15
			}),
			PlayerAvatar = React.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = lightTheme.BackgroundUIDefault.Color,
				BackgroundTransparency = lightTheme.BackgroundUIDefault.Transparency,
				Position = UDim2.fromScale(0.5, 0.5),
				Rotation = 15,
				Size = UDim2.fromOffset(44, 44),
				ZIndex = 3
			}, {
				Canvas = React.createElement("CanvasGroup", {
					BackgroundColor3 = lightTheme.BackgroundUIDefault.Color,
					BackgroundTransparency = lightTheme.BackgroundUIDefault.Transparency,
					BorderSizePixel = 0,
					ClipsDescendants = true,
					Size = UDim2.fromScale(1, 1)
				}, {
					Avatar = React.createElement("ImageLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = lightTheme.BackgroundUIDefault.Color,
						BackgroundTransparency = lightTheme.BackgroundUIDefault.Transparency,
						BorderSizePixel = 0,
						Image = v8,
						Position = UDim2.fromScale(0.5, 0.5),
						Rotation = -15,
						Size = UDim2.fromOffset(60, 60),
						ZIndex = 2
					})
				}),
				UIStroke = React.createElement("UIStroke", {
					Color = lightTheme.BackgroundUIDefault.Color,
					Thickness = 2
				})
			}),
			BigShadow = React.createElement(imageSetLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 70, 0, 70),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2,
				Image = component_assetsdropshadow_56_8,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(28, 28, 29, 29),
				ImageColor3 = v7.Theme.DropShadow.Color,
				ImageTransparency = v7.Theme.DropShadow.Transparency
			})
		}
	)

	children.Spacer1 = React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 0, 10),
		LayoutOrder = 2
	})

	children.DisplayName = React.createElement(styledTextLabel, {
		layoutOrder = 3,
		text = v6.displayName,
		fontStyle = v7.Font.SubHeader1,
		lineHeight = 1,
		colorStyle = lightTheme.TextEmphasis,
		automaticSize = Enum.AutomaticSize.Y,
		textTruncate = Enum.TextTruncate.AtEnd,
		textXAlignment = Enum.TextXAlignment.Center,
		textYAlignment = Enum.TextYAlignment.Center,
		fluidSizing = false,
		richText = false,
		size = UDim2.new(1, 0, 0, 0)
	})

	local createElement3 = React.createElement
	local v18 = {
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

	local v20 = if FFlagProfileQrCodeDeprecateUserRedux then v6.username or "" else v6.username
	v18.text = "@" .. v20
	v18.fontStyle = v7.Font.CaptionBody

	v18.automaticSize = Enum.AutomaticSize.Y
	v18.colorStyle = lightTheme.TextEmphasis
	v18.textTruncate = Enum.TextTruncate.AtEnd
	v18.textXAlignment = Enum.TextXAlignment.Center
	v18.textYAlignment = Enum.TextYAlignment.Center

	local v21 = if getFFlagLuaAppEnableOpenTypeSupport() then openTypeSupport:getUserNameStylisticAlternative() else nil
	v18.openTypeFeatures = v21
	children.Username = createElement3(styledTextLabel, v18)

	children.UICorner = React.createElement("UICorner", {
		CornerRadius = UDim.new(0.05, 0)
	})
	return createElement("Frame", v10, children)
end
