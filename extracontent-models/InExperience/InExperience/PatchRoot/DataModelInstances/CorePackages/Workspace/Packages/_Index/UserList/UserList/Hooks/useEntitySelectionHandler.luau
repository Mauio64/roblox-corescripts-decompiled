local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
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
local Enums = require(UserList.Common.Enums)
require(UserList.Common.Types)

local FFlagUserListRowSelectionOriginSource = require(UserList.Flags.FFlagUserListRowSelectionOriginSource)

local function useEntitySelectionHandler(callback, p)
	local v = useDispatch()

	return (React.useCallback(function(detail: string, p2)
		if callback then
			callback(detail, p2)
			return
		end

		local v2 = { name = AppPage.ProfilePlatform, detail = detail, extraProps = 0 }
		local profileType

		if p2 == Enums.EntityType.Contact then
			profileType = Enums.EntityType.Contact
		else
			profileType = Enums.EntityType.User
		end

		local friendshipOriginSourceType

		if FFlagUserListRowSelectionOriginSource and p then
			friendshipOriginSourceType = p.friendshipOriginSourceType
		end

		v2.extraProps = {
			profileType = profileType,
			friendshipOriginSourceType = friendshipOriginSourceType
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v2))
		else
			v(NavigateDown(v2))
		end
	end, { callback, v, p or false }))
end

return useEntitySelectionHandler
