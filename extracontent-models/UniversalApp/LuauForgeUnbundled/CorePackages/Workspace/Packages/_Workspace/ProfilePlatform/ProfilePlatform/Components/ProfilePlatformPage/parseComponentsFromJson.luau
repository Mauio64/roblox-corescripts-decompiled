local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local UserProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader")
local MeTabUserProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/MeTabUserProfileHeader")
local About = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/About")
local ContactDescription = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ContactDescription")
local CommunityProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CommunityProfileHeader")
local CoverPhoto = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CoverPhoto")
local CurrentlyWearing = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CurrentlyWearing")
local Store = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Store")
local ViewFullProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ViewFullProfile")
local Inventory = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Inventory")
local FavoriteExperiences = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/FavoriteExperiences")
local ContactProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ContactProfileHeader")
local Experiences = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Experiences")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ExperiencesWideCarousel")
local SocialLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/SocialLinks")
local CommunityLocked = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CommunityLocked")
local Events = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Events")
local Announcements = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Announcements")
local GroupForumsDiscovery = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/GroupForumsDiscovery")
local ProfileCompletion = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ProfileCompletion")
local CurrentlyPlaying = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CurrentlyPlaying")
local CTARow = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow")
local Moments = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local getPeekViewOpenHeightByProfileType = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Utils/getPeekViewOpenHeightByProfileType")

local FFlagProfilePlatformEnableFavoriteExperiences = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableFavoriteExperiences")
local fFlagProfilePlatformEnableStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableStore
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAXEnableProfileTab
local fFlagProfilePlatformEnableInventory = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableInventory
local fFlagAddSocialLinksToCommunityProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAddSocialLinksToCommunityProfile

local fFlagAddCommunityLockedToCommunityProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAddCommunityLockedToCommunityProfile
local fFlagExperiencesOnProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagExperiencesOnProfile
local fFlagEnableProfileCompletion = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableProfileCompletion
local FFlagProfilePlatformEnableLazyLoadingComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableLazyLoadingComponents")
local FFlagAddEventsToCommunityProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagAddEventsToCommunityProfile")
local fFlagGroupAnnouncementsSdui = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagGroupAnnouncementsSdui
local fFlagGroupForumsDiscoverySdui = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagGroupForumsDiscoverySdui
local FFlagProfilePlatformAddCurrentlyPlaying = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformAddCurrentlyPlaying")
local FFlagAboutBeforeActionClient = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagAboutBeforeActionClient")
local FFlagProfilePlatformEnableMoments = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableMoments")

local function orderWithAboutBeforeActions(list)
	if not FFlagAboutBeforeActionClient then
		return list
	end

	local v6 = nil
	local v7 = nil
	local v8 = nil

	for i, item in ipairs(list) do
		if item == Enums.Components.About then
			v6 = i
		elseif item == Enums.Components.Actions then
			v7 = i
		elseif FFlagProfilePlatformAddCurrentlyPlaying and item == Enums.Components.CurrentlyPlaying then
			v8 = i
		end
	end

	if v6 == nil or v7 == nil or v6 < v7 then
		return list
	end

	local joined = Cryo.List.join({}, list)

	if FFlagProfilePlatformAddCurrentlyPlaying and v8 then
		local v9 = joined[v6]
		local v10 = joined[v8]
		local v11 = joined[v7]
		joined[v8] = v9
		joined[v7] = v10
		joined[v6] = v11
		return joined
	else
		local v9 = joined[v7]
		local v10 = joined[v6]
		joined[v6] = v9
		joined[v7] = v10

		return joined
	end
end

local function moveMomentsToTop(list)
	local v6 = nil

	for i, item in ipairs(list) do
		if item == Enums.Components.Moments then
			v6 = i
			break
		end
	end

	if v6 == nil then
		return list
	end

	local joined = Cryo.List.join({}, list)
	table.remove(joined, v6)
	local v8 = 1

	for i, v10 in ipairs(joined) do
		if v10 == Enums.Components.CurrentlyWearing then
			v8 = i
			break
		end
	end

	table.insert(joined, v8, Enums.Components.Moments)
	return joined
end

local v6 = {
	[Enums.Components.UserProfileHeader] = UserProfileHeader,
	[Enums.Components.CurrentlyWearing] = CurrentlyWearing,
	[Enums.Components.Actions] = CTARow
}
local experiences = Enums.Components.Experiences

if not fFlagExperiencesOnProfile then
	v5 = Experiences
