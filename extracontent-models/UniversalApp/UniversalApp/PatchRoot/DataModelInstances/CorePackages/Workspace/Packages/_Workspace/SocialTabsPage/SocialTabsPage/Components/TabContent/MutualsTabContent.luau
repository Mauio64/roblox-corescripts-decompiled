local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local React = require(SocialTabsPageParent.React)
local Dash = require(SocialTabsPageParent.Dash)
local Foundation = require(SocialTabsPageParent.Foundation)
local View = Foundation.View
local Loading = Foundation.Loading
local UserList = require(SocialTabsPageParent.UserList)
local UserListLayoutAdaptor = UserList.UserListLayoutAdaptor
local LayoutMode = UserList.Enums.LayoutMode
local EntityType = UserList.Enums.EntityType
local RowDataProvider = require(SocialTabsPage.Components.RowDataProvider)
local useSocialTabsContext = require(SocialTabsPage.Contexts.useSocialTabsContext)
local useMutualsList = require(SocialTabsPage.Hooks.useMutualsList)
local useFetchPresences = require(SocialTabsPage.Hooks.useFetchPresences)
local useSortedEntitiesByPresence = require(SocialTabsPage.Hooks.useSortedEntitiesByPresence)
local useUserListCTAs = require(SocialTabsPage.Hooks.useUserListCTAs)
local useCTAActionHandlers = require(SocialTabsPage.Hooks.useCTAActionHandlers)

local function MutualsTabContent() -- line: 23
	-- upvalues: useSocialTabsContext (copy), useMutualsList (copy), React (copy), Dash (copy), EntityType (copy), useFetchPresences (copy), useSortedEntitiesByPresence (copy), useUserListCTAs (copy), useCTAActionHandlers (copy), RowDataProvider (copy), View (copy), Loading (copy), UserListLayoutAdaptor (copy), LayoutMode (copy)
	local profileId = useSocialTabsContext().profileId
	local v21 = useMutualsList(profileId)
	local v22 = React.useMemo(function() -- line: 29
		-- upvalues: Dash (copy), v21 (copy), EntityType (copy)
		return Dash.map(v21.mutualFriends, function(p1) -- line: 30
			-- upvalues: EntityType (copy)
			return {
				id = p1.id,
				type = EntityType.User
			}
		end)
	end, { v21.mutualFriends })
	local v23 = React.useMemo(function() -- line: 35
		-- upvalues: Dash (copy), v22 (copy)
		return Dash.map(v22, function(p2) -- line: 36
			return p2.id
		end)
	end, { v22 })

	useFetchPresences(v23)

	local v24 = useSortedEntitiesByPresence(v22)
	local v25 = useUserListCTAs(v23)
	local v26 = useCTAActionHandlers()
	local v27 = React.useCallback(function(p3, p4, _: number) -- line: 48
		-- upvalues: React (copy), RowDataProvider (copy), v25 (copy), v26 (copy)
		return React.createElement(RowDataProvider, {
			createRow = p3,
			entity = p4,
			ctaResult = v25[p4.id],
			actionHandlers = v26
		})
	end, {
		v25,
		v26
	})

	if v21.isLoading and #v22 == 0 then
		return React.createElement(View, {
			tag = "col align-x-center align-y-center size-full"
		}, {
			LoadingIndicator = React.createElement(Loading)
		})
	end

	return React.createElement(View, {
		tag = "col size-full padding-x-xlarge"
	}, {
		MutualsList = React.createElement(UserListLayoutAdaptor, {
			isScrollEnabled = true,
			entities = v24,
			layoutMode = LayoutMode.Vertical,
			hasMore = v21.hasMore,
			onLoadMore = if not v21.hasMore then nil else v21.loadMore,
			renderRow = v27
		})
	})
end

return MutualsTabContent
