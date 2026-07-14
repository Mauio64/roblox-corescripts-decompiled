local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Constants = require(ProfilePlatform.Common.Constants)
local React = require(ProfilePlatformParent.React)
local UserList = require(ProfilePlatformParent.UserList)
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local useNavigationProps = require(ProfilePlatformParent.RobloxAppNavigation).useNavigationProps
local RobloxAppHooks = require(ProfilePlatformParent.RobloxAppHooks)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local InputUi = require(ProfilePlatformParent.InputUi)
local NavigateDown = require(ProfilePlatformParent.NavigationRodux).Thunks.NavigateDown
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local Enums = require(ProfilePlatform.Common.Enums)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local UserListViewAdaptor = UserList.Components.UserListViewAdaptor
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local getSafeAreaSize = InputUi.getSafeAreaSize
local useProfileCardWidth = require(ProfilePlatform.Hooks.useProfileCardWidth)
local useProfileCardWidth2 = require(ProfilePlatformParent.ProfilePlatformCommon).Hooks.useProfileCardWidth
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local FFlagProfilePlatformNewProfileHeader = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformNewProfileHeader
local FFlagSwitchProfileWidthHookToSocialCommon = require(ProfilePlatformParent.SharedFlags).FFlagSwitchProfileWidthHookToSocialCommon
local FFlagSignalsNavP3Dispatch = require(ProfilePlatformParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v26 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands
local FFlagMutualConnectionsListPagination = require(ProfilePlatformParent.SharedFlags).FFlagMutualConnectionsListPagination

local function MutualConnectionList(_) -- line: 40
	-- upvalues: useDispatch (copy), useNavigationProps (copy), useScreenSize (copy), useSelector (copy), getSafeAreaSize (copy), FFlagProfilePlatformNewProfileHeader (copy), useProfileFormFactor (copy), Enums (copy), FFlagSwitchProfileWidthHookToSocialCommon (copy), useProfileCardWidth2 (copy), useProfileCardWidth (copy), Constants (copy), FFlagMutualConnectionsListPagination (copy), React (copy), useLocalization (copy), TextKeys (copy), UserListViewAdaptor (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), NavigateDown (copy)
	local v30 = useDispatch()
	local v31 = useNavigationProps(function(_, p3) -- line: 42
		return {
			mutualFriendIds = p3.mutualFriendIds
		}
	end)
	local v32 = useScreenSize()
	local v33 = useSelector(function(p4) -- line: 50
		return p4.GlobalGuiInset
	end)
	local v34 = getSafeAreaSize(v32, v33)
	local v35 = not not FFlagProfilePlatformNewProfileHeader and useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local v36 = ((if not FFlagProfilePlatformNewProfileHeader then math.min(v34.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH) else (if not FFlagSwitchProfileWidthHookToSocialCommon then useProfileCardWidth(v35) else useProfileCardWidth2()))) / v34.X.Offset
	local t1 = {
		position = UDim2.fromScale(1, 0),
		size = UDim2.fromScale(v36, 1),
		anchorPoint = Vector2.new(1, 0)
	}
	local mutualFriendIds = v31.mutualFriendIds
	local v39 = if not FFlagMutualConnectionsListPagination then nil else mutualFriendIds
	local v40 = nil
	local v41 = nil

	if FFlagMutualConnectionsListPagination then
		local v42, v43 = React.useState(25)

		React.useEffect(function() -- line: 78
			-- upvalues: v43 (copy)
			v43(25)
		end, { mutualFriendIds })
		v41 = React.useCallback(function() -- line: 82
			-- upvalues: v43 (copy), mutualFriendIds (copy)
			v43(function(n1: number) -- line: 83
				-- upvalues: mutualFriendIds (copy)
				return (math.min(n1 + 25, #mutualFriendIds))
			end)
		end, { mutualFriendIds })
		v39 = React.useMemo(function() -- line: 88
			-- upvalues: v42 (copy), mutualFriendIds (copy)
			if v42 < #mutualFriendIds then
				local t2 = {}

				for i = 1, v42 do
					table.insert(t2, mutualFriendIds[i])
				end

				return t2
			end

			return mutualFriendIds
		end, {
			mutualFriendIds,
			v42
		})
		v40 = v42 < #mutualFriendIds
	end

	local v44 = useLocalization({
		mutualConnections = {
			TextKeys.MutualConnectionsTitle,
			numConnections = #mutualFriendIds
		},
		mutualConnection = TextKeys.MutualConnectionTitle
	})

	if #mutualFriendIds == 0 then
		return nil
	end

	local v45 = if #mutualFriendIds ~= 1 then v44.mutualConnections else v44.mutualConnection

	return React.createElement(UserListViewAdaptor, {
		users = if not FFlagMutualConnectionsListPagination then mutualFriendIds else v39,
		title = v45,
		wideModePeekViewLayout = t1,
		onUserSelected = function(p5) -- line: 120
			-- upvalues: AppPage (copy), Enums (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), v30 (copy), NavigateDown (copy)
			local t3 = {
				name = AppPage.ProfilePlatform,
				detail = p5,
				extraProps = {
					profileType = Enums.ProfileTypes.User,
					source = Enums.Sources.MutualConnectionsList
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v26.down(v26.fromLegacyPage(t3))

				return
			end

			v30(NavigateDown(t3))
		end,
		hasMore = if not FFlagMutualConnectionsListPagination then nil else v40,
		onLoadMore = if not FFlagMutualConnectionsListPagination then nil else v41
	})
end

return MutualConnectionList
