local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local RestrictionSource = require(Modules.LuaApp.Models.UserModerationApi.RestrictionSource)

local function PlatformRestrictedEventReceiver() -- line: 17
	-- upvalues: useDispatch (copy), useSelector (copy), RestrictionSource (copy), React (copy), ResetNavigationHistory (copy), AppPage (copy), Logout (copy)
	local v13 = useDispatch()
	local v14 = useSelector(function(p1) -- line: 20
		-- upvalues: RestrictionSource (copy)
		return p1.UserAccess and (p1.UserAccess.restrictionDetail and p1.UserAccess.restrictionDetail.source == RestrictionSource.PlatformAccess)
	end)
	local v15 = React.useRef(false)

	React.useEffect(function() -- line: 28
		-- upvalues: v14 (copy), v15 (copy), v13 (copy), ResetNavigationHistory (copy), AppPage (copy), Logout (copy)
		if v14 and not v15.current then
			v15.current = true
			v13(ResetNavigationHistory({{
				name = AppPage.PlatformLockedPage,
				extraProps = {
					LogoutThunk = Logout
				}
			}}))
		end
	end, {
		v14,
		v13
	})

	return nil
end

return PlatformRestrictedEventReceiver
