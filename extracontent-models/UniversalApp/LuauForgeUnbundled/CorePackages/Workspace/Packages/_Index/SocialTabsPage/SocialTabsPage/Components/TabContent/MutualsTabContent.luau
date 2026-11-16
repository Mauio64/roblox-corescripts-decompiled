local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Foundation")
local view = Foundation.View
local loading = Foundation.Loading

local UserList = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/UserList")
local userListLayoutAdaptor = UserList.UserListLayoutAdaptor
local layoutMode = UserList.Enums.LayoutMode
local entityType = UserList.Enums.EntityType

local RowDataProvider = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Components/RowDataProvider")
local useSocialTabsContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Contexts/useSocialTabsContext")
local useMutualsList = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Hooks/useMutualsList")
local useSortedEntitiesByPresence = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Hooks/useSortedEntitiesByPresence")
local useUserListCTAs = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Hooks/useUserListCTAs")
local useCTAActionHandlers = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Hooks/useCTAActionHandlers")
local SocialTabsCtaConfig = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Common/SocialTabsCtaConfig")
local fFlagUserListCtaIntegrationEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/SharedFlags").FFlagUserListCtaIntegrationEnabled

local function MutualsTabContent()
	local v5 = useMutualsList(useSocialTabsContext().profileId)

	local v6 = React.useMemo(function()
		return Dash.map(v5.mutualFriends, function(p2)
			return { id = p2.id, type = entityType.User }
		end)
	end, { v5.mutualFriends })

	local v7 = React.useMemo(function()
		return Dash.map(v6, function(p2)
			return p2.id
		end)
	end, { v6 })

	local v8 = useSortedEntitiesByPresence(v6)
	local v9

	if not fFlagUserListCtaIntegrationEnabled then
		local v10 = useUserListCTAs(v7)
		local v11 = useCTAActionHandlers()

		v9 = React.useCallback(function(p2, p3, p4)
			return React.createElement(RowDataProvider, {
				createRow = p2,
				entity = p3,
				ctaResult = v10[p3.id],
				actionHandlers = v11
			})
		end, { v10, v11 })
	end

	if v5.isLoading and #v6 == 0 then
		return React.createElement(view, {
			tag = "col align-x-center align-y-center size-full"
		}, {
			LoadingIndicator = React.createElement(loading)
		})
	end

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v14 = {
		entities = v8,
		layoutMode = layoutMode.Vertical,
		isScrollEnabled = true,
		hasMore = v5.hasMore,
		onLoadMore = 0,
		renderRow = 0,
		ctaConfig = 0,
		rowSelectionConfig = 0
	}
	local v15 = if v5.hasMore then v5.loadMore else nil
	v14.onLoadMore = v15
	v14.renderRow = v9
	local v16 = if fFlagUserListCtaIntegrationEnabled then SocialTabsCtaConfig.Mutuals else nil
	v14.ctaConfig = v16
	v14.rowSelectionConfig = SocialTabsCtaConfig.RowSelection
	return createElement(view, { tag = "col size-full padding-x-xlarge" }, {
		MutualsList = createElement2(userListLayoutAdaptor, v14)
	})
end

return MutualsTabContent
