local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local Modules = script:FindFirstAncestor("Modules")
local NavigateDownTo3DQRCodePage = require(Modules.LuaApp.Thunks.NavigateDownTo3DQRCodePage)
local AddFriendsScreen = require(CorePackages.Workspace.Packages.AddFriends).AddFriendsScreen

local function AddFriendsUniversalAppWrapper() -- line: 14
	-- upvalues: useDispatch (copy), React (copy), NavigateDownTo3DQRCodePage (copy), AppPage (copy), AddFriendsScreen (copy)
	local v9 = useDispatch()
	local v10 = React.useCallback(function(...) -- line: 17
		-- upvalues: v9 (copy), NavigateDownTo3DQRCodePage (copy)
		return v9(NavigateDownTo3DQRCodePage(...))
	end, { v9 })
	local v11 = React.useMemo(function() -- line: 21
		-- upvalues: AppPage (copy), v10 (copy)
		return {
			[AppPage.ProfileQRCodePage] = v10
		}
	end, { v10 })

	return React.createElement(AddFriendsScreen, {
		navigateToLuaAppPages = v11
	})
end

return AddFriendsUniversalAppWrapper
