local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local NavigationRodux = require(ProfilePlatformParent.NavigationRodux)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local Url = require(ProfilePlatformParent.Http).Url
local UrlBuilder = require(ProfilePlatformParent.UrlBuilder).UrlBuilder
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = require(ProfilePlatformParent.Navigation).useNavigation
local FFlagConnectionsToFriendsRename = require(ProfilePlatformParent.SharedFlags).FFlagConnectionsToFriendsRename
local FFlagCreateConnectionsHub = require(ProfilePlatformParent.SharedFlags).FFlagCreateConnectionsHub
local FFlagEnableSocialTabsPage = require(ProfilePlatformParent.SharedFlags).FFlagEnableSocialTabsPage
local FFlagSignalsNavP3Dispatch = require(ProfilePlatformParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v18 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands

local function useSocialCountsActions(s1: string, b1: boolean, p1, t1: {[any]: any}?, s2: string?) -- line: 35
	-- upvalues: useDispatch (copy), useNavigation (copy), React (copy), AppPage (copy), EventNames (copy), FFlagEnableSocialTabsPage (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), NavigateDown (copy), Url (copy), TextKeys (copy), FFlagCreateConnectionsHub (copy), UrlBuilder (copy), FFlagConnectionsToFriendsRename (copy)
	local v25 = useDispatch()
	local v26 = useNavigation()

	return React.useMemo(function() -- line: 46
		-- upvalues: t1 (copy), AppPage (copy), p1 (copy), EventNames (copy), FFlagEnableSocialTabsPage (copy), b1 (copy), s1 (copy), s2 (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), v25 (copy), NavigateDown (copy), Url (copy), TextKeys (copy), FFlagCreateConnectionsHub (copy), v26 (copy), UrlBuilder (copy), FFlagConnectionsToFriendsRename (copy)
		local function buildTabConfig() -- line: 47
			-- upvalues: t1 (copy), AppPage (copy)
			local t2 = {}

			if t1 and #t1 > 0 then
				table.insert(t2, {
					tabLabelKey = "Feature.Friends.Mutuals",
					id = AppPage.SocialTabsMutuals
				})
			end

			table.insert(t2, {
				tabLabelKey = "CommonUI.Features.Label.Friends",
				id = AppPage.SocialTabsFriends
			})

			return t2
		end

		return {
			mutualFriendsCount = function() -- line: 60
				-- upvalues: p1 (copy), EventNames (copy), FFlagEnableSocialTabsPage (copy), b1 (copy), AppPage (copy), s1 (copy), s2 (copy), buildTabConfig (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), v25 (copy), NavigateDown (copy), t1 (copy)
				p1.fireAnalyticsEvent(EventNames.MutualFriendsButton)

				if FFlagEnableSocialTabsPage and not b1 then
					local t3 = {
						name = AppPage.SocialTabsPage,
						extraProps = {
							source = "ProfilePage",
							profileId = s1,
							title = s2,
							initialTabId = AppPage.SocialTabsMutuals,
							tabConfig = buildTabConfig()
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v18.down(v18.fromLegacyPage(t3))

						return
					end

					v25(NavigateDown(t3))

					return
				end

				local t4 = {
					name = AppPage.MutualConnectionList,
					extraProps = {
						mutualFriendIds = t1
					}
				}

				if FFlagSignalsNavP3Dispatch then
					v18.down(v18.fromLegacyPage(t4))

					return
				end

				v25(NavigateDown(t4))
			end,
			followersCount = function() -- line: 94
				-- upvalues: p1 (copy), EventNames (copy), AppPage (copy), Url (copy), s1 (copy), TextKeys (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), v25 (copy), NavigateDown (copy)
				p1.fireAnalyticsEvent(EventNames.FollowersButton)

				local t5 = {
					name = AppPage.GenericWebPage,
					detail = `{ Url.BASE_URL }users/{ s1 }/friends#!/followers`,
					extraProps = {
						titleKey = TextKeys.Followers
					}
				}

				if FFlagSignalsNavP3Dispatch then
					v18.down(v18.fromLegacyPage(t5))

					return
				end

				v25(NavigateDown(t5))
			end,
			followingsCount = function() -- line: 110
				-- upvalues: p1 (copy), EventNames (copy), AppPage (copy), Url (copy), s1 (copy), TextKeys (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), v25 (copy), NavigateDown (copy)
				p1.fireAnalyticsEvent(EventNames.FollowingsButton)

				local t6 = {
					name = AppPage.GenericWebPage,
					detail = `{ Url.BASE_URL }users/{ s1 }/friends#!/following`,
					extraProps = {
						titleKey = TextKeys.Following
					}
				}

				if FFlagSignalsNavP3Dispatch then
					v18.down(v18.fromLegacyPage(t6))

					return
				end

				v25(NavigateDown(t6))
			end,
			friendsCount = function() -- line: 126
				-- upvalues: p1 (copy), EventNames (copy), b1 (copy), FFlagCreateConnectionsHub (copy), v26 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), v25 (copy), NavigateDown (copy), FFlagEnableSocialTabsPage (copy), s1 (copy), s2 (copy), buildTabConfig (copy), UrlBuilder (copy), FFlagConnectionsToFriendsRename (copy), TextKeys (copy)
				p1.fireAnalyticsEvent(EventNames.FriendsButton)

				if b1 then
					if FFlagCreateConnectionsHub then
						v26.navigate(AppPage.CoHubMyConnections)

						return
					end

					local t7 = {
						name = AppPage.ViewFriends,
						extraProps = {
							navigateToFriendsLandingEventStart = {
								startPage = AppPage.ProfilePlatform,
								startTime = os.clock()
							}
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v18.down(v18.fromLegacyPage(t7))

						return
					end

					v25(NavigateDown(t7))

					return
				end

				if FFlagEnableSocialTabsPage then
					local t8 = {
						name = AppPage.SocialTabsPage,
						extraProps = {
							source = "ProfilePage",
							profileId = s1,
							title = s2,
							initialTabId = AppPage.SocialTabsFriends,
							tabConfig = buildTabConfig()
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v18.down(v18.fromLegacyPage(t8))

						return
					end

					v25(NavigateDown(t8))

					return
				end

				local t9 = {
					name = AppPage.GenericWebPage,
					detail = UrlBuilder.user.friends({
						userId = s1
					}),
					extraProps = {
						titleKey = if not FFlagConnectionsToFriendsRename then TextKeys.Connections else TextKeys.Friends
					}
				}

				if FFlagSignalsNavP3Dispatch then
					v18.down(v18.fromLegacyPage(t9))

					return
				end

				v25(NavigateDown(t9))
			end
		}
	end, {
		s1,
		b1,
		p1,
		v25,
		t1,
		if not FFlagEnableSocialTabsPage then nil else s2
	})
end

return useSocialCountsActions
