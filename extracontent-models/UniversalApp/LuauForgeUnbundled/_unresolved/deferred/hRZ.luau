local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local module = require("@luauforge/bundled/dFu")
local module2 = require("@luauforge/bundled/fwT")
local module3 = require("@luauforge/bundled/fAy")
local module4 = require("@luauforge/bundled/fAA")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local fFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local fFlagHidePremiumIconography = SharedFlags.FFlagHidePremiumIconography
local getFFlagFixUserInfoWidgetPlusBadge = SharedFlags.GetFFlagFixUserInfoWidgetPlusBadge

local defineFastFlag = game:DefineFastFlag("DisplayMorePageThirdPartyUserName2", false)
local defineFastFlag2 = game:DefineFastFlag("FixMorePageThirdPartyUserNameBug", false)
local v5, ThirdPartyUserService, Players, v6, isPlayerVerified, useAppPolicy

if defineFastFlag then
	v5 = require("@luauforge/deferred/hSa")
	ThirdPartyUserService = game:GetService("ThirdPartyUserService")
	Players = game:GetService("Players")
	v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/VerifiedBadges")
	isPlayerVerified = require("@luauforge/bundled/ciE").Utils.isPlayerVerified
	useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy
else
	useAppPolicy = nil
	ThirdPartyUserService = nil
	Players = nil
	isPlayerVerified = nil
	v6 = nil
	v5 = nil
end

return function()
	local v7 = useDesignTokens()
	local headingLarge = v7.Typography.HeadingLarge
	local emphasis = v7.Color.Content.Emphasis
	local size_800 = v7.Size.Size_800
	local titleHeight = v7.LuaApps.More.TitleHeight
	local userIconSize = v7.LuaApps.More.UserIconSize
	local usernameTextFont = v7.LuaApps.More.UsernameTextFont
	local usernameTextStyle = v7.LuaApps.More.UsernameTextStyle

	local v8 = useLocalization({ title = module2[module.More] })

	local v9 = useSelector(function(p2)
		return p2.Users[p2.LocalUserId]
	end)

	local id = nil
	local v10 = nil
	local userPlatformName = nil
	local v11 = nil
	local v12 = false

	if defineFastFlag then
		local v13

		if defineFastFlag2 then
			v13 = useAppPolicy(function(p2)
				return p2.getShowDisplayName()
			end)
		end

		if ThirdPartyUserService and ThirdPartyUserService:IsSingleSignOnSupported() then
			userPlatformName = ThirdPartyUserService:GetUserPlatformName()
		end

		if v9 then
			if not defineFastFlag2 then
				v13 = useAppPolicy(function(p2)
					return p2.getShowDisplayName()
				end)
			end

			id = v9.id
			v10 = if v13 then v9.displayName else v9.name
			local localPlayer = Players.LocalPlayer

			if localPlayer then
				local v14 = v9.membership == Enum.MembershipType.Premium
				local hasRobloxSubscription = v9.hasRobloxSubscription == true
				local fFlagFixUserInfoWidgetPlusBadge = getFFlagFixUserInfoWidgetPlusBadge()
				local v17 = v14
					and not (fFlagFixUserInfoWidgetPlusBadge and fFlagEnableBlackbirdCheck and hasRobloxSubscription)
					and not (fFlagFixUserInfoWidgetPlusBadge and fFlagHidePremiumIconography)

				if isPlayerVerified({
					DisplayName = localPlayer.DisplayName,
					Name = localPlayer.Name,
					HasVerifiedBadge = localPlayer.HasVerifiedBadge,
					UserId = localPlayer.UserId
				}) then
					v11 = v6.emoji.verified
				else
					v11 = not v17 and "" or v6.emoji.premium
				end

				v12 = fFlagFixUserInfoWidgetPlusBadge
					and fFlagEnableBlackbirdCheck
					and hasRobloxSubscription
			end
		end
	end

	local createElement = React.createElement
	local v14 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1
	}

	local v15 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, size_800)
		}),
		TitleFrame = React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, titleHeight),
				BackgroundTransparency = 1,
				LayoutOrder = 1
			},
			{
				Title = React.createElement("TextLabel", {
					Size = UDim2.new(1, 0, 1, 0),
					Text = v8.title,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1,
					FontFace = normalizeFontFace(headingLarge.Font),
					TextSize = headingLarge.FontSize,
					TextColor3 = emphasis.Color3,
					TextTransparency = emphasis.Transparency
				})
			}
		),
		UserInfo = 0
	}
	local v16

	if defineFastFlag then
		v16 = React.createElement(v5, {
			layoutOrder = 2,
			userId = id,
			userName = v10,
			userBadgeEmoji = v11,
			showRobloxPlusBadge = v12,
			thirdPartyUserName = userPlatformName,
			thirdPartyPlatformIcon = "rbxasset://textures/ui/Shell/Icons/PlatformLogo.png"
		})
	else
		local createElement2 = React.createElement

		local v19 = if module4() then false else nil
		v16 = createElement2(module3, {
			layoutOrder = 2,
			localUserModel = v9,
			onActivated = nil,
			selectable = v19,
			sideMargin = v7.Size.Size_300,
			thumbnailSize = userIconSize,
			usernameTextFont = usernameTextFont,
			usernameTextStyle = usernameTextStyle
		})
	end

	v15.UserInfo = v16
	return createElement("Frame", v14, v15)
end
