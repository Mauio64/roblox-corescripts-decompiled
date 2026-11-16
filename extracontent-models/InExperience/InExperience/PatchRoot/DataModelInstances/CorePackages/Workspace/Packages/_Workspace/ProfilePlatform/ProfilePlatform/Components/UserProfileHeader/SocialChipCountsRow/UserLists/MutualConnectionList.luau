local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Constants = require(ProfilePlatform.Common.Constants)

local React = require(parent.React)
local UserList = require(parent.UserList)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local useNavigationProps = RobloxAppNavigation.useNavigationProps
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RoactUtils = require(parent.RoactUtils)
local InputUi = require(parent.InputUi)
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local Enums = require(ProfilePlatform.Common.Enums)
local TextKeys = require(ProfilePlatform.Common.TextKeys)

local UserListViewAdaptor = UserList.Components.UserListViewAdaptor
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local getSafeAreaSize = InputUi.getSafeAreaSize
local useProfileCardWidth = require(ProfilePlatform.Hooks.useProfileCardWidth)
local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local useProfileCardWidth2 = ProfilePlatformCommon.Hooks.useProfileCardWidth
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader

local SharedFlags2 = require(parent.SharedFlags)
local FFlagSwitchProfileWidthHookToSocialCommon = SharedFlags2.FFlagSwitchProfileWidthHookToSocialCommon
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags3.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation2 = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation2.NavigationCommands
else
	navigationCommands = nil
end

local SharedFlags4 = require(parent.SharedFlags)
local FFlagMutualConnectionsListPagination = SharedFlags4.FFlagMutualConnectionsListPagination
local SharedFlags5 = require(parent.SharedFlags)
local FFlagEnableSplitPane = SharedFlags5.FFlagEnableSplitPane
local SplitPane

if FFlagEnableSplitPane then
	SplitPane = require(parent.SplitPane)
else
	SplitPane = nil
end

local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local function MutualConnectionList(_)
	local v = useDispatch()
	local v2 = useNavigationProps(function(_, p)
		return { mutualFriendIds = p.mutualFriendIds }
	end)

	local safeAreaSize = getSafeAreaSize(useScreenSize(), (useSelector(function(p)
		return p.GlobalGuiInset
	end)))
	local v3

	if FFlagProfilePlatformNewProfileHeader then
		v3 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	else
		v3 = false
	end

	local v4

	if FFlagProfilePlatformNewProfileHeader then
		if FFlagSwitchProfileWidthHookToSocialCommon then
			v4 = useProfileCardWidth2()
		else
			v4 = useProfileCardWidth(v3)
		end
	else
		v4 = math.min(safeAreaSize.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH)
	end

	local v5 = v4 / safeAreaSize.X.Offset
	local v6

	if FFlagEnableSplitPane then
		local v7 = useSignalState(SplitPane.SplitPaneStore.getStore().getSupportPaneModeIfActive)

		if v7 == nil then
			v6 = false
		else
			v6 = SplitPane.SplitPaneVariant.getProfileSplitPaneEligibility(v7) ~= nil
		end
	else
		v6 = false
	end

	local wideModePeekViewLayout = {
		position = UDim2.fromScale(1, 0),
		size = UDim2.fromScale(FFlagEnableSplitPane and v6 and 1 or v5, 1),
		anchorPoint = Vector2.new(1, 0)
	}

	local mutualFriendIds = v2.mutualFriendIds
	local users

	if FFlagMutualConnectionsListPagination then
		users = mutualFriendIds
	end

	local onLoadMore, hasMore

	if FFlagMutualConnectionsListPagination then
		local state, setState = React.useState(25)

		React.useEffect(function()
			setState(25)
		end, { mutualFriendIds })

		onLoadMore = React.useCallback(function()
			setState(function(p: number)
				return (math.min(p + 25, #mutualFriendIds))
			end)
		end, { mutualFriendIds })

		users = React.useMemo(function()
			if not (state < #mutualFriendIds) then
				return mutualFriendIds
			end

			local result = {}

			for i = 1, state do
				table.insert(result, mutualFriendIds[i])
			end

			return result
		end, { mutualFriendIds, state })

		hasMore = state < #mutualFriendIds
	end

	local v7 = useLocalization({
		mutualConnections = {
			TextKeys.MutualConnectionsTitle,
			numConnections = #mutualFriendIds
		},
		mutualConnection = TextKeys.MutualConnectionTitle
	})

	if #mutualFriendIds == 0 then
		return nil
	end

	local title

	if #mutualFriendIds == 1 then
		title = v7.mutualConnection
	else
		title = v7.mutualConnections
	end

	local createElement = React.createElement

	if not FFlagMutualConnectionsListPagination then
		users = mutualFriendIds
	end

	local v8 = {
		users = users,
		title = title,
		wideModePeekViewLayout = wideModePeekViewLayout,
		onUserSelected = function(detail)
			local v8 = {
				name = AppPage.ProfilePlatform,
				detail = detail,
				extraProps = {
					profileType = Enums.ProfileTypes.User,
					source = Enums.Sources.MutualConnectionsList
				}
			}

			if FFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v8))
			else
				v(NavigateDown(v8))
			end
		end,
		hasMore = 0,
		onLoadMore = 0
	}

	if not FFlagMutualConnectionsListPagination then
		hasMore = nil
	end

	v8.hasMore = hasMore

	if not FFlagMutualConnectionsListPagination then
		onLoadMore = nil
	end

	v8.onLoadMore = onLoadMore
	return createElement(UserListViewAdaptor, v8)
end

return MutualConnectionList
