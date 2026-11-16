local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local NavigationRodux = require(parent.NavigationRodux)
local RoactUtils = require(parent.RoactUtils)

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local Http = require(parent.Http)
local Url = Http.Url
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local NavigateDown = NavigationRodux.Thunks.NavigateDown
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local SharedFlags = require(parent.SharedFlags)
local FFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableSocialTabsPage = SharedFlags2.FFlagEnableSocialTabsPage
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags3.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local FFlagSocialTabsPageIxpEnabled = require(ProfilePlatform.Flags.FFlagSocialTabsPageIxpEnabled)
local FStringSocialTabsPageIxpLayer = require(ProfilePlatform.Flags.FStringSocialTabsPageIxpLayer)
local ixpServiceWrapper

if FFlagSocialTabsPageIxpEnabled then
	local IXPServiceWrapper = require(parent.IXPServiceWrapper)
	ixpServiceWrapper = IXPServiceWrapper.IXPServiceWrapper
else
	ixpServiceWrapper = nil
end

local function useSocialCountsActions(p: string, flag: boolean, p2, mutualFriendIds, title: string?, flag2: boolean?)
	local v = useDispatch()
	local v2 = useNavigation()
	local dockToProfilePanel

	if FFlagEnableSocialTabsPage then
		dockToProfilePanel = not useProfileFormFactor().isFullView
	else
		dockToProfilePanel = nil
	end

	local useMemo = React.useMemo
	local function fn()
		local function buildTabConfig()
			local tabLabelEntries = {}

			if mutualFriendIds and #mutualFriendIds > 0 then
				table.insert(tabLabelEntries, {
					id = AppPage.SocialTabsMutuals,
					tabLabelKey = "Feature.Friends.Mutuals"
				})
			end

			table.insert(tabLabelEntries, {
				id = AppPage.SocialTabsFriends,
				tabLabelKey = "CommonUI.Features.Label.Friends"
			})

			return tabLabelEntries
		end

		return {
			mutualFriendsCount = function()
				p2.fireAnalyticsEvent(EventNames.MutualFriendsButton)

				if FFlagSocialTabsPageIxpEnabled then
					ixpServiceWrapper:LogFlagLinkedUserLayerExposure(FStringSocialTabsPageIxpLayer)
				end

				if FFlagEnableSocialTabsPage and not flag then
					local v3 = {
						name = AppPage.SocialTabsPage,
						extraProps = {
							profileId = p,
							title = title,
							initialTabId = AppPage.SocialTabsMutuals,
							tabConfig = buildTabConfig(),
							source = "ProfilePage",
							dockToProfilePanel = dockToProfilePanel
						}
					}

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v3))
					else
						v(NavigateDown(v3))
					end
				else
					local v3 = {
						name = AppPage.MutualConnectionList,
						extraProps = { mutualFriendIds = mutualFriendIds }
					}

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v3))
					else
						v(NavigateDown(v3))
					end
				end
			end,
			followersCount = function()
				p2.fireAnalyticsEvent(EventNames.FollowersButton)
				local v3 = {
					name = AppPage.GenericWebPage,
					detail = `{Url.BASE_URL}users/{p}/friends#!/followers`,
					extraProps = { titleKey = TextKeys.Followers }
				}

				if FFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v3))
				else
					v(NavigateDown(v3))
				end
			end,
			followingsCount = function()
				p2.fireAnalyticsEvent(EventNames.FollowingsButton)
				local v3 = {
					name = AppPage.GenericWebPage,
					detail = `{Url.BASE_URL}users/{p}/friends#!/following`,
					extraProps = { titleKey = TextKeys.Following }
				}

				if FFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v3))
				else
					v(NavigateDown(v3))
				end
			end,
			friendsCount = function()
				p2.fireAnalyticsEvent(EventNames.FriendsButton)

				if FFlagSocialTabsPageIxpEnabled and not flag and flag2 then
					ixpServiceWrapper:LogFlagLinkedUserLayerExposure(FStringSocialTabsPageIxpLayer)
				end

				if flag then
					if FFlagCreateConnectionsHub then
						v2.navigate(AppPage.CoHubMyConnections)
						return
					end

					local v3 = {
						name = AppPage.ViewFriends,
						extraProps = {
							navigateToFriendsLandingEventStart = {
								startPage = AppPage.ProfilePlatform,
								startTime = os.clock()
							}
						}
					}

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v3))
					else
						v(NavigateDown(v3))
					end
				elseif FFlagEnableSocialTabsPage then
					local v3 = {
						name = AppPage.SocialTabsPage,
						extraProps = {
							profileId = p,
							title = title,
							initialTabId = AppPage.SocialTabsFriends,
							tabConfig = buildTabConfig(),
							source = "ProfilePage",
							dockToProfilePanel = dockToProfilePanel
						}
					}

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v3))
					else
						v(NavigateDown(v3))
					end
				else
					local v3 = {
						name = AppPage.GenericWebPage,
						detail = urlBuilder.user.friends({ userId = p }),
						extraProps = { titleKey = TextKeys.Friends }
					}

					if FFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v3))
					else
						v(NavigateDown(v3))
					end
				end
			end
		}
	end

	local v3

	if FFlagEnableSocialTabsPage then
		v3 = dockToProfilePanel
	end

	local v4

	if FFlagEnableSocialTabsPage then
		v4 = v2
	end

	local v5

	if FFlagSocialTabsPageIxpEnabled then
		v5 = flag2
	end

	return useMemo(fn, {
		p,
		flag,
		p2,
		v,
		mutualFriendIds,
		FFlagEnableSocialTabsPage and (title or "") or nil,
		v3,
		v4,
		v5
	})
end

return useSocialCountsActions
