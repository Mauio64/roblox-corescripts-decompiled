local module = require("@luauforge/bundled/fCE")
local module2 = require("@luauforge/bundled/fFl")

local module3 = require("@luauforge/bundled/fFo")
local useStyle = module2.Core.Style.useStyle
local useDesignTokens = module3.useDesignTokens
local useLocalization = require("@luauforge/bundled/fFn").Hooks.useLocalization
local loadableImage = module2.App.Loading.LoadableImage
local openTypeSupport = module2.Utility.OpenTypeSupport
local styledTextLabel = module2.App.Text.StyledTextLabel
local getStandardSizeAvatarHeadShotRbxthumb = require("@luauforge/bundled/fFT").Utils.getStandardSizeAvatarHeadShotRbxthumb
local getFFlagLuaAppEnableOpenTypeSupport = require("@luauforge/bundled/fFu").GetFFlagLuaAppEnableOpenTypeSupport
local fFlagEnableLoginV2Modalization = require("@luauforge/bundled/fFu").FFlagEnableLoginV2Modalization

local module4 = require("@luauforge/bundled/fFp")
local text = module4.Text
local image = module4.Image

local module5 = require("@luauforge/bundled/fCm")
local module6 = require("@luauforge/bundled/fFq")
local module7 = require("@luauforge/bundled/fFs")
local module8 = require("@luauforge/bundled/fFU")

function LUAUFORGE_MODULE_GLOBALS_fFS_UserIdentifierHeading(props)
	local state = module.useContext(module6).state

	local v5 = useStyle()
	local v6 = useDesignTokens()
	local v7, v8

	if fFlagEnableLoginV2Modalization then
		v7 = module7()

		local v9 = module8(props.userIdentifier)
		v8 = useLocalization({
			signingInWithText = {
				"Authentication.Login.Description.SigningInWith",
				identifier = v9
			},
			usernameHandleText = {
				"Authentication.Login.Description.UsernameHandle",
				username = v9
			}
		})
	else
		v7 = false
	end

	local v9 = state.userIdentifierType == module5.Username
	local v10 = v7 and 86 or 72
	local v11 = not v8 and "" or v8.signingInWithText
	local v12 = not v8 and "" or v8.usernameHandleText

	local createElement = module.createElement
	local v14 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = module.createElement
	local newUDim = UDim.new

	local v18 = if v7 then (if v9 then v6.Size.Size_400 else v6.Size.Size_500) else v6.Size.Size_300
	local children = {
		UIPadding = createElement2("UIPadding", { PaddingBottom = newUDim(0, v18) }),
		VerticalLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, v6.Size.Size_100)
		}),
		Thumbnail = 0,
		ThumbnailSpacing = 0,
		UserIdentifierText = 0,
		SecondaryUsernameText = 0
	}
	local v19

	if v9 then
		if v7 then
			local createElement3 = module.createElement
			local v21 = {
				LayoutOrder = 1,
				Size = UDim2.new(0, v10, 0, v10),
				Image = 0,
				tag = "radius-circle clip bg-surface-300",
				ScaleType = 0
			}
			local v22 = if props.userId ~= nil then getStandardSizeAvatarHeadShotRbxthumb(props.userId) or nil else nil
			v21.Image = v22

			v21.ScaleType = Enum.ScaleType.Crop
			v19 = createElement3(image, v21)
		else
			v19 = module.createElement(loadableImage, {
				LayoutOrder = 1,
				Size = UDim2.new(0, 72, 0, 72),
				Image = props.userId ~= nil and getStandardSizeAvatarHeadShotRbxthumb(props.userId),
				useShimmerAnimationWhileLoading = true,
				cornerRadius = UDim.new(0.5, 0),
				shouldHandleReloads = true
			})
		end
	else
		v19 = v9
	end

	children.Thumbnail = v19
	local v20

	if v9 then
		local createElement3 = module.createElement

		local newUDim2 = UDim2.new

		local v26 = if v7 then v6.Size.Size_100 else v6.Size.Size_300
		v20 = createElement3("Frame", {
			LayoutOrder = 2,
			Size = newUDim2(0, 0, 0, v26),
			BackgroundTransparency = 1
		})
	else
		v20 = v9
	end

	children.ThumbnailSpacing = v20
	local v21

	if v7 then
		v21 = module.createElement(text, {
			LayoutOrder = 3,
			Text = v9 and (props.displayName or "") or v11,
			RichText = not v9,
			tag = v9 and "size-full-0 auto-y text-heading-small text-align-x-center text-truncate-end content-emphasis" or "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default"
		})
	else
		local createElement3 = module.createElement

		local v24 = if v9 then props.displayName or "" else props.userIdentifier
		local v23 = {
			text = v24,
			fontStyle = v5.Font.Header1,
			colorStyle = v5.Theme.TextEmphasis,
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Center,
			automaticSize = Enum.AutomaticSize.XY,
			layoutOrder = 3,
			fluidSizing = true,
			lineHeight = 1,
			openTypeFeatures = 0
		}

		local v25 = if getFFlagLuaAppEnableOpenTypeSupport() then openTypeSupport:getUserNameStylisticAlternative() else nil
		v23.openTypeFeatures = v25
		v21 = createElement3(styledTextLabel, v23)
	end

	children.UserIdentifierText = v21

	if v9 then
		if v7 then
			v9 = module.createElement(text, {
				LayoutOrder = 4,
				Text = v12,
				RichText = true,
				tag = "size-full-0 auto-y text-body-medium text-align-x-center text-truncate-end content-default"
			})
		else
			local createElement3 = module.createElement
			local v23 = {
				text = not props.userIdentifier and "" or "@" .. props.userIdentifier,
				fontStyle = v5.Font.Body,
				colorStyle = v5.Theme.TextDefault,
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Center,
				automaticSize = Enum.AutomaticSize.XY,
				layoutOrder = 4,
				fluidSizing = true,
				lineHeight = 1,
				openTypeFeatures = 0
			}

			local v24 = if getFFlagLuaAppEnableOpenTypeSupport() then openTypeSupport:getUserNameStylisticAlternative() else nil
			v23.openTypeFeatures = v24
			v9 = createElement3(styledTextLabel, v23)
		end
	end

	children.SecondaryUsernameText = v9
	return (createElement("Frame", v14, children))
end

return LUAUFORGE_MODULE_GLOBALS_fFS_UserIdentifierHeading
