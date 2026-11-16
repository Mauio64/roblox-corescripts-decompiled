local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local UserList = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserList")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local useNavigationProps = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").useNavigationProps
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local InputUi = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/InputUi")
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux").Thunks.NavigateDown
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local userListViewAdaptor = UserList.Components.UserListViewAdaptor
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local getSafeAreaSize = InputUi.getSafeAreaSize
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileCardWidth")
local useProfileCardWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatformCommon").Hooks.useProfileCardWidth
local useProfileFormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileFormFactor")
local fFlagProfilePlatformNewProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformNewProfileHeader

local fFlagSwitchProfileWidthHookToSocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSwitchProfileWidthHookToSocialCommon
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").NavigationCommands else nil

local fFlagMutualConnectionsListPagination = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagMutualConnectionsListPagination
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableSplitPane
local v5 = if fFlagEnableSplitPane then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SplitPane") else nil
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SignalsReact").useSignalState

local function MutualConnectionList(p2)
	local v6 = useDispatch()
	local v7 = useNavigationProps(function(p3, p4)
		return { mutualFriendIds = p4.mutualFriendIds }
	end)

	local safeAreaSize = getSafeAreaSize(useScreenSize(), (useSelector(function(p3)
		return p3.GlobalGuiInset
	end)))
	local v10

	if fFlagProfilePlatformNewProfileHeader then
		v10 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	else
		v10 = false
	end

	local v11

	if fFlagProfilePlatformNewProfileHeader then
		v11 = if fFlagSwitchProfileWidthHookToSocialCommon then useProfileCardWidth() else module9(v10)
	else
		v11 = math.min(safeAreaSize.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH)
	end

	local v12 = v11 / safeAreaSize.X.Offset
	local v13

	if fFlagEnableSplitPane then
		local v14 = useSignalState(v5.SplitPaneStore.getStore().getSupportPaneModeIfActive)
		v13 = not (v14 == nil) and v5.SplitPaneVariant.getProfileSplitPaneEligibility(v14) ~= nil
	else
		v13 = false
	end

	local v15 = {
		position = UDim2.fromScale(1, 0),
		size = UDim2.fromScale(fFlagEnableSplitPane and v13 and 1 or v12, 1),
		anchorPoint = Vector2.new(1, 0)
	}

	local mutualFriendIds = v7.mutualFriendIds
	local v16 = if fFlagMutualConnectionsListPagination then mutualFriendIds else nil
	local v17, v18

	if fFlagMutualConnectionsListPagination then
		local state, setState = React.useState(25)

		React.useEffect(function()
			setState(25)
		end, { mutualFriendIds })

		v17 = React.useCallback(function()
			setState(function(p3)
				return (math.min(p3 + 25, #mutualFriendIds))
			end)
		end, { mutualFriendIds })

		v16 = React.useMemo(function()
			if not (state < #mutualFriendIds) then
				return mutualFriendIds
			end

			local result = {}

			for i = 1, state do
				table.insert(result, mutualFriendIds[i])
			end

			return result
		end, { mutualFriendIds, state })

		v18 = state < #mutualFriendIds
	end

	local v19 = useLocalization({
		mutualConnections = {
			TextKeys.MutualConnectionsTitle,
			numConnections = #mutualFriendIds
		},
		mutualConnection = TextKeys.MutualConnectionTitle
	})

	if #mutualFriendIds == 0 then
		return nil
	end

	local v20 = if #mutualFriendIds == 1 then v19.mutualConnection else v19.mutualConnections

	local createElement = React.createElement

	if not fFlagMutualConnectionsListPagination then
		v16 = mutualFriendIds
	end

	local v22 = {
		users = v16,
		title = v20,
		wideModePeekViewLayout = v15,
		onUserSelected = function(p3)
			local v23 = {
				name = appPage.ProfilePlatform,
				detail = p3,
				extraProps = {
					profileType = Enums.ProfileTypes.User,
					source = Enums.Sources.MutualConnectionsList
				}
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v23))
			else
				v6(navigateDown(v23))
			end
		end,
		hasMore = 0,
		onLoadMore = 0
	}

	if not fFlagMutualConnectionsListPagination then
		v18 = nil
	end

	v22.hasMore = v18

	if not fFlagMutualConnectionsListPagination then
		v17 = nil
	end

	v22.onLoadMore = v17
	return createElement(userListViewAdaptor, v22)
end

return MutualConnectionList
