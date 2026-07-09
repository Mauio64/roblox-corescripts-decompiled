local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local React = require(LoginV2Parent.React)
local UIBlox = require(LoginV2Parent.UIBlox)
local Style = require(LoginV2Parent.Style)
local useStyle = UIBlox.Core.Style.useStyle
local useDesignTokens = Style.useDesignTokens
local LoadableImage = UIBlox.App.Loading.LoadableImage
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local getStandardSizeAvatarHeadShotRbxthumb = require(LoginV2Parent.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb
local GetFFlagLuaAppEnableOpenTypeSupport = require(LoginV2Parent.SharedFlags).GetFFlagLuaAppEnableOpenTypeSupport
local UserIdentifierType = require(LoginV2.Enums.UserIdentifierType)
local LoginContext = require(LoginV2.Context.LoginContext)

function UserIdentifierHeading(t1: {[any]: any}) -- line: 28
	-- upvalues: React (copy), LoginContext (copy), useStyle (copy), useDesignTokens (copy), UserIdentifierType (copy), LoadableImage (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), StyledTextLabel (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), OpenTypeSupport (copy)
	local state = React.useContext(LoginContext).state
	local v17 = useStyle()
	local v18 = useDesignTokens()
	local v19 = state.userIdentifierType == UserIdentifierType.Username

	return (React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.layoutOrder
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, v18.Size.Size_300)
		}),
		VerticalLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, v18.Size.Size_100)
		}),
		Thumbnail = v19 and React.createElement(LoadableImage, {
			LayoutOrder = 1,
			useShimmerAnimationWhileLoading = true,
			shouldHandleReloads = true,
			Size = UDim2.new(0, 72, 0, 72),
			Image = t1.userId ~= nil and getStandardSizeAvatarHeadShotRbxthumb(t1.userId),
			cornerRadius = UDim.new(0.5, 0)
		}),
		ThumbnailSpacing = v19 and React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 0, v18.Size.Size_300)
		}),
		UserIdentifierText = React.createElement(StyledTextLabel, {
			layoutOrder = 3,
			fluidSizing = true,
			lineHeight = 1,
			text = if not v19 then t1.userIdentifier else t1.displayName or "",
			fontStyle = v17.Font.Header1,
			colorStyle = v17.Theme.TextEmphasis,
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Center,
			automaticSize = Enum.AutomaticSize.XY,
			openTypeFeatures = if not GetFFlagLuaAppEnableOpenTypeSupport() then nil else OpenTypeSupport:getUserNameStylisticAlternative()
		}),
		SecondaryUsernameText = v19 and React.createElement(StyledTextLabel, {
			layoutOrder = 4,
			fluidSizing = true,
			lineHeight = 1,
			text = not t1.userIdentifier and "" or "@" .. t1.userIdentifier,
			fontStyle = v17.Font.Body,
			colorStyle = v17.Theme.TextDefault,
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Center,
			automaticSize = Enum.AutomaticSize.XY,
			openTypeFeatures = if not GetFFlagLuaAppEnableOpenTypeSupport() then nil else OpenTypeSupport:getUserNameStylisticAlternative()
		})
	}))
end

return UserIdentifierHeading
