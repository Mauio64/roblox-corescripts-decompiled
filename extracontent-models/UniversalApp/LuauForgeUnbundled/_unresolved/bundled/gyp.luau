local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local module = require("@luauforge/bundled/egZ")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local Foundation = require(CorePackages.Packages.Foundation)

local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FitFrame = require(CorePackages.Packages.FitFrame)
local fitTextLabel = FitFrame.FitTextLabel

local module2 = require("@luauforge/bundled/gyq")
local module3 = require("@luauforge/bundled/gyr")

local text = Foundation.Text
local view = Foundation.View

return function(player)
	local v5 = useDesignTokens()
	local loginView = v5.LuaApps.LoginView

	return withStyle(function(p2)
		local userId = player.UserId
		local displayName = player.DisplayName

		local baseSize = p2.Font.BaseSize
		local v6 = baseSize * p2.Font.Body.RelativeSize
		local v7 = baseSize * p2.Font.CaptionBody.RelativeSize

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
						UserAvatar = Roact.createElement(module2, {
							size = 158,
							LayoutOrder = 2
						})
					}
				)
			end

			local createFragment = Roact.createFragment
			local v9 = {
				UserThumbnail = Roact.createElement(module3, {
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
			local v11 = {
				Size = UDim2.new(1, 0, 0, 0),
				width = UDim.new(1, 0),
				Text = props.confirmLogin,
				TextWrapped = true,
				BackgroundTransparency = 1,
				TextColor3 = color,
				Font = normalizeFontFace(v5.Typography.BodyLarge.Font),
				TextSize = v6,
				TextTransparency = transparency,
				TextXAlignment = 0,
				LayoutOrder = 3
			}

			local v12 = if leftAlignText then Enum.TextXAlignment.Left else nil
			v11.TextXAlignment = v12
			v9.ConfirmLogin = createElement(fitTextLabel, v11)

			local v13 = displayName

			if v13 then
				local createElement2 = Roact.createElement
				local v15 = {
					Size = UDim2.new(1, 0, 0, 0),
					width = UDim.new(1, 0),
					Text = string.format(props.loggingInAs, "<b>" .. displayName .. "</b>"),
					TextWrapped = true,
					RichText = true,
					BackgroundTransparency = 1,
					TextColor3 = color,
					Font = normalizeFontFace(v5.Typography.BodyLarge.Font),
					TextSize = v7,
					TextTransparency = transparency,
					TextXAlignment = 0,
					LayoutOrder = 4
				}

				local v16 = if leftAlignText then Enum.TextXAlignment.Left else nil
				v15.TextXAlignment = v16
				v13 = createElement2(fitTextLabel, v15)
			end

			v9.LoggingInAs = v13
			return createFragment(v9)
		end)
	end)
end