end

v6[experiences] = v5
v6[Enums.Components.ViewFullProfile] = ViewFullProfile
v6[Enums.Components.About] = About.About
local favoriteExperiences = Enums.Components.FavoriteExperiences

if not FFlagProfilePlatformEnableFavoriteExperiences then
	FavoriteExperiences = nil
end

v6[favoriteExperiences] = FavoriteExperiences

local inventory = Enums.Components.Inventory

if not fFlagProfilePlatformEnableInventory then
	Inventory = nil
end

v6[inventory] = Inventory
local store = Enums.Components.Store
v6[store] = if fFlagProfilePlatformEnableStore then Store else nil
local profileCompletion = Enums.Components.ProfileCompletion

if not fFlagEnableProfileCompletion then
	ProfileCompletion = nil
end

v6[profileCompletion] = ProfileCompletion
local currentlyPlaying = Enums.Components.CurrentlyPlaying

if not FFlagProfilePlatformAddCurrentlyPlaying then
	CurrentlyPlaying = nil
end

v6[currentlyPlaying] = CurrentlyPlaying
local moments = Enums.Components.Moments

if not FFlagProfilePlatformEnableMoments then
	Moments = nil
end

v6[moments] = Moments

local v8 = {
	[Enums.Components.CoverPhoto] = CoverPhoto,
	[Enums.Components.CommunityProfileHeader] = CommunityProfileHeader,
	[Enums.Components.About] = About.About,
	[Enums.Components.Actions] = CTARow,
	[Enums.Components.Experiences] = Experiences,
	[Enums.Components.Store] = Store
}
local socialLinks = Enums.Components.SocialLinks

if not fFlagAddSocialLinksToCommunityProfile then
	SocialLinks = nil
end

v8[socialLinks] = SocialLinks
v8[Enums.Components.ViewFullProfile] = ViewFullProfile
local communityLocked = Enums.Components.CommunityLocked

if not fFlagAddCommunityLockedToCommunityProfile then
	CommunityLocked = nil
end

v8[communityLocked] = CommunityLocked
local events = Enums.Components.Events

if not FFlagAddEventsToCommunityProfile then
	Events = nil
end

v8[events] = Events
local announcements = Enums.Components.Announcements

if not fFlagGroupAnnouncementsSdui then
	Announcements = nil
end

v8[announcements] = Announcements
local groupForumsDiscovery = Enums.Components.GroupForumsDiscovery

if not fFlagGroupForumsDiscoverySdui then
	GroupForumsDiscovery = nil
end

v8[groupForumsDiscovery] = GroupForumsDiscovery

local modules = {
	[Enums.Components.ContactProfileHeader] = ContactProfileHeader,
	[Enums.Components.ContactDescription] = ContactDescription,
	[Enums.Components.Actions] = CTARow
}
local v9

if fFlagAXEnableProfileTab then
	v9 = Cryo.Dictionary.join(v6, {
		[Enums.Components.UserProfileHeader] = MeTabUserProfileHeader,
		[Enums.Components.Actions] = Cryo.None
	})
else
	v9 = nil
end

return function(p2, options, p3, p4, p5)
	local v10 = options or {}
	local children = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, Constants.PAGE_PADDING)
		})
	}

	if Cryo.isEmpty(v10) then
		children.loadingView = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, getPeekViewOpenHeightByProfileType(p3)),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		})

		return children
	end

	local v11 = {}

	if p3 == Enums.ProfileTypes.User then
		v11 = if fFlagAXEnableProfileTab and p5 then v9 else v6
	elseif p3 == Enums.ProfileTypes.Community then
		v11 = v8
	elseif p3 == Enums.ProfileTypes.Contact then
		v11 = modules
	end

	if FFlagAboutBeforeActionClient and p3 == Enums.ProfileTypes.User then
		v10 = orderWithAboutBeforeActions(v10)
	end

	if FFlagProfilePlatformEnableMoments and p3 == Enums.ProfileTypes.User and p4 == Enums.Sources.MomentsFeed then
		v10 = moveMomentsToTop(v10)
	end

	for k, v12 in v10 do
		local v13 = v11[v12]

		if FFlagProfilePlatformEnableLazyLoadingComponents then
			if v13 ~= nil and p2[v12] ~= nil then
				children[v12] = React.createElement(v13, { layoutOrder = k })
			end
		elseif v13 ~= nil then
			children[v12] = React.createElement(v13, { layoutOrder = k })
		end
	end

	return children
end
