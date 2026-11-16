local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local ApolloProfileInsights = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ApolloProfileInsights")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useAreWebViewsSupported = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useAreWebViewsSupported")
local chipGroup = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ChipGroup").ChipGroup

local useLocalUserId = RobloxAppHooks.useLocalUserId
local useProfileInsightsByUserIds = ApolloProfileInsights.Hooks.useProfileInsightsByUserIds
local getProfileInsightsByUserIdFromData = ApolloProfileInsights.Selectors.getProfileInsightsByUserIdFromData
local useSignalProfileInsightsByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfileInsights").useSignalProfileInsightsByUserId

local getFFlagEnableProfileInsightsApolloMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").GetFFlagEnableProfileInsightsApolloMigration

local useSocialCountsData = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/SocialChipCountsRow/hooks/useSocialCountsData")
local useSocialCountsActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/SocialChipCountsRow/hooks/useSocialCountsActions")
local useSchoolChip = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/SocialChipCountsRow/hooks/useSchoolChip")
local useDynamicSizeMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useDynamicSizeMargin")

local chipSize = Foundation.Enums.ChipSize

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local fFlagAddIEMProfilePage = SharedFlags.FFlagAddIEMProfilePage
local fFlagEnableSocialTabsPage = SharedFlags.FFlagEnableSocialTabsPage
local fFlagProfilePlatformEnableSchoolChip = SharedFlags.FFlagProfilePlatformEnableSchoolChip
local FFlagProfilePlatformGracefulVisibility = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformGracefulVisibility")
local FFlagSocialTabsPageIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagSocialTabsPageIxpEnabled")

local function SocialCountsChipRowContainer(props)
	local v5 = useProfileWrapperContext()
	local v6 = useProfileAnalyticsContext()
	local v7 = useAreWebViewsSupported()
	local v8 = useLocalUserId()
	local v9, v10 = useDynamicSizeMargin()

	local profileId = v5.profileId
	local source = if fFlagAddIEMProfilePage then v5.sourceInfo.source else nil
	local v11 = profileId == tostring(v8)

	local v12 = nil

	if getFFlagEnableProfileInsightsApolloMigration() then
		v12 = useSignalProfileInsightsByUserId({
			userId = profileId,
			rankingStrategy = "tc_info_boost"
		})
	else
		local v13 = useProfileInsightsByUserIds({
			userIds = { profileId }
		})

		if v13 and v13.data and not v13.loading then
			v12 = getProfileInsightsByUserIdFromData(v13.data, profileId)
		end
	end

	local v13 = not (v12 and v12.mutualFriends) and {} or v12.mutualFriends

	local ids = {}

	for i, v14 in ipairs(v13) do
		table.insert(ids, v14.id)
	end

	local v14 = useSocialCountsData(profileId, v11, v7, ids)

	local title = if fFlagEnableSocialTabsPage then props.title else nil

	if not FFlagSocialTabsPageIxpEnabled then
		v7 = nil
	end

	local v16 = useSocialCountsActions(profileId, v11, v6, ids, title, v7)

	local v17 = if fFlagProfilePlatformEnableSchoolChip then useSchoolChip(v6) else nil

	local v18 = React.useMemo(function()
		local result = {}

		local v19 = fFlagAddIEMProfilePage and source == Enums.Sources.InExperienceProfile

		if fFlagProfilePlatformEnableSchoolChip and v17 and not v19 then
			table.insert(result, v17)
		end

		for i, v20 in ipairs(v14) do
			if not (v20.fieldName ~= "mutualFriendsCount" or tonumber(v20.count) ~= 0) then
				continue
			end

			local v21 = FFlagProfilePlatformGracefulVisibility

			if v21 then
				v21 = v20.fieldName == "friendsCount" and v20.isDisabled
			end

			local v22 = {
				count = v20.count,
				text = v20.text,
				layoutOrder = v20.layoutOrder,
				onActivated = 0,
				isDisabled = 0,
				size = 0,
				leading = 0
			}

			local v23 = if not v21 and (not fFlagAddIEMProfilePage or source ~= Enums.Sources.InExperienceProfile) then v16[v20.fieldName] else nil
			v22.onActivated = v23

			v22.isDisabled = v20.isDisabled
			v22.size = chipSize.Medium
			v22.leading = v20.leading
			table.insert(result, v22)
		end

		return result
	end, { v14, v16, v17, source })

	return React.createElement("Frame", {
		LayoutOrder = props.layoutOrder,
		Size = props.size,
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = v10,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v9),
			PaddingRight = UDim.new(0, v9)
		}),
		ChipGroup = React.createElement(chipGroup, {
			chips = v18,
			automaticSize = Enum.AutomaticSize.Y,
			scrollingEnabledOverride = true,
			size = UDim2.new(1, 0, 0, 32),
			layoutOrder = props.layoutOrder
		})
	})
end

return SocialCountsChipRowContainer
