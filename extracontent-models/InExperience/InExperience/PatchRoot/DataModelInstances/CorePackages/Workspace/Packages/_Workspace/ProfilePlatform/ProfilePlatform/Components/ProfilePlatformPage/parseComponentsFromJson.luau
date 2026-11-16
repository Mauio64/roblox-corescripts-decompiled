local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)

local UserProfileHeader = require(ProfilePlatform.Components.UserProfileHeader)
local MeTabUserProfileHeader = require(ProfilePlatform.Components.UserProfileHeader.MeTabUserProfileHeader)
local About = require(ProfilePlatform.Components.About)
local ContactDescription = require(ProfilePlatform.Components.ContactDescription)
local CommunityProfileHeader = require(ProfilePlatform.Components.CommunityProfileHeader)
local CoverPhoto = require(ProfilePlatform.Components.CoverPhoto)
local CurrentlyWearing = require(ProfilePlatform.Components.CurrentlyWearing)
local Store = require(ProfilePlatform.Components.Store)
local ViewFullProfile = require(ProfilePlatform.Components.ViewFullProfile)
local Inventory = require(ProfilePlatform.Components.Inventory)
local FavoriteExperiences = require(ProfilePlatform.Components.FavoriteExperiences)
local ContactProfileHeader = require(ProfilePlatform.Components.ContactProfileHeader)
local Experiences = require(ProfilePlatform.Components.Experiences)
local v = require(ProfilePlatform.Components.ExperiencesWideCarousel)
local SocialLinks = require(ProfilePlatform.Components.SocialLinks)
local CommunityLocked = require(ProfilePlatform.Components.CommunityLocked)
local Events = require(ProfilePlatform.Components.Events)
local Announcements = require(ProfilePlatform.Components.Announcements)
local GroupForumsDiscovery = require(ProfilePlatform.Components.GroupForumsDiscovery)
local ProfileCompletion = require(ProfilePlatform.Components.ProfileCompletion)
local CurrentlyPlaying = require(ProfilePlatform.Components.CurrentlyPlaying)
local CTARow = require(ProfilePlatform.Components.CTARow)
local Moments = require(ProfilePlatform.Components.Moments)

local Constants = require(parent.ProfilePlatform.Common.Constants)
local Enums = require(parent.ProfilePlatform.Common.Enums)
local getPeekViewOpenHeightByProfileType = require(ProfilePlatform.Utils.getPeekViewOpenHeightByProfileType)

local FFlagProfilePlatformEnableFavoriteExperiences = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableFavoriteExperiences)
local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformEnableStore = SharedFlags.FFlagProfilePlatformEnableStore
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags2.FFlagAXEnableProfileTab
local SharedFlags3 = require(parent.SharedFlags)
local FFlagProfilePlatformEnableInventory = SharedFlags3.FFlagProfilePlatformEnableInventory
local SharedFlags4 = require(parent.SharedFlags)
local FFlagAddSocialLinksToCommunityProfile = SharedFlags4.FFlagAddSocialLinksToCommunityProfile

local SharedFlags5 = require(parent.SharedFlags)
local FFlagAddCommunityLockedToCommunityProfile = SharedFlags5.FFlagAddCommunityLockedToCommunityProfile
local SharedFlags6 = require(parent.SharedFlags)
local FFlagExperiencesOnProfile = SharedFlags6.FFlagExperiencesOnProfile
local SharedFlags7 = require(parent.SharedFlags)
local FFlagEnableProfileCompletion = SharedFlags7.FFlagEnableProfileCompletion
local FFlagProfilePlatformEnableLazyLoadingComponents = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableLazyLoadingComponents)
local FFlagAddEventsToCommunityProfile = require(ProfilePlatform.Flags.FFlagAddEventsToCommunityProfile)
local SharedFlags8 = require(parent.SharedFlags)
local FFlagGroupAnnouncementsSdui = SharedFlags8.FFlagGroupAnnouncementsSdui
local SharedFlags9 = require(parent.SharedFlags)
local FFlagGroupForumsDiscoverySdui = SharedFlags9.FFlagGroupForumsDiscoverySdui
local FFlagProfilePlatformAddCurrentlyPlaying = require(ProfilePlatform.Flags.FFlagProfilePlatformAddCurrentlyPlaying)
local FFlagAboutBeforeActionClient = require(ProfilePlatform.Flags.FFlagAboutBeforeActionClient)
local FFlagProfilePlatformEnableMoments = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableMoments)

local function orderWithAboutBeforeActions(list)
	if not FFlagAboutBeforeActionClient then
		return list
	end

	local v2 = nil
	local v3 = nil
	local v4 = nil

	for i, item in ipairs(list) do
		if item == Enums.Components.About then
			v2 = i
		elseif item == Enums.Components.Actions then
			v3 = i
		elseif FFlagProfilePlatformAddCurrentlyPlaying and item == Enums.Components.CurrentlyPlaying then
			v4 = i
		end
	end

	if v2 == nil or v3 == nil or v2 < v3 then
		return list
	end

	local joined = Cryo.List.join({}, list)

	if FFlagProfilePlatformAddCurrentlyPlaying and v4 then
		local v5 = joined[v2]
		local v6 = joined[v4]
		local v7 = joined[v3]
		joined[v4] = v5
		joined[v3] = v6
		joined[v2] = v7
		return joined
	else
		local v5 = joined[v3]
		local v6 = joined[v2]
		joined[v2] = v5
		joined[v3] = v6

		return joined
	end
