local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local withLocalization = require(Modules.LuaApp.withLocalization)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local FitChildren = require(Modules.LuaApp.FitChildren)
local FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)
local UserThumbnail = require(Modules.LuaApp.Components.Authentication.CrossDeviceLogin.UserThumbnail)

return function(p1) -- line: 16
	-- upvalues: useDesignTokens (copy), withStyle (copy), withLocalization (copy), Roact (copy), UserThumbnail (copy), FitTextLabel (copy), FitChildren (copy)
	local LoginView = useDesignTokens().LuaApps.LoginView

	return withStyle(function(p2) -- line: 20
		-- upvalues: p1 (copy), withLocalization (copy), Roact (copy), UserThumbnail (copy), LoginView (copy), FitTextLabel (copy), FitChildren (copy)
		local UserId = p1.UserId
		local DisplayName = p1.DisplayName
		local BodyFont = p2.Font.Body.Font
		local BaseSize = p2.Font.BaseSize
		local v17 = BaseSize * p2.Font.Body.RelativeSize
		local v18 = BaseSize * p2.Font.CaptionBody.RelativeSize
		local TextEmphasisTransparency = p2.Theme.TextEmphasis.Transparency
		local TextEmphasisColor = p2.Theme.TextEmphasis.Color
		local BackgroundUIDefaultColor = p2.Theme.BackgroundUIDefault.Color
		local leftAlignText = p1.leftAlignText

		return withLocalization({
			confirmLogin = "Authentication.CrossDevice.Label.ConfirmOnDevice",
			loggingInAs = "Authentication.CrossDevice.Label.LogginInAs"
		})(function(p3) -- line: 38
			-- upvalues: Roact (copy), UserThumbnail (copy), LoginView (copy), UserId (copy), BackgroundUIDefaultColor (copy), FitTextLabel (copy), FitChildren (copy), TextEmphasisColor (copy), BodyFont (copy), v17 (copy), TextEmphasisTransparency (copy), leftAlignText (copy), DisplayName (copy), v18 (copy)
			return Roact.createFragment({
				UserThumbnail = Roact.createElement(UserThumbnail, {
					LayoutOrder = 1,
					Size = UDim2.new(0, LoginView.thumbnailSize, 0, LoginView.thumbnailSize),
					UserId = UserId,
					MaskColor = BackgroundUIDefaultColor
				}),
				Spacer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, LoginView.spacerSize)
				}),
				ConfirmLogin = Roact.createElement(FitTextLabel, {
					TextWrapped = true,
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					Text = p3.confirmLogin,
					TextColor3 = TextEmphasisColor,
					Font = BodyFont,
					TextSize = v17,
					TextTransparency = TextEmphasisTransparency,
					TextXAlignment = if not leftAlignText then nil else Enum.TextXAlignment.Left
				}),
				LoggingInAs = DisplayName and Roact.createElement(FitTextLabel, {
					TextWrapped = true,
					RichText = true,
					BackgroundTransparency = 1,
					LayoutOrder = 4,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					Text = string.format(p3.loggingInAs, "<b>" .. DisplayName .. "</b>"),
					TextColor3 = TextEmphasisColor,
					Font = BodyFont,
					TextSize = v18,
					TextTransparency = TextEmphasisTransparency,
					TextXAlignment = if not leftAlignText then nil else Enum.TextXAlignment.Left
				})
			})
		end)
	end)
end
