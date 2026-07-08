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
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local ChipSize = Foundation.Enums.ChipSize
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
local FFlagAddIEMProfilePage = SharedFlags.FFlagAddIEMProfilePage
local FFlagEnableSocialTabsPage = SharedFlags.FFlagEnableSocialTabsPage

local function SocialCountsChipRowContainer(t1: {[any]: any}) -- line: 44
	-- upvalues: useProfileWrapperContext (copy), useProfileAnalyticsContext (copy), useAreWebViewsSupported (copy), useLocalUserId (copy), useDynamicSizeMargin (copy), FFlagAddIEMProfilePage (copy), GetFFlagEnableProfileInsightsApolloMigration (copy), useSignalProfileInsightsByUserId (copy), useProfileInsightsByUserIds (copy), getProfileInsightsByUserIdFromData (copy), useSocialCountsData (copy), useSocialCountsActions (copy), FFlagEnableSocialTabsPage (copy), React (copy), Enums (copy), ChipSize (copy), ChipGroup (copy)
	local v27 = useProfileWrapperContext()
	local v28 = useProfileAnalyticsContext()
	local v29 = useAreWebViewsSupported()
	local v30 = useLocalUserId()
	local v31, v32 = useDynamicSizeMargin()
	local profileId = v27.profileId
	local v34 = if not FFlagAddIEMProfilePage then nil else v27.sourceInfo.source
	local v35 = profileId == tostring(v30)
	local v36 = nil

	if GetFFlagEnableProfileInsightsApolloMigration() then
		v36 = useSignalProfileInsightsByUserId({
			rankingStrategy = "tc_info_boost",
			userId = profileId
		})
	else
		local v37 = useProfileInsightsByUserIds({
			userIds = { profileId }
		})

		if v37 and v37.data and not v37.loading then
			v36 = getProfileInsightsByUserIdFromData(v37.data, profileId)
		end
	end

	local v38 = if not v36 or not v36.mutualFriends then {} else v36.mutualFriends
	local t2 = {}

	for _, v in ipairs(v38) do
		table.insert(t2, v.id)
	end

	local v42 = useSocialCountsData(profileId, v35, v29, t2)
	local v43 = useSocialCountsActions(profileId, v35, v28, t2, if not FFlagEnableSocialTabsPage then nil else t1.title)
	local v44 = React.useMemo(function() -- line: 92
		-- upvalues: v42 (copy), FFlagAddIEMProfilePage (copy), v34 (copy), Enums (copy), v43 (copy), ChipSize (copy)
		local t3 = {}

		for _, v in ipairs(v42) do
			if v.fieldName ~= "mutualFriendsCount" or tonumber(v.count) ~= 0 then
				table.insert(t3, {
					count = v.count,
					text = v.text,
					layoutOrder = v.layoutOrder,
					onActivated = if not FFlagAddIEMProfilePage or v34 ~= Enums.Sources.InExperienceProfile then v43[v.fieldName] else nil,
					isDisabled = v.isDisabled,
					size = ChipSize.Medium,
					leading = v.leading
				})
			end
		end

		return t3
	end, {
		v42,
		v43
	})

	return React.createElement("Frame", {
		LayoutOrder = t1.layoutOrder,
		Size = t1.size,
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = v32,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v31),
			PaddingRight = UDim.new(0, v31)
		}),
		ChipGroup = React.createElement(ChipGroup, {
			scrollingEnabledOverride = true,
			chips = v44,
			automaticSize = Enum.AutomaticSize.Y,
			size = UDim2.new(1, 0, 0, 32),
			layoutOrder = t1.layoutOrder
		})
	})
end

return SocialCountsChipRowContainer
