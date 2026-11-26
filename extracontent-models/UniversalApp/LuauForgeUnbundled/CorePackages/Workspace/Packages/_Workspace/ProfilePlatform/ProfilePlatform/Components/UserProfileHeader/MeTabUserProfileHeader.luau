local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local horizontalPageMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox").App.Container.HorizontalPageMargin

local userTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserTile").UserTile
local layoutMode = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserTile").LayoutMode

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useProfileFormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileFormFactor")

local socialChipCountsRowContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/SocialChipCountsRow").SocialChipCountsRowContainer
local CTARow = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")

local fFlagEnableFontStylisticAlternativesOnSocialScreens = SharedFlags.FFlagEnableFontStylisticAlternativesOnSocialScreens
local fFlagEnableSocialTabsPage = SharedFlags.FFlagEnableSocialTabsPage

local function MeTabUserProfileHeader(p2)
	local v5 = useTokens()
	local v6 = useProfileWrapperContext()
	local v7 = useProfileFormFactor()

	local profileId = v6.profileId
	local v8 = v7.formFactor == Enums.ProfileFormFactor.Wide

	local v9 = useProfileJsonComponent(Enums.Components.UserProfileHeader) or {}
	local names = v9.names or {}
	local username = names.username or ""
	local v10 = v9.counts ~= nil
	local v11

	if username ~= "" then
		if fFlagEnableFontStylisticAlternativesOnSocialScreens then
			v11 = `<font features="zero, ss03">@{username}</font>`
		else
			v11 = "@" .. username
		end
	end

	local v12 = v8 and 128 or Constants.AVATAR_HEADSHOT_HEIGHT
	local createElement = React.createElement

	local v15 = if v8 then UDim2.fromOffset(0, v12) else UDim2.new(1, 0, 0, v12)

	local createElement2 = React.createElement
	local v18 = {
		userId = profileId,
		title = names.primaryName or "",
		subtitle = v11,
		isPremium = v9.isPremium,
		isVerified = v9.isVerified,
		isRobloxAdmin = v9.isRobloxAdmin,
		layoutMode = layoutMode.wide,
		userPresenceType = nil,
		titleStyle = 0,
		subtitleStyle = 0
	}

	local v19 = if v8 then v5.Typography.HeadingLarge else v5.Typography.HeadingSmall
	v18.titleStyle = v19
	local v20 = if v8 then v5.Typography.BodyLarge else v5.Typography.BodyMedium
	v18.subtitleStyle = v20
	local element = createElement(view, {
		tag = {
			grow = v8,
			["size-full-0"] = not v8
		},
		Size = v15,
		LayoutOrder = 1
	}, { UserTile = createElement2(userTile, v18) })

	local element2 = React.createElement(view, {
		tag = {
			["grow auto-y"] = v8,
			["size-full-0 auto-y"] = not v8
		},
		LayoutOrder = 2
	}, {
		Actions = React.createElement(CTARow, { layoutOrder = 1 })
	})

	local createElement3 = React.createElement
	local v22 = {
		tag = {
			["col size-full-0 auto-y"] = true,
			["gap-xxlarge"] = v8,
			["gap-large"] = not v8
		},
		LayoutOrder = p2.layoutOrder
	}
	local v23 = {
		HeaderBlock = React.createElement(
			horizontalPageMargin,
			{
				size = UDim2.new(1, 0, 0, 0),
				backgroundTransparency = 1,
				useAutomaticSizing = true,
				layoutOrder = 1
			},
			{
				Row = React.createElement(view, {
					tag = {
						["row align-y-center gap-medium size-full-0 auto-y"] = v8,
						["col gap-medium size-full-0 auto-y"] = not v8
					}
				}, { Identity = element, Actions = element2 })
			}
		),
		SocialCountsRow = 0
	}
	local v24

	if v10 then
		local createElement4 = React.createElement
		local v26 = { size = UDim2.fromScale(1, 0), layoutOrder = 2, title = 0 }

		local v27 = if fFlagEnableSocialTabsPage then `@{username}` else nil
		v26.title = v27
		v24 = createElement4(socialChipCountsRowContainer, v26)
	end

	v23.SocialCountsRow = v24
	return createElement3(view, v22, v23)
end

return MeTabUserProfileHeader
