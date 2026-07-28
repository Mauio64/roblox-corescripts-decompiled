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
local FFlagSocialTabsPagePresenceSignalsMigration = require(SocialTabsPage.Flags.FFlagSocialTabsPagePresenceSignalsMigration)

local function MutualsTabContent() -- line: 26
	-- upvalues: useSocialTabsContext (copy), useMutualsList (copy), React (copy), Dash (copy), EntityType (copy), FFlagSocialTabsPagePresenceSignalsMigration (copy), useFetchPresences (copy), useSortedEntitiesByPresence (copy), useUserListCTAs (copy), useCTAActionHandlers (copy), RowDataProvider (copy), View (copy), Loading (copy), UserListLayoutAdaptor (copy), LayoutMode (copy)
	local profileId = useSocialTabsContext().profileId
	local v22 = useMutualsList(profileId)
	local v23 = React.useMemo(function() -- line: 32
		-- upvalues: Dash (copy), v22 (copy), EntityType (copy)
		return Dash.map(v22.mutualFriends, function(p1) -- line: 33
			-- upvalues: EntityType (copy)
			return {
				id = p1.id,
				type = EntityType.User
			}
		end)
	end, { v22.mutualFriends })
	local v24 = React.useMemo(function() -- line: 38
		-- upvalues: Dash (copy), v23 (copy)
		return Dash.map(v23, function(p2) -- line: 39
			return p2.id
		end)
	end, { v23 })

	if not FFlagSocialTabsPagePresenceSignalsMigration then
		useFetchPresences(v24)
	end

	local v25 = useSortedEntitiesByPresence(v23)
	local v26 = useUserListCTAs(v24)
	local v27 = useCTAActionHandlers()
	local v28 = React.useCallback(function(p3, p4, _: number) -- line: 55
		-- upvalues: React (copy), RowDataProvider (copy), v26 (copy), v27 (copy)
		return React.createElement(RowDataProvider, {
			createRow = p3,
			entity = p4,
			ctaResult = v26[p4.id],
			actionHandlers = v27
		})
	end, {
		v26,
		v27
	})

	if v22.isLoading and #v23 == 0 then
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
			entities = v25,
			layoutMode = LayoutMode.Vertical,
			hasMore = v22.hasMore,
			onLoadMore = if not v22.hasMore then nil else v22.loadMore,
			renderRow = v28
		})
	})
end

return MutualsTabContent
