local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local HorizontalPageMargin = require(ProfilePlatformParent.UIBlox).App.Container.HorizontalPageMargin
local UserTile = require(ProfilePlatformParent.UserTile).UserTile
local LayoutMode = require(ProfilePlatformParent.UserTile).LayoutMode
local Enums = require(ProfilePlatform.Common.Enums)
local Constants = require(ProfilePlatform.Common.Constants)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local SocialChipCountsRowContainer = require(ProfilePlatform.Components.UserProfileHeader.SocialChipCountsRow).SocialChipCountsRowContainer
local ProfileActionBar = require(ProfilePlatform.Components.ProfileActionBar)
local CTARow = require(ProfilePlatform.Components.CTARow)
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
local FFlagEnableFontStylisticAlternativesOnSocialScreens = SharedFlags.FFlagEnableFontStylisticAlternativesOnSocialScreens
local FFlagEnableSocialTabsPage = SharedFlags.FFlagEnableSocialTabsPage
local v21 = if not require(ProfilePlatform.Flags.FFlagProfilePlatformCTAsRefactor) then ProfileActionBar else CTARow

local function MeTabUserProfileHeader(t1: {[any]: any}) -- line: 57
	-- upvalues: useTokens (copy), useProfileWrapperContext (copy), useProfileFormFactor (copy), Enums (copy), useProfileJsonComponent (copy), FFlagEnableFontStylisticAlternativesOnSocialScreens (copy), Constants (copy), React (copy), View (copy), UserTile (copy), LayoutMode (copy), v21 (copy), HorizontalPageMargin (copy), SocialChipCountsRowContainer (copy), FFlagEnableSocialTabsPage (copy)
	local v24 = useTokens()
	local v25 = useProfileWrapperContext()
	local v26 = useProfileFormFactor()
	local profileId = v25.profileId
	local v28 = v26.formFactor == Enums.ProfileFormFactor.Wide
	local v29 = useProfileJsonComponent(Enums.Components.UserProfileHeader) or {}
	local v30 = v29.names or {}
	local v31 = v30.username or ""
	local v32 = v29.counts ~= nil
	local v33 = if v31 == "" then nil else if not FFlagEnableFontStylisticAlternativesOnSocialScreens then "@" .. v31 else `<font features="zero, ss03">@{ v31 }</font>`
	local v34 = if not v28 then Constants.AVATAR_HEADSHOT_HEIGHT else 128
	local v35 = React.createElement(View, {
		LayoutOrder = 1,
		tag = {
			grow = v28,
			["size-full-0"] = not v28
		},
		Size = if not v28 then UDim2.new(1, 0, 0, v34) else UDim2.fromOffset(0, v34)
	}, {
		UserTile = React.createElement(UserTile, {
			userPresenceType = nil,
			userId = profileId,
			title = v30.primaryName or "",
			subtitle = v33,
			isPremium = v29.isPremium,
			isVerified = v29.isVerified,
			isRobloxAdmin = v29.isRobloxAdmin,
			layoutMode = LayoutMode.wide,
			titleStyle = if not v28 then v24.Typography.HeadingSmall else v24.Typography.HeadingLarge,
			subtitleStyle = if not v28 then v24.Typography.BodyMedium else v24.Typography.BodyLarge
		})
	})
	local v36 = React.createElement(View, {
		LayoutOrder = 2,
		tag = {
			["grow auto-y"] = v28,
			["size-full-0 auto-y"] = not v28
		}
	}, {
		Actions = React.createElement(v21, {
			layoutOrder = 1
		})
	})

	return React.createElement(View, {
		tag = {
			["col size-full-0 auto-y"] = true,
			["gap-xxlarge"] = v28,
			["gap-large"] = not v28
		},
		LayoutOrder = t1.layoutOrder
	}, {
		HeaderBlock = React.createElement(HorizontalPageMargin, {
			backgroundTransparency = 1,
			useAutomaticSizing = true,
			layoutOrder = 1,
			size = UDim2.new(1, 0, 0, 0)
		}, {
			Row = React.createElement(View, {
				tag = {
					["row align-y-center gap-medium size-full-0 auto-y"] = v28,
					["col gap-medium size-full-0 auto-y"] = not v28
				}
			}, {
				Identity = v35,
				Actions = v36
			})
		}),
		SocialCountsRow = if not v32 then nil else React.createElement(SocialChipCountsRowContainer, {
			layoutOrder = 2,
			size = UDim2.fromScale(1, 0),
			title = if not FFlagEnableSocialTabsPage then nil else `@{ v31 }`
		})
	})
end

return MeTabUserProfileHeader
