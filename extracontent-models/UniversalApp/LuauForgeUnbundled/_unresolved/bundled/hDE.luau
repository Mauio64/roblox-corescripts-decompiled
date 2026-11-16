local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local module = require("@luauforge/bundled/edC")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local Foundation = require(CorePackages.Packages.Foundation)

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local v5

if foundationFontFaceMigration then
	local FitFrame = require(CorePackages.Packages.FitFrame)
	v5 = FitFrame.FitTextLabel
else
	v5 = require("@luauforge/bundled/fpE")
end

local module3 = require("@luauforge/bundled/hDF")
local module4 = require("@luauforge/bundled/hDG")

local text = Foundation.Text
local view = Foundation.View

return function(player)
	local v6 = useDesignTokens()
	local loginView = v6.LuaApps.LoginView

	return withStyle(function(p2)
		local userId = player.UserId
		local displayName = player.DisplayName

		local font = p2.Font.Body.Font
		local baseSize = p2.Font.BaseSize
		local v7 = baseSize * p2.Font.Body.RelativeSize
		local v8 = baseSize * p2.Font.CaptionBody.RelativeSize

		local transparency = p2.Theme.TextEmphasis.Transparency
		local color = p2.Theme.TextEmphasis.Color
		local color2 = p2.Theme.BackgroundUIDefault.Color

		local leftAlignText = player.leftAlignText

		return module(player.useFoundationSheet and {
			confirmOnSignedInDevice = "Authentication.CrossDevice.Description.ConfirmOnSignedInDevice",
			signingInAs = {
				"Authentication.CrossDevice.Description.SigningInAs",
				identifier = displayName
			}
		} or {
			confirmLogin = "Authentication.CrossDevice.Label.ConfirmOnDevice",
			loggingInAs = "Authentication.CrossDevice.Label.LogginInAs"
		})(function(props)
			if player.useFoundationSheet then
				return Roact.createElement(
					view,
					{ tag = "col align-x-center gap-xlarge size-full-0 auto-y" },
					{
						Copy = Roact.createElement(
							view,
							{ LayoutOrder = 1, tag = "col size-full-0 auto-y" },
							{
								ConfirmLogin = Roact.createElement(text, {
									LayoutOrder = 1,
									Text = props.confirmOnSignedInDevice,
									tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default"
								}),
								LoggingInAs = Roact.createElement(text, {
									LayoutOrder = 2,
									Text = props.signingInAs,
									tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default"
								})
							}
						),
						UserAvatar = Roact.createElement(module3, {
							size = 158,
							LayoutOrder = 2
						})
					}
				)
			end

			local createFragment = Roact.createFragment
			local v10 = {
				UserThumbnail = Roact.createElement(module4, {
					Size = UDim2.new(0, loginView.thumbnailSize, 0, loginView.thumbnailSize),
					UserId = userId,
					MaskColor = color2,
					LayoutOrder = 1
				}),
				Spacer = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, loginView.spacerSize),
					BackgroundTransparency = 1,
					LayoutOrder = 2
				}),
				ConfirmLogin = 0,
				LoggingInAs = 0
			}

			local createElement = Roact.createElement
			local v12 = {
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = 0,
				width = 0,
				Text = 0,
				TextWrapped = true,
				BackgroundTransparency = 1,
				TextColor3 = 0,
				Font = 0,
				TextSize = 0,
				TextTransparency = 0,
				TextXAlignment = 0,
				LayoutOrder = 3
			}
			local v13 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
			v12.fitAxis = v13
			local v14 = if foundationFontFaceMigration then UDim.new(1, 0) else nil
			v12.width = v14
			v12.Text = props.confirmLogin

			v12.TextColor3 = color

			local v15 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.BodyLarge.Font) else font
			v12.Font = v15

			v12.TextSize = v7
			v12.TextTransparency = transparency
			local v16 = if leftAlignText then Enum.TextXAlignment.Left else nil
			v12.TextXAlignment = v16
			v10.ConfirmLogin = createElement(v5, v12)

			local v17 = displayName

			if v17 then
				local createElement2 = Roact.createElement
				local v19 = {
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = 0,
					width = 0,
					Text = 0,
					TextWrapped = true,
					RichText = true,
					BackgroundTransparency = 1,
					TextColor3 = 0,
					Font = 0,
					TextSize = 0,
					TextTransparency = 0,
					TextXAlignment = 0,
					LayoutOrder = 4
				}
				local v20 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
				v19.fitAxis = v20
				local v21 = if foundationFontFaceMigration then UDim.new(1, 0) else nil
				v19.width = v21
				v19.Text = string.format(props.loggingInAs, "<b>" .. displayName .. "</b>")

				v19.TextColor3 = color

				local v22 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.BodyLarge.Font) else font
				v19.Font = v22

				v19.TextSize = v8
				v19.TextTransparency = transparency
				local v23 = if leftAlignText then Enum.TextXAlignment.Left else nil
				v19.TextXAlignment = v23
				v17 = createElement2(v5, v19)
			end

			v10.LoggingInAs = v17
			return createFragment(v10)
		end)
	end)
end
