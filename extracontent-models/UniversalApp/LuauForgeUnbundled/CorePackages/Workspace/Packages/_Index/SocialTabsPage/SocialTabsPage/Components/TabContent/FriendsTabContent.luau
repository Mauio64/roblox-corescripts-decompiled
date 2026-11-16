local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Foundation")
local view = Foundation.View
local loading = Foundation.Loading
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Localization").Hooks.useLocalization

local UserList = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/UserList")
local userListLayoutAdaptor = UserList.UserListLayoutAdaptor
local layoutMode = UserList.Enums.LayoutMode
local entityType = UserList.Enums.EntityType

local SocialTabsEmptyState = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Components/SocialTabsEmptyState")
local RowDataProvider = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Components/RowDataProvider")
local useSocialTabsContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Contexts/useSocialTabsContext")
local useFriendsList = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Hooks/useFriendsList")
local useUserListCTAs = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Hooks/useUserListCTAs")
local useCTAActionHandlers = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Hooks/useCTAActionHandlers")
local SocialTabsCtaConfig = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Common/SocialTabsCtaConfig")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Common/TextKeys")
local fFlagUserListCtaIntegrationEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/SharedFlags").FFlagUserListCtaIntegrationEnabled

local function FriendsTabContent()
	local v5 = useSocialTabsContext()
	local profileId = v5.profileId
	local title = v5.title

	local v6 = useFriendsList({ targetUserId = profileId })

	local friends = v6.friends
	local loading2 = v6.loading
	local hasMore = v6.hasMore
	local fetchMore = v6.fetchMore

	local v7 = useLocalization({
		emptyText = {
			TextKeys.NoFriendsYet,
			name = title or ""
		}
	})

	local v8 = React.useMemo(function()
		return Dash.map(friends, function(p2)
			return { id = tostring(p2.id), type = entityType.User }
		end)
	end, { friends })

	local v9 = React.useMemo(function()
		return Dash.map(v8, function(p2)
			return p2.id
		end)
	end, { v8 })
	local v10

	if not fFlagUserListCtaIntegrationEnabled then
		local v11 = useUserListCTAs(v9)
		local v12 = useCTAActionHandlers()

		v10 = React.useCallback(function(p2, p3, p4)
			return React.createElement(RowDataProvider, {
				createRow = p2,
				entity = p3,
				ctaResult = v11[p3.id],
				actionHandlers = v12
			})
		end, { v11, v12 })
	end

	if loading2 and #v8 == 0 then
		return React.createElement(view, {
			tag = "col align-x-center align-y-center size-full"
		}, {
			LoadingIndicator = React.createElement(loading)
		})
	end

	if not loading2 and #v8 == 0 then
		return React.createElement(SocialTabsEmptyState, { text = v7.emptyText })
	end

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v15 = {
		entities = v8,
		layoutMode = layoutMode.Vertical,
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

	v15.onLoadMore = fetchMore
	v15.renderRow = v10
	local v16 = if fFlagUserListCtaIntegrationEnabled then SocialTabsCtaConfig.Friends else nil
	v15.ctaConfig = v16
	v15.rowSelectionConfig = SocialTabsCtaConfig.RowSelection
	return createElement(view, { tag = "col size-full padding-x-xlarge" }, {
		FriendsList = createElement2(userListLayoutAdaptor, v15)
	})
end

return FriendsTabContent