end

local function moveMomentsToTop(list)
	local v2 = nil

	for i, item in ipairs(list) do
		if item == Enums.Components.Moments then
			v2 = i
			break
		end
	end

	if v2 == nil then
		return list
	end

	local joined = Cryo.List.join({}, list)
	table.remove(joined, v2)
	local v3 = 1

	for i, v4 in ipairs(joined) do
		if v4 == Enums.Components.CurrentlyWearing then
			v3 = i
			break
		end
	end

	table.insert(joined, v3, Enums.Components.Moments)
	return joined
end

local v2 = {
	[Enums.Components.UserProfileHeader] = UserProfileHeader,
	[Enums.Components.CurrentlyWearing] = CurrentlyWearing,
	[Enums.Components.Actions] = CTARow
}
local experiences = Enums.Components.Experiences

if not FFlagExperiencesOnProfile then
	v = Experiences
end

v2[experiences] = v
v2[Enums.Components.ViewFullProfile] = ViewFullProfile
v2[Enums.Components.About] = About.About
local favoriteExperiences = Enums.Components.FavoriteExperiences

if not FFlagProfilePlatformEnableFavoriteExperiences then
	FavoriteExperiences = nil
end

v2[favoriteExperiences] = FavoriteExperiences

local inventory = Enums.Components.Inventory

if not FFlagProfilePlatformEnableInventory then
	Inventory = nil
end

v2[inventory] = Inventory
local store = Enums.Components.Store
local v3

if FFlagProfilePlatformEnableStore then
	v3 = Store
end

v2[store] = v3
local profileCompletion = Enums.Components.ProfileCompletion

if not FFlagEnableProfileCompletion then
	ProfileCompletion = nil
end

v2[profileCompletion] = ProfileCompletion
local currentlyPlaying = Enums.Components.CurrentlyPlaying

if not FFlagProfilePlatformAddCurrentlyPlaying then
	CurrentlyPlaying = nil
end

v2[currentlyPlaying] = CurrentlyPlaying
local moments = Enums.Components.Moments

if not FFlagProfilePlatformEnableMoments then
	Moments = nil
end

v2[moments] = Moments

local v4 = {
	[Enums.Components.CoverPhoto] = CoverPhoto,
	[Enums.Components.CommunityProfileHeader] = CommunityProfileHeader,
	[Enums.Components.About] = About.About,
	[Enums.Components.Actions] = CTARow,
	[Enums.Components.Experiences] = Experiences,
	[Enums.Components.Store] = Store
}
local socialLinks = Enums.Components.SocialLinks

if not FFlagAddSocialLinksToCommunityProfile then
	SocialLinks = nil
end

v4[socialLinks] = SocialLinks
v4[Enums.Components.ViewFullProfile] = ViewFullProfile
local communityLocked = Enums.Components.CommunityLocked

if not FFlagAddCommunityLockedToCommunityProfile then
	CommunityLocked = nil
end

v4[communityLocked] = CommunityLocked
local events = Enums.Components.Events

if not FFlagAddEventsToCommunityProfile then
	Events = nil
end

v4[events] = Events
local announcements = Enums.Components.Announcements

if not FFlagGroupAnnouncementsSdui then
	Announcements = nil
end

v4[announcements] = Announcements
local groupForumsDiscovery = Enums.Components.GroupForumsDiscovery

if not FFlagGroupForumsDiscoverySdui then
	GroupForumsDiscovery = nil
end

v4[groupForumsDiscovery] = GroupForumsDiscovery

local v5 = {
	[Enums.Components.ContactProfileHeader] = ContactProfileHeader,
	[Enums.Components.ContactDescription] = ContactDescription,
	[Enums.Components.Actions] = CTARow
}
local v6

if FFlagAXEnableProfileTab then
	v6 = Cryo.Dictionary.join(v2, {
		[Enums.Components.UserProfileHeader] = MeTabUserProfileHeader,
		[Enums.Components.Actions] = Cryo.None
	})
else
	v6 = nil
end

return function(p, options, p2, p3: string?, flag: boolean?)
	local v7 = options or {}
	local children = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, Constants.PAGE_PADDING)
		})
	}

	if Cryo.isEmpty(v7) then
		children.loadingView = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, getPeekViewOpenHeightByProfileType(p2)),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		})

		return children
	end

	local v8 = {}

	if p2 == Enums.ProfileTypes.User then
		v8 = if FFlagAXEnableProfileTab and flag then v6 else v2
	elseif p2 == Enums.ProfileTypes.Community then
		v8 = v4
	elseif p2 == Enums.ProfileTypes.Contact then
		v8 = v5
	end

	if FFlagAboutBeforeActionClient and p2 == Enums.ProfileTypes.User then
		v7 = orderWithAboutBeforeActions(v7)
	end

	if FFlagProfilePlatformEnableMoments and p2 == Enums.ProfileTypes.User and p3 == Enums.Sources.MomentsFeed then
		v7 = moveMomentsToTop(v7)
	end

	for k, v9 in v7 do
		local v10 = v8[v9]

		if FFlagProfilePlatformEnableLazyLoadingComponents then
			if v10 ~= nil and p[v9] ~= nil then
				children[v9] = React.createElement(v10, { layoutOrder = k })
			end
		elseif v10 ~= nil then
			children[v9] = React.createElement(v10, { layoutOrder = k })
		end
	end

	return children
end
