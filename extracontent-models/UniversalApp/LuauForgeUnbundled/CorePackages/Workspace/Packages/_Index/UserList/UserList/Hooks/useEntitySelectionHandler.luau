local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/RoactUtils").Hooks.RoactRodux.useDispatch
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/RobloxAppNavigation").NavigationCommands else nil

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/RobloxAppEnums").AppPage
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

local FFlagUserListRowSelectionOriginSource = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListRowSelectionOriginSource")

local function useEntitySelectionHandler(callback, p2)
	local v5 = useDispatch()

	return (React.useCallback(function(p3, p4)
		if callback then
			callback(p3, p4)
			return
		end

		local v6 = { name = appPage.ProfilePlatform, detail = p3, extraProps = 0 }

		local v8 = if p4 == Enums.EntityType.Contact then Enums.EntityType.Contact else Enums.EntityType.User

		local v9 = if FFlagUserListRowSelectionOriginSource and p2 then p2.friendshipOriginSourceType else nil
		v6.extraProps = { profileType = v8, friendshipOriginSourceType = v9 }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v6))
		else
			v5(navigateDown(v6))
		end
	end, { callback, v5, p2 or false }))
end

return useEntitySelectionHandler
