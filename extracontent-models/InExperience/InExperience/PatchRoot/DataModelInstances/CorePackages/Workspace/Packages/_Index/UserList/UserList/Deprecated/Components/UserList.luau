local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local useDispatch = require(UserListParent.RoactUtils).Hooks.RoactRodux.useDispatch
local NetworkingPresence = require(UserList.Networking.NetworkingPresence)
local View = require(UserListParent.Foundation).View
local NavigateDown = require(UserListParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(UserListParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v9 = if not FFlagSignalsNavP3Dispatch then nil else require(UserListParent.RobloxAppNavigation).NavigationCommands
local AppPage = require(UserListParent.RobloxAppEnums).AppPage
local Constants = require(UserList.Common.Constants)
local UserRowWrapper = require(script.Parent.UserRowWrapper)

local function UserList2(t1: {[any]: any}) -- line: 25
	-- upvalues: useDispatch (copy), React (copy), AppPage (copy), Constants (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy), NetworkingPresence (copy), View (copy), UserRowWrapper (copy)
	local v15 = useDispatch()
	local v16 = React.useCallback(function(s1: string) -- line: 28
		-- upvalues: t1 (copy), AppPage (copy), Constants (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), v15 (copy), NavigateDown (copy)
		if t1.onUserSelected then
			t1.onUserSelected(s1)

			return
		end

		local t2 = {
			name = AppPage.ProfilePlatform,
			detail = s1,
			extraProps = {
				profileType = Constants.PROFILE_TYPE
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v9.down(v9.fromLegacyPage(t2))

			return
		end

		v15(NavigateDown(t2))
	end, {
		t1.onUserSelected,
		v15
	})

	React.useEffect(function() -- line: 49
		-- upvalues: t1 (copy), v15 (copy), NetworkingPresence (copy)
		if #t1.userIds > 0 then
			v15(NetworkingPresence.GetPresencesFromUserIds.API(t1.userIds))
		end
	end, { t1.userIds })

	if #t1.userIds == 0 then
		return nil
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-large",
		LayoutOrder = t1.layoutOrder or 0
	}, {
		UserRows = React.createElement(React.Fragment, {}, unpack(React.useMemo(function() -- line: 66
			-- upvalues: t1 (copy), React (copy), UserRowWrapper (copy), v16 (copy)
			local t3 = {}

			for i, v in ipairs(t1.userIds) do
				t3[i] = React.createElement(UserRowWrapper, {
					userId = v,
					LayoutOrder = i,
					onActivated = v16
				})
			end

			return t3
		end, { t1.userIds })))
	})
end

return UserList2
