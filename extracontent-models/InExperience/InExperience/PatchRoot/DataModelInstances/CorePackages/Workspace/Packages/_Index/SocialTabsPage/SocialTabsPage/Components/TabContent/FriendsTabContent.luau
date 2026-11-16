local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local parent = SocialTabsPage.Parent

local React = require(parent.React)
local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Loading = Foundation.Loading
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local UserList = require(parent.UserList)
local UserListLayoutAdaptor = UserList.UserListLayoutAdaptor
local LayoutMode = UserList.Enums.LayoutMode
local EntityType = UserList.Enums.EntityType

local SocialTabsEmptyState = require(SocialTabsPage.Components.SocialTabsEmptyState)
local RowDataProvider = require(SocialTabsPage.Components.RowDataProvider)
local useSocialTabsContext = require(SocialTabsPage.Contexts.useSocialTabsContext)
local useFriendsList = require(SocialTabsPage.Hooks.useFriendsList)
local useUserListCTAs = require(SocialTabsPage.Hooks.useUserListCTAs)
local useCTAActionHandlers = require(SocialTabsPage.Hooks.useCTAActionHandlers)
local SocialTabsCtaConfig = require(SocialTabsPage.Common.SocialTabsCtaConfig)
local TextKeys = require(SocialTabsPage.Common.TextKeys)
local SharedFlags = require(parent.SharedFlags)
local FFlagUserListCtaIntegrationEnabled = SharedFlags.FFlagUserListCtaIntegrationEnabled

local function FriendsTabContent()
	local v = useSocialTabsContext()
	local profileId = v.profileId
	local title = v.title

	local v2 = useFriendsList({ targetUserId = profileId })

	local friends = v2.friends
	local loading = v2.loading
	local hasMore = v2.hasMore
	local fetchMore = v2.fetchMore

	local v3 = useLocalization({
		emptyText = {
			TextKeys.NoFriendsYet,
			name = title or ""
		}
	})

	local entities = React.useMemo(function()
		return Dash.map(friends, function(p)
			return { id = tostring(p.id), type = EntityType.User }
		end)
	end, { friends })

	local v4 = React.useMemo(function()
		return Dash.map(entities, function(p)
			return p.id
		end)
	end, { entities })
	local renderRow

	if not FFlagUserListCtaIntegrationEnabled then
		local v5 = useUserListCTAs(v4)
		local actionHandlers = useCTAActionHandlers()

		renderRow = React.useCallback(function(createRow, entity, _: number)
			return React.createElement(RowDataProvider, {
				createRow = createRow,
				entity = entity,
				ctaResult = v5[entity.id],
				actionHandlers = actionHandlers
			})
		end, { v5, actionHandlers })
	end

	if loading and #entities == 0 then
		return React.createElement(View, { tag = "col align-x-center align-y-center size-full" }, {
			LoadingIndicator = React.createElement(Loading)
		})
	end

	if not loading and #entities == 0 then
		return (React.createElement(SocialTabsEmptyState, { text = v3.emptyText }))
	end

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v5 = {
		entities = entities,
		layoutMode = LayoutMode.Vertical,
		isScrollEnabled = true,
		hasMore = hasMore,
		onLoadMore = 0,
		renderRow = 0,
		ctaConfig = 0,
		rowSelectionConfig = 0
	}

	if not hasMore then
		fetchMore = nil
	end

	v5.onLoadMore = fetchMore
	v5.renderRow = renderRow
	local ctaConfig

	if FFlagUserListCtaIntegrationEnabled then
		ctaConfig = SocialTabsCtaConfig.Friends
	end

	v5.ctaConfig = ctaConfig
	v5.rowSelectionConfig = SocialTabsCtaConfig.RowSelection
	return createElement(View, { tag = "col size-full padding-x-xlarge" }, {
		FriendsList = createElement2(UserListLayoutAdaptor, v5)
	})
end

return FriendsTabContent
