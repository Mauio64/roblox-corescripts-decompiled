local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Http").Url
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UrlBuilder").UrlBuilder

local navigateDown = NavigationRodux.Thunks.NavigateDown
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useProfileFormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileFormFactor")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation").useNavigation

local fFlagCreateConnectionsHub = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagCreateConnectionsHub
local fFlagEnableSocialTabsPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableSocialTabsPage
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").NavigationCommands else nil

local FFlagSocialTabsPageIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagSocialTabsPageIxpEnabled")
local FStringSocialTabsPageIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FStringSocialTabsPageIxpLayer")

local ixpServiceWrapper = if FFlagSocialTabsPageIxpEnabled then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/IxpServiceWrapper").IXPServiceWrapper else nil

local function useSocialCountsActions(p2, p3, p4, list, value, p5)
	local v5 = useDispatch()
	local v6 = useNavigation()

	local v7 = if fFlagEnableSocialTabsPage then not useProfileFormFactor().isFullView else nil

	local useMemo = React.useMemo
	local function fn()
		local function buildTabConfig()
			local tabLabelEntries = {}

			if list and #list > 0 then
				table.insert(tabLabelEntries, {
					id = appPage.SocialTabsMutuals,
					tabLabelKey = "Feature.Friends.Mutuals"
				})
			end

			table.insert(tabLabelEntries, {
				id = appPage.SocialTabsFriends,
				tabLabelKey = "CommonUI.Features.Label.Friends"
			})

			return tabLabelEntries
		end

		return {
			mutualFriendsCount = function()
				p4.fireAnalyticsEvent(EventNames.MutualFriendsButton)

				if FFlagSocialTabsPageIxpEnabled then
					ixpServiceWrapper:LogFlagLinkedUserLayerExposure(FStringSocialTabsPageIxpLayer)
				end

				if fFlagEnableSocialTabsPage and not p3 then
					local v8 = {
						name = appPage.SocialTabsPage,
						extraProps = {
							profileId = p2,
							title = value,
							initialTabId = appPage.SocialTabsMutuals,
							tabConfig = buildTabConfig(),
							source = "ProfilePage",
							dockToProfilePanel = v7
						}
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v8))
					else
						v5(navigateDown(v8))
					end
				else
					local v8 = {
						name = appPage.MutualConnectionList,
						extraProps = { mutualFriendIds = list }
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v8))
					else
						v5(navigateDown(v8))
					end
				end
			end,
			followersCount = function()
				p4.fireAnalyticsEvent(EventNames.FollowersButton)
				local v8 = {
					name = appPage.GenericWebPage,
					detail = `{url.BASE_URL}users/{p2}/friends#!/followers`,
					extraProps = { titleKey = TextKeys.Followers }
				}

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v8))
				else
					v5(navigateDown(v8))
				end
			end,
			followingsCount = function()
				p4.fireAnalyticsEvent(EventNames.FollowingsButton)
				local v8 = {
					name = appPage.GenericWebPage,
					detail = `{url.BASE_URL}users/{p2}/friends#!/following`,
					extraProps = { titleKey = TextKeys.Following }
				}

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v8))
				else
					v5(navigateDown(v8))
				end
			end,
			friendsCount = function()
				p4.fireAnalyticsEvent(EventNames.FriendsButton)

				if FFlagSocialTabsPageIxpEnabled and not p3 and p5 then
					ixpServiceWrapper:LogFlagLinkedUserLayerExposure(FStringSocialTabsPageIxpLayer)
				end

				if p3 then
					if fFlagCreateConnectionsHub then
						v6.navigate(appPage.CoHubMyConnections)
						return
					end

					local v8 = {
						name = appPage.ViewFriends,
						extraProps = {
							navigateToFriendsLandingEventStart = {
								startPage = appPage.ProfilePlatform,
								startTime = os.clock()
							}
						}
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v8))
					else
						v5(navigateDown(v8))
					end
				elseif fFlagEnableSocialTabsPage then
					local v8 = {
						name = appPage.SocialTabsPage,
						extraProps = {
							profileId = p2,
							title = value,
							initialTabId = appPage.SocialTabsFriends,
							tabConfig = buildTabConfig(),
							source = "ProfilePage",
							dockToProfilePanel = v7
						}
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v8))
					else
						v5(navigateDown(v8))
					end
				else
					local v8 = {
						name = appPage.GenericWebPage,
						detail = urlBuilder.user.friends({ userId = p2 }),
						extraProps = { titleKey = TextKeys.Friends }
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v8))
					else
						v5(navigateDown(v8))
					end
				end
			end
		}
	end

	local v10 = if fFlagEnableSocialTabsPage then v7 else nil
	local v11 = if fFlagEnableSocialTabsPage then v6 else nil
	return useMemo(fn, {
		p2,
		p3,
		p4,
		v5,
		list,
		fFlagEnableSocialTabsPage and (value or "") or nil,
		v10,
		v11,
		if FFlagSocialTabsPageIxpEnabled then p5 else nil
	})
end

return useSocialCountsActions
