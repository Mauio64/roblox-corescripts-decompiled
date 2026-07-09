local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Cryo = require(ProfilePlatformParent.Cryo)
local React = require(ProfilePlatformParent.React)
local UserProfileHeader = require(ProfilePlatform.Components.UserProfileHeader)
local MeTabUserProfileHeader = require(ProfilePlatform.Components.UserProfileHeader.MeTabUserProfileHeader)
local About = require(ProfilePlatform.Components.About)
local ContactDescription = require(ProfilePlatform.Components.ContactDescription)
local ProfileActionBar = require(ProfilePlatform.Components.ProfileActionBar)
local CommunityProfileHeader = require(ProfilePlatform.Components.CommunityProfileHeader)
local CoverPhoto = require(ProfilePlatform.Components.CoverPhoto)
local CurrentlyWearing = require(ProfilePlatform.Components.CurrentlyWearing)
local Store = require(ProfilePlatform.Components.Store)
local ViewFullProfile = require(ProfilePlatform.Components.ViewFullProfile)
local Inventory = require(ProfilePlatform.Components.Inventory)
local FavoriteExperiences = require(ProfilePlatform.Components.FavoriteExperiences)
local ContactProfileHeader = require(ProfilePlatform.Components.ContactProfileHeader)
local Experiences = require(ProfilePlatform.Components.Experiences)
local ExperiencesWideCarousel = require(ProfilePlatform.Components.ExperiencesWideCarousel)
local SocialLinks = require(ProfilePlatform.Components.SocialLinks)
local Videos = require(ProfilePlatform.Components.Videos)
local CommunityLocked = require(ProfilePlatform.Components.CommunityLocked)
local Events = require(ProfilePlatform.Components.Events)
local ProfileCompletion = require(ProfilePlatform.Components.ProfileCompletion)
local CurrentlyPlaying = require(ProfilePlatform.Components.CurrentlyPlaying)
local CTARow = require(ProfilePlatform.Components.CTARow)
local Moments = require(ProfilePlatform.Components.Moments)
local Constants = require(ProfilePlatformParent.ProfilePlatform.Common.Constants)
local Enums = require(ProfilePlatformParent.ProfilePlatform.Common.Enums)
local getPeekViewOpenHeightByProfileType = require(ProfilePlatform.Utils.getPeekViewOpenHeightByProfileType)
local FFlagProfilePlatformEnableFavoriteExperiences = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableFavoriteExperiences)
local FFlagProfilePlatformEnableStore = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableStore
local FFlagAXEnableProfileTab = require(ProfilePlatformParent.SharedFlags).FFlagAXEnableProfileTab
local FFlagProfilePlatformEnableInventory = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableInventory
local FFlagAddSocialLinksToCommunityProfile = require(ProfilePlatformParent.SharedFlags).FFlagAddSocialLinksToCommunityProfile
local FFlagAddVideoToCommunityProfile = require(ProfilePlatformParent.SharedFlags).FFlagAddVideoToCommunityProfile
local FFlagAddCommunityLockedToCommunityProfile = require(ProfilePlatformParent.SharedFlags).FFlagAddCommunityLockedToCommunityProfile
local FFlagExperiencesOnProfile = require(ProfilePlatformParent.SharedFlags).FFlagExperiencesOnProfile
local FFlagEnableProfileCompletion = require(ProfilePlatformParent.SharedFlags).FFlagEnableProfileCompletion
local FFlagProfilePlatformEnableLazyLoadingComponents = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableLazyLoadingComponents)
local FFlagAddEventsToCommunityProfile = require(ProfilePlatform.Flags.FFlagAddEventsToCommunityProfile)
local FFlagProfilePlatformAddCurrentlyPlaying = require(ProfilePlatform.Flags.FFlagProfilePlatformAddCurrentlyPlaying)
local FFlagAboutBeforeActionClient = require(ProfilePlatform.Flags.FFlagAboutBeforeActionClient)
local FFlagProfilePlatformCTAsRefactor = require(ProfilePlatform.Flags.FFlagProfilePlatformCTAsRefactor)
local FFlagProfilePlatformEnableMoments = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableMoments)
local v46 = game:DefineFastFlag("FixCTARowOnContactProfile", false)

local function orderWithAboutBeforeActions(t1: {[any]: any}) -- line: 55
	-- upvalues: FFlagAboutBeforeActionClient (copy), Enums (copy), FFlagProfilePlatformAddCurrentlyPlaying (copy), Cryo (copy)
	if not FFlagAboutBeforeActionClient then
		return t1
	end

	local v54 = nil
	local v55 = nil
	local v56 = nil

	for i, v in ipairs(t1) do
		if v == Enums.Components.About then
			v54 = i
		elseif v == Enums.Components.Actions then
			v55 = i
		elseif FFlagProfilePlatformAddCurrentlyPlaying and v == Enums.Components.CurrentlyPlaying then
			v56 = i
		end
	end

	if v54 == nil or v55 == nil or v54 < v55 then
		return t1
	end

	local v59 = Cryo.List.join({}, t1)

	if FFlagProfilePlatformAddCurrentlyPlaying and v56 then
		local v60 = v59[v54]
		local v61 = v59[v56]
		local v62 = v59[v55]

		v59[v56] = v60
		v59[v55] = v61
		v59[v54] = v62

		return v59
	end

	local v63 = v59[v55]
	local v64 = v59[v54]

	v59[v54] = v63
	v59[v55] = v64

	return v59
