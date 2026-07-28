local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local RobloxAppHooks = require(ProfilePlatformParent.RobloxAppHooks)

require(ProfilePlatform.Common.Types)

local Foundation = require(ProfilePlatformParent.Foundation)
local ApolloProfileInsights = require(ProfilePlatformParent.ApolloProfileInsights)
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useAreWebViewsSupported = require(ProfilePlatform.Hooks.useAreWebViewsSupported)
local ChipGroup = require(ProfilePlatform.Components.ChipGroup).ChipGroup
local useLocalUserId = RobloxAppHooks.useLocalUserId
local useProfileInsightsByUserIds = ApolloProfileInsights.Hooks.useProfileInsightsByUserIds
local getProfileInsightsByUserIdFromData = ApolloProfileInsights.Selectors.getProfileInsightsByUserIdFromData
local useSignalProfileInsightsByUserId = require(ProfilePlatformParent.ProfileInsights).useSignalProfileInsightsByUserId
local GetFFlagEnableProfileInsightsApolloMigration = require(ProfilePlatformParent.SharedFlags).GetFFlagEnableProfileInsightsApolloMigration
local scriptParent = script.Parent
local useSocialCountsData = require(scriptParent.hooks.useSocialCountsData)
local useSocialCountsActions = require(scriptParent.hooks.useSocialCountsActions)
local useSchoolChip = require(scriptParent.hooks.useSchoolChip)
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local ChipSize = Foundation.Enums.ChipSize
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
local FFlagAddIEMProfilePage = SharedFlags.FFlagAddIEMProfilePage
local FFlagEnableSocialTabsPage = SharedFlags.FFlagEnableSocialTabsPage
local FFlagProfilePlatformEnableSchoolChip = SharedFlags.FFlagProfilePlatformEnableSchoolChip

local function SocialCountsChipRowContainer(t1: {[any]: any}) -- line: 46
	-- upvalues: useProfileWrapperContext (copy), useProfileAnalyticsContext (copy), useAreWebViewsSupported (copy), useLocalUserId (copy), useDynamicSizeMargin (copy), FFlagAddIEMProfilePage (copy), GetFFlagEnableProfileInsightsApolloMigration (copy), useSignalProfileInsightsByUserId (copy), useProfileInsightsByUserIds (copy), getProfileInsightsByUserIdFromData (copy), useSocialCountsData (copy), useSocialCountsActions (copy), FFlagEnableSocialTabsPage (copy), FFlagProfilePlatformEnableSchoolChip (copy), useSchoolChip (copy), React (copy), Enums (copy), ChipSize (copy), ChipGroup (copy)
	local v29 = useProfileWrapperContext()
	local v30 = useProfileAnalyticsContext()
	local v31 = useAreWebViewsSupported()
	local v32 = useLocalUserId()
	local v33, v34 = useDynamicSizeMargin()
	local profileId = v29.profileId
	local v36 = if not FFlagAddIEMProfilePage then nil else v29.sourceInfo.source
	local v37 = profileId == tostring(v32)
	local v38 = nil

	if GetFFlagEnableProfileInsightsApolloMigration() then
		v38 = useSignalProfileInsightsByUserId({
			rankingStrategy = "tc_info_boost",
			userId = profileId
		})
	else
		local v39 = useProfileInsightsByUserIds({
			userIds = { profileId }
		})

		if v39 and v39.data and not v39.loading then
			v38 = getProfileInsightsByUserIdFromData(v39.data, profileId)
		end
	end

	local v40 = if not v38 or not v38.mutualFriends then {} else v38.mutualFriends
	local t2 = {}

	for _, v in ipairs(v40) do
		table.insert(t2, v.id)
	end

	local v44 = useSocialCountsData(profileId, v37, v31, t2)
	local v45 = useSocialCountsActions(profileId, v37, v30, t2, if not FFlagEnableSocialTabsPage then nil else t1.title)
	local u46 = nil

	if FFlagProfilePlatformEnableSchoolChip then
		u46 = useSchoolChip(v30)
	end

	local v47 = React.useMemo(function() -- line: 99
		-- upvalues: FFlagAddIEMProfilePage (copy), v36 (copy), Enums (copy), FFlagProfilePlatformEnableSchoolChip (copy), u46 (ref), v44 (copy), v45 (copy), ChipSize (copy)
		local t3 = {}
		local v49 = FFlagAddIEMProfilePage and v36 == Enums.Sources.InExperienceProfile

		if FFlagProfilePlatformEnableSchoolChip and (u46 and not v49) then
			table.insert(t3, u46)
		end

		for _, v in ipairs(v44) do
			if v.fieldName ~= "mutualFriendsCount" or tonumber(v.count) ~= 0 then
				table.insert(t3, {
					count = v.count,
					text = v.text,
					layoutOrder = v.layoutOrder,
					onActivated = if not FFlagAddIEMProfilePage or v36 ~= Enums.Sources.InExperienceProfile then v45[v.fieldName] else nil,
					isDisabled = v.isDisabled,
					size = ChipSize.Medium,
					leading = v.leading
				})
			end
		end

		return t3
	end, {
		v44,
		v45,
		u46,
		v36
	})

	return React.createElement("Frame", {
		LayoutOrder = t1.layoutOrder,
		Size = t1.size,
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = v34,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v33),
			PaddingRight = UDim.new(0, v33)
		}),
		ChipGroup = React.createElement(ChipGroup, {
			scrollingEnabledOverride = true,
			chips = v47,
			automaticSize = Enum.AutomaticSize.Y,
			size = UDim2.new(1, 0, 0, 32),
			layoutOrder = t1.layoutOrder
		})
	})
end

return SocialCountsChipRowContainer
