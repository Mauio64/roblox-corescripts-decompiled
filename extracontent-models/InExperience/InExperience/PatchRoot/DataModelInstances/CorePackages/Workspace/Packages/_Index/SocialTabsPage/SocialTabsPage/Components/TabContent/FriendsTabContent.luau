local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local React = require(SocialTabsPageParent.React)
local Dash = require(SocialTabsPageParent.Dash)
local Foundation = require(SocialTabsPageParent.Foundation)
local View = Foundation.View
local Loading = Foundation.Loading
local useLocalization = require(SocialTabsPageParent.Localization).Hooks.useLocalization
local UserList = require(SocialTabsPageParent.UserList)
local UserListLayoutAdaptor = UserList.UserListLayoutAdaptor
local LayoutMode = UserList.Enums.LayoutMode
local EntityType = UserList.Enums.EntityType
local SocialTabsEmptyState = require(SocialTabsPage.Components.SocialTabsEmptyState)
local RowDataProvider = require(SocialTabsPage.Components.RowDataProvider)
local useSocialTabsContext = require(SocialTabsPage.Contexts.useSocialTabsContext)
local useFriendsList = require(SocialTabsPage.Hooks.useFriendsList)
local useFetchPresences = require(SocialTabsPage.Hooks.useFetchPresences)
local useSortedEntitiesByPresence = require(SocialTabsPage.Hooks.useSortedEntitiesByPresence)
local useUserListCTAs = require(SocialTabsPage.Hooks.useUserListCTAs)
local useCTAActionHandlers = require(SocialTabsPage.Hooks.useCTAActionHandlers)
local TextKeys = require(SocialTabsPage.Common.TextKeys)
local FFlagSocialTabsPagePresenceSignalsMigration = require(SocialTabsPage.Flags.FFlagSocialTabsPagePresenceSignalsMigration)

local function FriendsTabContent() -- line: 29
	-- upvalues: useSocialTabsContext (copy), useFriendsList (copy), useLocalization (copy), TextKeys (copy), React (copy), Dash (copy), EntityType (copy), FFlagSocialTabsPagePresenceSignalsMigration (copy), useFetchPresences (copy), useSortedEntitiesByPresence (copy), useUserListCTAs (copy), useCTAActionHandlers (copy), RowDataProvider (copy), View (copy), Loading (copy), SocialTabsEmptyState (copy), UserListLayoutAdaptor (copy), LayoutMode (copy)
	local v24 = useSocialTabsContext()
	local profileId = v24.profileId
	local title = v24.title
	local v27 = useFriendsList({
		targetUserId = profileId
	})
	local friends = v27.friends
	local loading = v27.loading
	local hasMore = v27.hasMore
	local fetchMore = v27.fetchMore
	local v32 = useLocalization({
		emptyText = {
			TextKeys.NoConnectionYet,
			name = title or ""
		}
	})
	local v33 = React.useMemo(function() -- line: 49
		-- upvalues: Dash (copy), friends (copy), EntityType (copy)
		return Dash.map(friends, function(p1) -- line: 50
			-- upvalues: EntityType (copy)
			return {
				id = tostring(p1.id),
				type = EntityType.User
			}
		end)
	end, { friends })
	local v34 = React.useMemo(function() -- line: 55
		-- upvalues: Dash (copy), v33 (copy)
		return Dash.map(v33, function(p2) -- line: 56
			return p2.id
		end)
	end, { v33 })

	if not FFlagSocialTabsPagePresenceSignalsMigration then
		useFetchPresences(v34)
	end

	local v35 = useSortedEntitiesByPresence(v33)
	local v36 = useUserListCTAs(v34)
	local v37 = useCTAActionHandlers()
	local v38 = React.useCallback(function(p3, p4, _: number) -- line: 72
		-- upvalues: React (copy), RowDataProvider (copy), v36 (copy), v37 (copy)
		return React.createElement(RowDataProvider, {
			createRow = p3,
			entity = p4,
			ctaResult = v36[p4.id],
			actionHandlers = v37
		})
	end, {
		v36,
		v37
	})

	if loading and #v33 == 0 then
		return React.createElement(View, {
			tag = "col align-x-center align-y-center size-full"
		}, {
			LoadingIndicator = React.createElement(Loading)
		})
	end

	if not loading and #v33 == 0 then
		return (React.createElement(SocialTabsEmptyState, {
			text = v32.emptyText
		}))
	end

	return React.createElement(View, {
		tag = "col size-full padding-x-xlarge"
	}, {
		FriendsList = React.createElement(UserListLayoutAdaptor, {
			isScrollEnabled = true,
			entities = v35,
			layoutMode = LayoutMode.Vertical,
			hasMore = hasMore,
			onLoadMore = if not hasMore then nil else fetchMore,
			renderRow = v38
		})
	})
end

return FriendsTabContent
