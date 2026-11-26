local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/RoactUtils").Hooks.RoactRodux.useDispatch
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation").View
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/RobloxAppNavigation").NavigationCommands else nil

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/RobloxAppEnums").AppPage
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Constants")

local UserRowWrapper = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Deprecated/Components/UserRowWrapper")

local function UserList(props)
	local v5 = useDispatch()

	local v6 = React.useCallback(function(p2)
		if props.onUserSelected then
			props.onUserSelected(p2)
			return
		end

		local v7 = {
			name = appPage.ProfilePlatform,
			detail = p2,
			extraProps = { profileType = Constants.PROFILE_TYPE }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v7))
		else
			v5(navigateDown(v7))
		end
	end, { props.onUserSelected, v5 })

	if #props.userIds == 0 then
		return nil
	end

	return React.createElement(view, {
		tag = "size-full-0 auto-y col gap-large",
		LayoutOrder = props.layoutOrder or 0
	}, {
		UserRows = React.createElement(React.Fragment, {}, unpack(React.useMemo(function()
			local children = {}

			for i, userId in ipairs(props.userIds) do
				children[i] = React.createElement(UserRowWrapper, {
					userId = userId,
					LayoutOrder = i,
					onActivated = v6
				})
			end

			return children
		end, { props.userIds })))
	})
end

return UserList
