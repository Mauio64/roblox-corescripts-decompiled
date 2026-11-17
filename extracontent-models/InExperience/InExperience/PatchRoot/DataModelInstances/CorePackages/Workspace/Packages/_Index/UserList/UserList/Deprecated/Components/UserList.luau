local userList = script:FindFirstAncestor("UserList")
local parent = userList.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Foundation = require(parent.Foundation)
local View = Foundation.View
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local Constants = require(userList.Common.Constants)

local UserRowWrapper = require(script.Parent.UserRowWrapper)

local function UserList(props)
	local v = useDispatch()

	local onActivated = React.useCallback(function(detail: string)
		if props.onUserSelected then
			props.onUserSelected(detail)
			return
		end

		local v2 = {
			name = AppPage.ProfilePlatform,
			detail = detail,
			extraProps = { profileType = Constants.PROFILE_TYPE }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v2))
		else
			v(NavigateDown(v2))
		end
	end, { props.onUserSelected, v })

	if #props.userIds == 0 then
		return nil
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-large",
		LayoutOrder = props.layoutOrder or 0
	}, {
		UserRows = React.createElement(React.Fragment, {}, unpack(React.useMemo(function()
			local children = {}

			for i, userId in ipairs(props.userIds) do
				children[i] = React.createElement(UserRowWrapper, {
					userId = userId,
					LayoutOrder = i,
					onActivated = onActivated
				})
			end

			return children
		end, { props.userIds })))
	})
end

return UserList
