local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local QRCodeDisplay = require(ProfileQRCodeParent.QRCodeDisplay)
local React = require(ProfileQRCodeParent.React)
local UIBlox = require(ProfileQRCodeParent.UIBlox)
local UserLib = require(ProfileQRCodeParent.UserLib)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local LightTheme = UIBlox.App.Style.Themes.LightTheme
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport
local useLocalUserId = require(ProfileQRCodeParent.RobloxAppHooks).useLocalUserId
local useLocalUserInfo = require(ProfileQRCode.Utils.useLocalUserInfo)
local useStyle = UIBlox.Core.Style.useStyle
local DisplayQRCode = QRCodeDisplay.DisplayQRCode
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb
local GetFFlagLuaAppEnableOpenTypeSupport = require(ProfileQRCodeParent.SharedFlags).GetFFlagLuaAppEnableOpenTypeSupport
local v18 = Images["component_assets/dropshadow_56_8"]

return function(t1: {[any]: any}) -- line: 38
	-- upvalues: useLocalUserId (copy), useLocalUserInfo (copy), useStyle (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), React (copy), LightTheme (copy), DisplayQRCode (copy), QRCodeDisplay (copy), ImageSetLabel (copy), v18 (copy), StyledTextLabel (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), OpenTypeSupport (copy)
	local v20 = useLocalUserId()
	local v21 = useLocalUserInfo(v20)
	local v22 = useStyle()
	local v23 = nil

	if v20 then
		v23 = getStandardSizeAvatarHeadShotRbxthumb(v20)
	end

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = LightTheme.BackgroundUIDefault.Transparency,
		BackgroundColor3 = LightTheme.BackgroundUIDefault.Color,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, if not t1.isSmallScreen then t1.padding else t1.padding / 2),
			PaddingRight = UDim.new(0, t1.padding),
			PaddingBottom = UDim.new(0, if not t1.isSmallScreen then t1.padding else t1.padding / 2),
			PaddingLeft = UDim.new(0, t1.padding)
		}),
		QRCodeWrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(0, t1.qrCodeLength, 0, t1.qrCodeLength)
		}, {
			QRCode = React.createElement(DisplayQRCode, {
				qrCodeRotation = 15,
				toEncode = t1.url,
				ecLevel = QRCodeDisplay.ECLevels.EC_LEVEL_4,
				sideLength = t1.qrCodeLength,
				pixelColor = LightTheme.UIEmphasis.Color
			}),
			PlayerAvatar = React.createElement("Frame", {
				Rotation = 15,
				ZIndex = 3,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = LightTheme.BackgroundUIDefault.Color,
				BackgroundTransparency = LightTheme.BackgroundUIDefault.Transparency,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(44, 44)
			}, {
				Canvas = React.createElement("CanvasGroup", {
					BorderSizePixel = 0,
					ClipsDescendants = true,
					BackgroundColor3 = LightTheme.BackgroundUIDefault.Color,
					BackgroundTransparency = LightTheme.BackgroundUIDefault.Transparency,
					Size = UDim2.fromScale(1, 1)
				}, {
					Avatar = React.createElement("ImageLabel", {
						BorderSizePixel = 0,
						Rotation = -15,
						ZIndex = 2,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = LightTheme.BackgroundUIDefault.Color,
						BackgroundTransparency = LightTheme.BackgroundUIDefault.Transparency,
						Image = v23,
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromOffset(60, 60)
					})
				}),
				UIStroke = React.createElement("UIStroke", {
					Thickness = 2,
					Color = LightTheme.BackgroundUIDefault.Color
				})
			}),
			BigShadow = React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 70, 0, 70),
				Image = v18,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(28, 28, 29, 29),
				ImageColor3 = v22.Theme.DropShadow.Color,
				ImageTransparency = v22.Theme.DropShadow.Transparency
			})
		}),
		Spacer1 = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(0, 0, 0, 10)
		}),
		DisplayName = React.createElement(StyledTextLabel, {
			layoutOrder = 3,
			lineHeight = 1,
			fluidSizing = false,
			richText = false,
			text = v21.displayName,
			fontStyle = v22.Font.SubHeader1,
			colorStyle = LightTheme.TextEmphasis,
			automaticSize = Enum.AutomaticSize.Y,
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Center,
			textYAlignment = Enum.TextYAlignment.Center,
			size = UDim2.new(1, 0, 0, 0)
		}),
		Username = React.createElement(StyledTextLabel, {
			layoutOrder = 4,
			lineHeight = 1,
			fluidSizing = false,
			richText = false,
			size = UDim2.new(1, 0, 0, 0),
			text = "@" .. v21.username,
			fontStyle = v22.Font.CaptionBody,
			automaticSize = Enum.AutomaticSize.Y,
			colorStyle = LightTheme.TextEmphasis,
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Center,
			textYAlignment = Enum.TextYAlignment.Center,
			openTypeFeatures = if not GetFFlagLuaAppEnableOpenTypeSupport() then nil else OpenTypeSupport:getUserNameStylisticAlternative()
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.05, 0)
		})
	})
end
