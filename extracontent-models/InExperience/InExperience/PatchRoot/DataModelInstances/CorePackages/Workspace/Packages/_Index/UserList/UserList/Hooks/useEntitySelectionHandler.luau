local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local useDispatch = require(UserListParent.RoactUtils).Hooks.RoactRodux.useDispatch
local NavigateDown = require(UserListParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(UserListParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v7 = if not FFlagSignalsNavP3Dispatch then nil else require(UserListParent.RobloxAppNavigation).NavigationCommands
local AppPage = require(UserListParent.RobloxAppEnums).AppPage
local Enums = require(UserList.Common.Enums)

local function useEntitySelectionHandler(p1: ((...any) -> ...any)?) -- line: 21
	-- upvalues: useDispatch (copy), React (copy), AppPage (copy), Enums (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy)
	local v12 = useDispatch()

	return (React.useCallback(function(s1: string, p2) -- line: 26
		-- upvalues: p1 (copy), AppPage (copy), Enums (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), v12 (copy), NavigateDown (copy)
		if p1 then
			p1(s1, p2)

			return
		end

		local t1 = {
			name = AppPage.ProfilePlatform,
			detail = s1,
			extraProps = {
				profileType = if p2 ~= Enums.EntityType.Contact then Enums.EntityType.User else Enums.EntityType.Contact
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v7.down(v7.fromLegacyPage(t1))

			return
		end

		v12(NavigateDown(t1))
	end, {
		p1,
		v12
	}))
end

return useEntitySelectionHandler