end
local function moveMomentsToTop(t2: {[any]: any}) -- line: 83
	-- upvalues: Enums (copy), Cryo (copy)
	local v66 = nil

	for i, v in ipairs(t2) do
		if v == Enums.Components.Moments then
			v66 = i

			break
		end
	end

	if v66 == nil then
		return t2
	end

	local v69 = Cryo.List.join({}, t2)

	table.remove(v69, v66)

	local n1 = 1

	for i, v in ipairs(v69) do
		if v == Enums.Components.CurrentlyWearing then
			n1 = i

			break
		end
	end

	table.insert(v69, n1, Enums.Components.Moments)

	return v69
end

local t3 = {
	[Enums.Components.UserProfileHeader] = UserProfileHeader,
	[Enums.Components.CurrentlyWearing] = CurrentlyWearing,
	[Enums.Components.Actions] = if not FFlagProfilePlatformCTAsRefactor then ProfileActionBar else CTARow,
	[Enums.Components.Experiences] = if not FFlagExperiencesOnProfile then Experiences else ExperiencesWideCarousel,
	[Enums.Components.ViewFullProfile] = ViewFullProfile,
	[Enums.Components.About] = About.About,
	[Enums.Components.FavoriteExperiences] = if not FFlagProfilePlatformEnableFavoriteExperiences then nil else FavoriteExperiences,
	[Enums.Components.Inventory] = if not FFlagProfilePlatformEnableInventory then nil else Inventory,
	[Enums.Components.Store] = if not FFlagProfilePlatformEnableStore then nil else Store,
	[Enums.Components.ProfileCompletion] = if not FFlagEnableProfileCompletion then nil else ProfileCompletion,
	[Enums.Components.CurrentlyPlaying] = if not FFlagProfilePlatformAddCurrentlyPlaying then nil else CurrentlyPlaying,
	[Enums.Components.Moments] = if not FFlagProfilePlatformEnableMoments then nil else Moments
}
local t4 = {
	[Enums.Components.CoverPhoto] = CoverPhoto,
	[Enums.Components.CommunityProfileHeader] = CommunityProfileHeader,
	[Enums.Components.About] = About.About,
	[Enums.Components.Actions] = if not FFlagProfilePlatformCTAsRefactor then ProfileActionBar else CTARow,
	[Enums.Components.Experiences] = Experiences,
	[Enums.Components.Store] = Store,
	[Enums.Components.SocialLinks] = if not FFlagAddSocialLinksToCommunityProfile then nil else SocialLinks,
	[Enums.Components.Videos] = if not FFlagAddVideoToCommunityProfile then nil else Videos,
	[Enums.Components.ViewFullProfile] = ViewFullProfile,
	[Enums.Components.CommunityLocked] = if not FFlagAddCommunityLockedToCommunityProfile then nil else CommunityLocked,
	[Enums.Components.Events] = if not FFlagAddEventsToCommunityProfile then nil else Events
}
local t5 = {
	[Enums.Components.ContactProfileHeader] = ContactProfileHeader,
	[Enums.Components.ContactDescription] = ContactDescription,
	[Enums.Components.Actions] = if not v46 or not FFlagProfilePlatformCTAsRefactor then ProfileActionBar else CTARow
}
local v52 = if not FFlagAXEnableProfileTab then nil else Cryo.Dictionary.join(t3, {
	[Enums.Components.UserProfileHeader] = MeTabUserProfileHeader,
	[Enums.Components.Actions] = Cryo.None
})

return function(p1, p2, p3, s1: string?, b1: boolean?) -- line: 161
	-- upvalues: React (copy), Constants (copy), Cryo (copy), getPeekViewOpenHeightByProfileType (copy), Enums (copy), FFlagAXEnableProfileTab (copy), v52 (copy), t3 (copy), t4 (copy), t5 (copy), FFlagAboutBeforeActionClient (copy), orderWithAboutBeforeActions (copy), FFlagProfilePlatformEnableMoments (copy), moveMomentsToTop (copy), FFlagProfilePlatformEnableLazyLoadingComponents (copy)
	local v78 = p2 or {}
	local t6 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, Constants.PAGE_PADDING)
		})
	}

	if Cryo.isEmpty(v78) then
		t6.loadingView = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, getPeekViewOpenHeightByProfileType(p3))
		})

		return t6
	end

	local t7 = {}

	if p3 == Enums.ProfileTypes.User then
		t7 = if not FFlagAXEnableProfileTab or not b1 then t3 else v52
	elseif p3 == Enums.ProfileTypes.Community then
		t7 = t4
	elseif p3 == Enums.ProfileTypes.Contact then
		t7 = t5
	end

	local v81 = if not FFlagAboutBeforeActionClient or p3 ~= Enums.ProfileTypes.User then v78 else orderWithAboutBeforeActions(v78)

	if FFlagProfilePlatformEnableMoments and p3 == Enums.ProfileTypes.User and s1 == Enums.Sources.MomentsFeed then
		v81 = moveMomentsToTop(v81)
	end

	for v82, v83 in v81 do
		local v84 = t7[v83]

		if FFlagProfilePlatformEnableLazyLoadingComponents then
			if v84 ~= nil and p1[v83] ~= nil then
				t6[v83] = React.createElement(v84, {
					layoutOrder = v82
				})
			end
		elseif v84 ~= nil then
			t6[v83] = React.createElement(v84, {
				layoutOrder = v82
			})
		end
	end

	return t6
end
