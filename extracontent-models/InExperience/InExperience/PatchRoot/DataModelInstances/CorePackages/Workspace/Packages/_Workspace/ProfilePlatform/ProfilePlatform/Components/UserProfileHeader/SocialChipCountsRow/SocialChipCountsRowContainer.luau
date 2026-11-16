local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
require(ProfilePlatform.Common.Types)
local Foundation = require(parent.Foundation)
local ApolloProfileInsights = require(parent.ApolloProfileInsights)

local Enums = require(ProfilePlatform.Common.Enums)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useAreWebViewsSupported = require(ProfilePlatform.Hooks.useAreWebViewsSupported)
local ChipGroup = require(ProfilePlatform.Components.ChipGroup)
local chipGroup = ChipGroup.ChipGroup

local useLocalUserId = RobloxAppHooks.useLocalUserId
local useProfileInsightsByUserIds = ApolloProfileInsights.Hooks.useProfileInsightsByUserIds
local getProfileInsightsByUserIdFromData = ApolloProfileInsights.Selectors.getProfileInsightsByUserIdFromData
local ProfileInsights = require(parent.ProfileInsights)
local useSignalProfileInsightsByUserId = ProfileInsights.useSignalProfileInsightsByUserId

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableProfileInsightsApolloMigration = SharedFlags.GetFFlagEnableProfileInsightsApolloMigration

local parent2 = script.Parent
local useSocialCountsData = require(parent2.hooks.useSocialCountsData)
local useSocialCountsActions = require(parent2.hooks.useSocialCountsActions)
local useSchoolChip = require(parent2.hooks.useSchoolChip)
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)

local ChipSize = Foundation.Enums.ChipSize

local SharedFlags2 = require(parent.SharedFlags)
local FFlagAddIEMProfilePage = SharedFlags2.FFlagAddIEMProfilePage
local FFlagEnableSocialTabsPage = SharedFlags2.FFlagEnableSocialTabsPage
local FFlagProfilePlatformEnableSchoolChip = SharedFlags2.FFlagProfilePlatformEnableSchoolChip
local FFlagProfilePlatformGracefulVisibility = require(ProfilePlatform.Flags.FFlagProfilePlatformGracefulVisibility)
local FFlagSocialTabsPageIxpEnabled = require(ProfilePlatform.Flags.FFlagSocialTabsPageIxpEnabled)

local function SocialCountsChipRowContainer(props)
	local v = useProfileWrapperContext()
	local v2 = useProfileAnalyticsContext()
	local v3 = useAreWebViewsSupported()
	local v4 = useLocalUserId()
	local v5, v6 = useDynamicSizeMargin()

	local profileId = v.profileId
	local source

	if FFlagAddIEMProfilePage then
		source = v.sourceInfo.source
	else
		source = nil
	end

	local v7 = profileId == tostring(v4)

	local v8 = nil

	if GetFFlagEnableProfileInsightsApolloMigration() then
		v8 = useSignalProfileInsightsByUserId({
			userId = profileId,
			rankingStrategy = "tc_info_boost"
		})
	else
		local v9 = useProfileInsightsByUserIds({
			userIds = { profileId }
		})

		if v9 and v9.data and not v9.loading then
			v8 = getProfileInsightsByUserIdFromData(v9.data, profileId)
		end
	end

	local v9 = not (v8 and v8.mutualFriends) and {} or v8.mutualFriends

	local ids = {}

	for _, v10 in ipairs(v9) do
		table.insert(ids, v10.id)
	end

	local v10 = useSocialCountsData(profileId, v7, v3, ids)
	local title

	if FFlagEnableSocialTabsPage then
		title = props.title
	end

	if not FFlagSocialTabsPageIxpEnabled then
		v3 = nil
	end

	local v11 = useSocialCountsActions(profileId, v7, v2, ids, title, v3)
	local v12

	if FFlagProfilePlatformEnableSchoolChip then
		v12 = useSchoolChip(v2)
	else
		v12 = nil
	end

	local chips = React.useMemo(function()
		local result = {}

		local v13 = FFlagAddIEMProfilePage and source == Enums.Sources.InExperienceProfile

		if FFlagProfilePlatformEnableSchoolChip and v12 and not v13 then
			table.insert(result, v12)
		end

		for _, v14 in ipairs(v10) do
			if not (v14.fieldName ~= "mutualFriendsCount" or tonumber(v14.count) ~= 0) then
				continue
			end

			local v15 = FFlagProfilePlatformGracefulVisibility

			if v15 then
				if v14.fieldName == "friendsCount" then
					v15 = v14.isDisabled
				else
					v15 = false
				end
			end

			local v16 = {
				count = v14.count,
				text = v14.text,
				layoutOrder = v14.layoutOrder,
				onActivated = 0,
				isDisabled = 0,
				size = 0,
				leading = 0
			}
			local onActivated

			if not (v15 or FFlagAddIEMProfilePage and source == Enums.Sources.InExperienceProfile) then
				onActivated = v11[v14.fieldName]
			end

			v16.onActivated = onActivated

			v16.isDisabled = v14.isDisabled
			v16.size = ChipSize.Medium
			v16.leading = v14.leading
			table.insert(result, v16)
		end

		return result
	end, { v10, v11, v12, source })

	return React.createElement("Frame", {
		LayoutOrder = props.layoutOrder,
		Size = props.size,
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = v6,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v5),
			PaddingRight = UDim.new(0, v5)
		}),
		ChipGroup = React.createElement(chipGroup, {
			chips = chips,
			automaticSize = Enum.AutomaticSize.Y,
			scrollingEnabledOverride = true,
			size = UDim2.new(1, 0, 0, 32),
			layoutOrder = props.layoutOrder
		})
	})
end

return SocialCountsChipRowContainer
