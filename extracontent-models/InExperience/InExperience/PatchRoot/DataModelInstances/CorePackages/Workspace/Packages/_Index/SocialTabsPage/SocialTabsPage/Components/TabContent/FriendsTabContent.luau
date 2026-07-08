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

local function FriendsTabContent() -- line: 26
	-- upvalues: useSocialTabsContext (copy), useFriendsList (copy), useLocalization (copy), TextKeys (copy), React (copy), Dash (copy), EntityType (copy), useFetchPresences (copy), useSortedEntitiesByPresence (copy), useUserListCTAs (copy), useCTAActionHandlers (copy), RowDataProvider (copy), View (copy), Loading (copy), SocialTabsEmptyState (copy), UserListLayoutAdaptor (copy), LayoutMode (copy)
	local v23 = useSocialTabsContext()
	local profileId = v23.profileId
	local title = v23.title
	local v26 = useFriendsList({
		targetUserId = profileId
	})
	local friends = v26.friends
	local loading = v26.loading
	local hasMore = v26.hasMore
	local fetchMore = v26.fetchMore
	local v31 = useLocalization({
		emptyText = {
			TextKeys.NoConnectionYet,
			name = title or ""
		}
	})
	local v32 = React.useMemo(function() -- line: 46
		-- upvalues: Dash (copy), friends (copy), EntityType (copy)
		return Dash.map(friends, function(p1) -- line: 47
			-- upvalues: EntityType (copy)
			return {
				id = tostring(p1.id),
				type = EntityType.User
			}
		end)
	end, { friends })
	local v33 = React.useMemo(function() -- line: 52
		-- upvalues: Dash (copy), v32 (copy)
		return Dash.map(v32, function(p2) -- line: 53
			return p2.id
		end)
	end, { v32 })

	useFetchPresences(v33)

	local v34 = useSortedEntitiesByPresence(v32)
	local v35 = useUserListCTAs(v33)
	local v36 = useCTAActionHandlers()
	local v37 = React.useCallback(function(p3, p4, _: number) -- line: 65
		-- upvalues: React (copy), RowDataProvider (copy), v35 (copy), v36 (copy)
		return React.createElement(RowDataProvider, {
			createRow = p3,
			entity = p4,
			ctaResult = v35[p4.id],
			actionHandlers = v36
		})
	end, {
		v35,
		v36
	})

	if loading and #v32 == 0 then
		return React.createElement(View, {
			tag = "col align-x-center align-y-center size-full"
		}, {
			LoadingIndicator = React.createElement(Loading)
		})
	end

	if not loading and #v32 == 0 then
		return (React.createElement(SocialTabsEmptyState, {
			text = v31.emptyText
		}))
	end

	return React.createElement(View, {
		tag = "col size-full padding-x-xlarge"
	}, {
		FriendsList = React.createElement(UserListLayoutAdaptor, {
			isScrollEnabled = true,
			entities = v34,
			layoutMode = LayoutMode.Vertical,
			hasMore = hasMore,
			onLoadMore = if not hasMore then nil else fetchMore,
			renderRow = v37
		})
	})
end

return FriendsTabContent
