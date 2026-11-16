local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local loadableImage = UIBlox.App.Loading.LoadableImage
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/VerifiedBadges")
local isPlayerVerified = require("@luauforge/bundled/cgr").Utils.isPlayerVerified

local getStandardSizeAvatarHeadShotRbxthumb = require("@luauforge/bundled/cgr").Utils.getStandardSizeAvatarHeadShotRbxthumb
local text = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Text
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local Foundation = require(CorePackages.Packages.Foundation)
local view = Foundation.View
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagLuaAppAddTestIdsForArrow = SharedFlags.FFlagLuaAppAddTestIdsForArrow
local getFFlagProfileFrameThumbnailEnabled = SharedFlags.GetFFlagProfileFrameThumbnailEnabled
local v5 = game:DefineFastFlag("UserInfoWidgetUseProfileFrameThumbnail", false)
	and getFFlagProfileFrameThumbnailEnabled()
local fFlagLuaAppMoveProfileIntoTopBar = SharedFlags.FFlagLuaAppMoveProfileIntoTopBar
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local fFlagEnableNonFlyoutUncheckedBadge = SharedFlags.FFlagEnableNonFlyoutUncheckedBadge

local v6 = fFlagEnableNonFlyoutUncheckedBadge and game:DefineFastFlag("FixUsernameSelectionStuck", false)
local fFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local fFlagHidePremiumIconography = SharedFlags.FFlagHidePremiumIconography
local getFFlagFixUserInfoWidgetPlusBadge = SharedFlags.GetFFlagFixUserInfoWidgetPlusBadge
local module3 = require("@luauforge/bundled/ftg")

local module4 = require("@luauforge/bundled/fth")

local extended = Roact.PureComponent:extend("UserWidget")

local v7 = {
	[Enum.MembershipType.None] = 0,
	[Enum.MembershipType.BuildersClub] = 24,
	[Enum.MembershipType.TurboBuildersClub] = 24,
	[Enum.MembershipType.OutrageousBuildersClub] = 24,
	[Enum.MembershipType.Premium] = 36
}

function extended:renderUserAvatar(p3, p4, p5, p6)
	local standardSizeAvatarHeadShotRbxthumb = getStandardSizeAvatarHeadShotRbxthumb(p6.id, v5)

	return Roact.createElement(loadableImage, {
		Size = UDim2.new(0, p3, 0, p3),
		LayoutOrder = 1,
		BackgroundColor3 = p4,
		BackgroundTransparency = p5,
		Image = standardSizeAvatarHeadShotRbxthumb,
		useShimmerAnimationWhileLoading = true,
		cornerRadius = UDim.new(0.5, 0),
		shouldHandleReloads = true
	})
end

