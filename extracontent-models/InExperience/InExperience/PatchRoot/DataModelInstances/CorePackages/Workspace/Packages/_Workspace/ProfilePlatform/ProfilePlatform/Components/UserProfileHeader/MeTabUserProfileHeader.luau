local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local UIBlox = require(parent.UIBlox)
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin

local UserTile = require(parent.UserTile)
local userTile = UserTile.UserTile
local UserTile2 = require(parent.UserTile)
local LayoutMode = UserTile2.LayoutMode

local Enums = require(ProfilePlatform.Common.Enums)
local Constants = require(ProfilePlatform.Common.Constants)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)

local SocialChipCountsRow = require(ProfilePlatform.Components.UserProfileHeader.SocialChipCountsRow)
local SocialChipCountsRowContainer = SocialChipCountsRow.SocialChipCountsRowContainer
local CTARow = require(ProfilePlatform.Components.CTARow)

local SharedFlags = require(parent.SharedFlags)

local FFlagEnableFontStylisticAlternativesOnSocialScreens = SharedFlags.FFlagEnableFontStylisticAlternativesOnSocialScreens
local FFlagEnableSocialTabsPage = SharedFlags.FFlagEnableSocialTabsPage

local function MeTabUserProfileHeader(p)
	local v = useTokens()
	local v2 = useProfileWrapperContext()
	local v3 = useProfileFormFactor()

	local profileId = v2.profileId
	local v4 = v3.formFactor == Enums.ProfileFormFactor.Wide

	local v5 = useProfileJsonComponent(Enums.Components.UserProfileHeader) or {}
	local names = v5.names or {}
	local username = names.username or ""
	local v6 = v5.counts ~= nil
	local subtitle

	if username ~= "" then
		if FFlagEnableFontStylisticAlternativesOnSocialScreens then
			subtitle = `<font features="zero, ss03">@{username}</font>`
		else
			subtitle = "@" .. username
		end
	end

	local v7 = v4 and 128 or Constants.AVATAR_HEADSHOT_HEIGHT
	local createElement = React.createElement
	local v8 = {
		tag = {
			grow = v4,
			["size-full-0"] = not v4
		},
		Size = 0,
		LayoutOrder = 1
	}
	local size

	if v4 then
		size = UDim2.fromOffset(0, v7)
	else
		size = UDim2.new(1, 0, 0, v7)
	end

	v8.Size = size

	local createElement2 = React.createElement
	local v9 = {
		userId = profileId,
		title = names.primaryName or "",
		subtitle = subtitle,
		isPremium = v5.isPremium,
		isVerified = v5.isVerified,
		isRobloxAdmin = v5.isRobloxAdmin,
		layoutMode = LayoutMode.wide,
		userPresenceType = nil,
		titleStyle = 0,
		subtitleStyle = 0
	}
	local titleStyle

	if v4 then
		titleStyle = v.Typography.HeadingLarge
	else
		titleStyle = v.Typography.HeadingSmall
	end

	v9.titleStyle = titleStyle
	local subtitleStyle

	if v4 then
		subtitleStyle = v.Typography.BodyLarge
	else
		subtitleStyle = v.Typography.BodyMedium
	end

	v9.subtitleStyle = subtitleStyle
	local element = createElement(View, v8, { UserTile = createElement2(userTile, v9) })

	local element2 = React.createElement(View, {
		tag = {
			["grow auto-y"] = v4,
			["size-full-0 auto-y"] = not v4
		},
		LayoutOrder = 2
	}, {
		Actions = React.createElement(CTARow, { layoutOrder = 1 })
	})

	local createElement3 = React.createElement
	local v10 = {
		tag = {
			["col size-full-0 auto-y"] = true,
			["gap-xxlarge"] = v4,
			["gap-large"] = not v4
		},
		LayoutOrder = p.layoutOrder
	}
	local v11 = {
		HeaderBlock = React.createElement(
			HorizontalPageMargin,
			{
				size = UDim2.new(1, 0, 0, 0),
				backgroundTransparency = 1,
				useAutomaticSizing = true,
				layoutOrder = 1
			},
			{
				Row = React.createElement(View, {
					tag = {
						["row align-y-center gap-medium size-full-0 auto-y"] = v4,
						["col gap-medium size-full-0 auto-y"] = not v4
					}
				}, { Identity = element, Actions = element2 })
			}
		),
		SocialCountsRow = 0
	}
	local socialCountsRow

	if v6 then
		local createElement4 = React.createElement
		local v12 = { size = UDim2.fromScale(1, 0), layoutOrder = 2, title = 0 }
		local title

		if FFlagEnableSocialTabsPage then
			title = `@{username}`
		end

		v12.title = title
		socialCountsRow = createElement4(SocialChipCountsRowContainer, v12)
	end

	v11.SocialCountsRow = socialCountsRow
	return createElement3(View, v10, v11)
end

return MeTabUserProfileHeader
