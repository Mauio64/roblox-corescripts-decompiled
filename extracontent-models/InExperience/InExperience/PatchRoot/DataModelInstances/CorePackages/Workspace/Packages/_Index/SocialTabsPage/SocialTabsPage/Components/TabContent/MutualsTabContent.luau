local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local parent = SocialTabsPage.Parent

local React = require(parent.React)
local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Loading = Foundation.Loading

local UserList = require(parent.UserList)
local UserListLayoutAdaptor = UserList.UserListLayoutAdaptor
local LayoutMode = UserList.Enums.LayoutMode
local EntityType = UserList.Enums.EntityType

local RowDataProvider = require(SocialTabsPage.Components.RowDataProvider)
local useSocialTabsContext = require(SocialTabsPage.Contexts.useSocialTabsContext)
local useMutualsList = require(SocialTabsPage.Hooks.useMutualsList)
local useSortedEntitiesByPresence = require(SocialTabsPage.Hooks.useSortedEntitiesByPresence)
local useUserListCTAs = require(SocialTabsPage.Hooks.useUserListCTAs)
local useCTAActionHandlers = require(SocialTabsPage.Hooks.useCTAActionHandlers)
local SocialTabsCtaConfig = require(SocialTabsPage.Common.SocialTabsCtaConfig)
local SharedFlags = require(parent.SharedFlags)
local FFlagUserListCtaIntegrationEnabled = SharedFlags.FFlagUserListCtaIntegrationEnabled

local function MutualsTabContent()
	local v = useMutualsList(useSocialTabsContext().profileId)

	local v2 = React.useMemo(function()
		return Dash.map(v.mutualFriends, function(p)
			return { id = p.id, type = EntityType.User }
		end)
	end, { v.mutualFriends })

	local v3 = React.useMemo(function()
		return Dash.map(v2, function(p)
			return p.id
		end)
	end, { v2 })

	local entities = useSortedEntitiesByPresence(v2)
	local renderRow

	if not FFlagUserListCtaIntegrationEnabled then
		local v4 = useUserListCTAs(v3)
		local actionHandlers = useCTAActionHandlers()

		renderRow = React.useCallback(function(createRow, entity, _: number)
			return React.createElement(RowDataProvider, {
				createRow = createRow,
				entity = entity,
				ctaResult = v4[entity.id],
				actionHandlers = actionHandlers
			})
		end, { v4, actionHandlers })
	end

	if v.isLoading and #v2 == 0 then
		return React.createElement(View, { tag = "col align-x-center align-y-center size-full" }, {
			LoadingIndicator = React.createElement(Loading)
		})
	end

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v4 = {
		entities = entities,
		layoutMode = LayoutMode.Vertical,
		isScrollEnabled = true,
		hasMore = v.hasMore,
		onLoadMore = 0,
		renderRow = 0,
		ctaConfig = 0,
		rowSelectionConfig = 0
	}
	local onLoadMore

	if v.hasMore then
		onLoadMore = v.loadMore
	end

	v4.onLoadMore = onLoadMore
	v4.renderRow = renderRow
	local ctaConfig

	if FFlagUserListCtaIntegrationEnabled then
		ctaConfig = SocialTabsCtaConfig.Mutuals
	end

	v4.ctaConfig = ctaConfig
	v4.rowSelectionConfig = SocialTabsCtaConfig.RowSelection
	return createElement(View, { tag = "col size-full padding-x-xlarge" }, {
		MutualsList = createElement2(UserListLayoutAdaptor, v4)
	})
end

return MutualsTabContent
