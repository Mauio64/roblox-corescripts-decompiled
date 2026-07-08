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

local function MutualConnectionList(_) -- line: 34
	-- upvalues: useDispatch (copy), useNavigationProps (copy), useScreenSize (copy), useSelector (copy), getSafeAreaSize (copy), FFlagProfilePlatformNewProfileHeader (copy), useProfileFormFactor (copy), Enums (copy), FFlagSwitchProfileWidthHookToSocialCommon (copy), useProfileCardWidth2 (copy), useProfileCardWidth (copy), Constants (copy), useLocalization (copy), TextKeys (copy), React (copy), UserListViewAdaptor (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), NavigateDown (copy)
	local v29 = useDispatch()
	local v30 = useNavigationProps(function(_, p3) -- line: 36
		return {
			mutualFriendIds = p3.mutualFriendIds
		}
	end)
	local v31 = useScreenSize()
	local v32 = useSelector(function(p4) -- line: 44
		return p4.GlobalGuiInset
	end)
	local v33 = getSafeAreaSize(v31, v32)
	local v34 = not not FFlagProfilePlatformNewProfileHeader and useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local v35 = ((if not FFlagProfilePlatformNewProfileHeader then math.min(v33.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH) else (if not FFlagSwitchProfileWidthHookToSocialCommon then useProfileCardWidth(v34) else useProfileCardWidth2()))) / v33.X.Offset
	local t1 = {
		position = UDim2.fromScale(1, 0),
		size = UDim2.fromScale(v35, 1),
		anchorPoint = Vector2.new(1, 0)
	}
	local mutualFriendIds = v30.mutualFriendIds
	local v38 = useLocalization({
		mutualConnections = {
			TextKeys.MutualConnectionsTitle,
			numConnections = #mutualFriendIds
		},
		mutualConnection = TextKeys.MutualConnectionTitle
	})

	if #mutualFriendIds == 0 then
		return nil
	end

	local v39 = if #mutualFriendIds ~= 1 then v38.mutualConnections else v38.mutualConnection

	return React.createElement(UserListViewAdaptor, {
		users = mutualFriendIds,
		title = v39,
		wideModePeekViewLayout = t1,
		onUserSelected = function(p5) -- line: 84
			-- upvalues: AppPage (copy), Enums (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), v29 (copy), NavigateDown (copy)
			local t2 = {
				name = AppPage.ProfilePlatform,
				detail = p5,
				extraProps = {
					profileType = Enums.ProfileTypes.User,
					source = Enums.Sources.MutualConnectionsList
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v26.down(v26.fromLegacyPage(t2))

				return
			end

			v29(NavigateDown(t2))
		end
	})
end

return MutualConnectionList