function extended:render()
	local localUserModel = self.props.localUserModel
	local onActivated = self.props.onActivated
	local layoutOrder = self.props.layoutOrder
	local sideMargin = self.props.sideMargin

	local shouldOnlyDisplayAvatarIcon = if fFlagLuaAppMoveProfileIntoTopBar then self.props.shouldOnlyDisplayAvatarIcon else nil

	local onlyAvatarButtonRef = if fFlagLuaAppMoveProfileIntoTopBar then self.props.onlyAvatarButtonRef else nil

	if localUserModel == nil then
		return nil
	end

	local v8 = not self.props.thumbnailSize and 36 or self.props.thumbnailSize

	local v9 = localUserModel.name

	if self.props.enableDisplayNamePolicy then
		v9 = localUserModel.displayName
	end

	local membership = localUserModel.membership
	local v10

	if getFFlagFixUserInfoWidgetPlusBadge() and fFlagEnableBlackbirdCheck then
		v10 = localUserModel.hasRobloxSubscription == true
	else
		v10 = nil
	end

	local v11

	if getFFlagFixUserInfoWidgetPlusBadge() then
		v11 = not fFlagHidePremiumIconography

		if v11 then
			v11 = membership == Enum.MembershipType.Premium and not v10
		end
	else
		v11 = membership == Enum.MembershipType.Premium
	end

	return withStyle(function(p2)
		local font = p2.Font
		local theme = p2.Theme
		local v12 = if self.props.usernameTextFont then self.props.usernameTextFont else font.Header1

		if foundationFontFaceMigration and not self.props.usernameTextFont then
			v12 = self.props.foundationTokens.Typography.HeadingSmall
		end

		local v13 = if self.props.usernameTextStyle then self.props.usernameTextStyle else theme.TextEmphasis

		local font2 = v12.Font
		local v14 = if v12.FontSize then v12.FontSize else font.BaseSize * v12.RelativeSize
		local v15

		if getFFlagFixUserInfoWidgetPlusBadge() then
			v15 = (v11 or v10) and v7[Enum.MembershipType.Premium] or 0
		else
			v15 = membership == nil and 0 or v7[membership] or 0
		end

		local color = v13.Color
		local transparency = v13.Transparency
		local color2 = theme.PlaceHolder.Color
		local transparency2 = theme.PlaceHolder.Transparency
		local v16

		if foundationFontFaceMigration then
			v16 = getTextSize(v9, v14, font2, Vector2.new(10000, 10000))
		else
			v16 = text.GetTextBounds(v9, font2, v14, Vector2.new(10000, 10000))
		end

		local createElement = Roact.createElement
		local emojiWrapper = VerifiedBadges.EmojiWrapper
		local v17 = {
			size = UDim2.fromScale(0, 0),
			emoji = 0,
			color = 0,
			layoutOrder = 2,
			onActivated = 0
		}
		local v18 = if isPlayerVerified(Players.LocalPlayer) then VerifiedBadges.emoji.verified else not v11 and "" or VerifiedBadges.emoji.premium
		v17.emoji = v18

		local v19 = if v11 then theme.TextEmphasis.Color else nil
		v17.color = v19

		v17.onActivated = onActivated

		local createElement2 = Roact.createElement
		local v22 = {}
		v22.Size = UDim2.new(0, v16.X, 0, v16.Y)
		v22.BackgroundTransparency = 1
		v22.TextSize = v14
		v22.TextColor3 = color
		v22.TextTransparency = transparency
		v22.TextTruncate = Enum.TextTruncate.None
		v22.Font = if not foundationFontFaceMigration then font2 else nil
		local v24 = if foundationFontFaceMigration then normalizeFontFace(font2) else nil
		v22.FontFace = v24
		v22.Text = v9
		v22.TextXAlignment = Enum.TextXAlignment.Left
		local activated = Roact.Event.Activated
		v22[activated] = if not v6 then onActivated else nil
		v22.Selectable = not v6 and onActivated ~= nil
		local tag = React.Tag
		local v27 = if fFlagLuaAppAddTestIdsForArrow then getTestId("discovery-home-userinfo-username") else nil
		v22[tag] = v27
		local element = createElement(emojiWrapper, v17, {
			UsernameText = createElement2("TextButton", v22)
		})
		local v28

		if getFFlagFixUserInfoWidgetPlusBadge() and v10 then
			v28 = Roact.createElement(icon, {
				name = iconName.RobloxPlus,
				size = iconSize.Small,
				style = self.props.foundationTokens.Color.Content.Emphasis,
				LayoutOrder = 3
			})
		end

		local createElement3 = Roact.createElement

		local v30 = {
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			Size = UDim2.new(0, v8, 0, v8)
		}
		local v31 = if fFlagEnableNonFlyoutUncheckedBadge then Enum.AutomaticSize.X else nil
		v30.AutomaticSize = v31
		v30.BackgroundTransparency = 1
		v30.Text = ""
		v30.LayoutOrder = 1
		v30[Roact.Event.Activated] = onActivated
		local ref = Roact.Ref
		v30[ref] = if fFlagLuaAppMoveProfileIntoTopBar then onlyAvatarButtonRef else nil
		local v33 = if module3() then self.props.selectable else nil
		v30.Selectable = v33
		local tag2 = React.Tag
		local v34 = if fFlagLuaAppAddTestIdsForArrow then getTestId("discovery-home-userinfo-avatar") else nil
		v30[tag2] = v34
		local v35

		if fFlagLuaAppMoveProfileIntoTopBar and shouldOnlyDisplayAvatarIcon then
			v35 = {
				UserAvatar = self:renderUserAvatar(v8, color2, transparency2, localUserModel)
			}
		else
			v35 = {
				nil,
				HorizontalLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 12)
				}),
				UserAvatar = self:renderUserAvatar(v8, color2, transparency2, localUserModel)
			}
			local v36

			if fFlagEnableNonFlyoutUncheckedBadge then
				local createElement4 = Roact.createElement

				if not getFFlagFixUserInfoWidgetPlusBadge() then
					v28 = nil
				end

				v36 = createElement4(
					view,
					{ tag = "row align-y-center gap-xsmall auto-xy", LayoutOrder = 2 },
					{ Username = element, MembershipIcon = v28 }
				)
			else
				local createElement4 = Roact.createElement
				local v38 = {
					Size = UDim2.new(0, v16.X + v15 + 4, 0, v16.Y),
					AutomaticSize = Enum.AutomaticSize.None,
					BackgroundTransparency = 1,
					LayoutOrder = 2
				}

				local v39 = {
					HorizontalLayout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 4)
					}),
					Username = element,
					MembershipIcon = 0
				}

				if not getFFlagFixUserInfoWidgetPlusBadge() then
					v28 = nil
				end

				v39.MembershipIcon = v28
				v36 = createElement4("Frame", v38, v39)
			end

			v35[1] = v36
		end

		local element2 = createElement3("TextButton", v30, v35)

		if fFlagEnableNonFlyoutUncheckedBadge then
			return Roact.createElement(view, {
				tag = "row align-y-center gap-small size-full-0 auto-y",
				LayoutOrder = layoutOrder,
				padding = {
					left = UDim.new(0, sideMargin),
					right = UDim.new(0, sideMargin)
				}
			}, {
				UsernameAvatarFrame = element2,
				UncheckedBadge = Roact.createElement(module4, { layoutOrder = 2 })
			})
		end

		return Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				LayoutOrder = layoutOrder,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{
				UIPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, sideMargin),
					PaddingRight = UDim.new(0, sideMargin)
				}),
				UsernameAvatarFrame = element2
			}
		)
	end)
end

local fn = (foundationFontFaceMigration or getFFlagFixUserInfoWidgetPlusBadge()) and function(p2)
	local v8 = useTokens()
	return Roact.createElement(extended, Cryo.Dictionary.join(p2, {
		foundationTokens = v8
	}))
end or extended

return roactAppPolicy.connect(function(p2, p3)
	return { enableDisplayNamePolicy = p2.getShowDisplayName() }
end)(fn)
