local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local AppPageLocalizationKeys = require(Modules.LuaApp.AppPageLocalizationKeys)
local UserInfoWidget = require(Modules.LuaApp.Components.Home.UserInfoWidget)
local GetFFlagFixUserInfoSelection = require(Modules.LuaApp.Flags.GetFFlagFixUserInfoSelection)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagHidePremiumIconography = SharedFlags.FFlagHidePremiumIconography
local GetFFlagFixUserInfoWidgetPlusBadge = SharedFlags.GetFFlagFixUserInfoWidgetPlusBadge
local v15 = game:DefineFastFlag("DisplayMorePageThirdPartyUserName2", false)
local v16 = game:DefineFastFlag("FixMorePageThirdPartyUserNameBug", false)
local ThirdPartyLinkedUserInfoWidget = nil
local ThirdPartyUserService = nil
local Players = nil
local VerifiedBadges = nil
local isPlayerVerified = nil
local useAppPolicy = nil

if v15 then
	ThirdPartyLinkedUserInfoWidget = require(Modules.LuaApp.Components.More.ThirdPartyLinkedUserInfoWidget)
	ThirdPartyUserService = game:GetService("ThirdPartyUserService")
	Players = game:GetService("Players")
	VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges)
	isPlayerVerified = require(CorePackages.Workspace.Packages.UserLib).Utils.isPlayerVerified
	useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
end

return function() -- line: 33
	-- upvalues: useDesignTokens (copy), useLocalization (copy), AppPageLocalizationKeys (copy), AppPage (copy), useSelector (copy), v15 (copy), v16 (copy), useAppPolicy (ref), ThirdPartyUserService (ref), Players (ref), GetFFlagFixUserInfoWidgetPlusBadge (copy), FFlagEnableBlackbirdCheck (copy), FFlagHidePremiumIconography (copy), isPlayerVerified (ref), VerifiedBadges (ref), React (copy), ThirdPartyLinkedUserInfoWidget (ref), UserInfoWidget (copy), GetFFlagFixUserInfoSelection (copy)
	local v23 = useDesignTokens()
	local HeadingLarge = v23.Typography.HeadingLarge
	local Emphasis = v23.Color.Content.Emphasis
	local Size_800 = v23.Size.Size_800
	local TitleHeight = v23.LuaApps.More.TitleHeight
	local UserIconSize = v23.LuaApps.More.UserIconSize
	local UsernameTextFont = v23.LuaApps.More.UsernameTextFont
	local UsernameTextStyle = v23.LuaApps.More.UsernameTextStyle
	local v31 = useLocalization({
		title = AppPageLocalizationKeys[AppPage.More]
	})
	local v32 = useSelector(function(p1) -- line: 47
		return p1.Users[p1.LocalUserId]
	end)
	local id = nil
	local v34 = nil
	local UserPlatformName = nil
	local v36 = nil
	local v37 = false

	if v15 then
		local v38 = if not v16 then nil else useAppPolicy(function(p2) -- line: 55
			return p2.getShowDisplayName()
		end)

		if ThirdPartyUserService and ThirdPartyUserService:IsSingleSignOnSupported() then
			UserPlatformName = ThirdPartyUserService:GetUserPlatformName()
		end

		if v32 then
			if not v16 then
				v38 = useAppPolicy(function(p3) -- line: 66
					return p3.getShowDisplayName()
				end)
			end

			id = v32.id
			v34 = if not v38 then v32.name else v32.displayName

			local LocalPlayer = Players.LocalPlayer

			if LocalPlayer then
				local v40 = v32.membership == Enum.MembershipType.Premium
				local v41 = v32.hasRobloxSubscription == true
				local v42 = GetFFlagFixUserInfoWidgetPlusBadge()
				local v43 = v42 and (FFlagEnableBlackbirdCheck and v41)
				local v44 = v42 and FFlagHidePremiumIconography
				local v45 = v40 and (not v43 and not v44)

				v36 = if not isPlayerVerified({
					DisplayName = LocalPlayer.DisplayName,
					Name = LocalPlayer.Name,
					HasVerifiedBadge = LocalPlayer.HasVerifiedBadge,
					UserId = LocalPlayer.UserId
				}) then not v45 and "" or VerifiedBadges.emoji.premium else VerifiedBadges.emoji.verified
				v37 = v42 and (FFlagEnableBlackbirdCheck and v41)
			end
		end
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, Size_800)
		}),
		TitleFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, TitleHeight)
		}, {
			Title = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Text = v31.title,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = HeadingLarge.Font,
				TextSize = HeadingLarge.FontSize,
				TextColor3 = Emphasis.Color3,
				TextTransparency = Emphasis.Transparency
			})
		}),
		UserInfo = if not v15 then React.createElement(UserInfoWidget, {
			layoutOrder = 2,
			onActivated = nil,
			localUserModel = v32,
			selectable = not GetFFlagFixUserInfoSelection() and nil,
			sideMargin = v23.Size.Size_300,
			thumbnailSize = UserIconSize,
			usernameTextFont = UsernameTextFont,
			usernameTextStyle = UsernameTextStyle
		}) else React.createElement(ThirdPartyLinkedUserInfoWidget, {
			layoutOrder = 2,
			thirdPartyPlatformIcon = "rbxasset://textures/ui/Shell/Icons/PlatformLogo.png",
			userId = id,
			userName = v34,
			userBadgeEmoji = v36,
			showRobloxPlusBadge = v37,
			thirdPartyUserName = UserPlatformName
		})
	})
end
