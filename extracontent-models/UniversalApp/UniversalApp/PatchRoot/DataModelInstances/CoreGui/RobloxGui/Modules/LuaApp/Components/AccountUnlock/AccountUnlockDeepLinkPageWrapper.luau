local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local AccountUnlockDeepLinkPage = require(CorePackages.Workspace.Packages.AccountLockModal).AccountUnlockDeepLinkPage
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local ApiFetchAccessStatus = require(Modules.LuaApp.Thunks.Moderation.ApiFetchAccessStatus)

return function(p1) -- line: 20
	-- upvalues: React (copy), AccountUnlockDeepLinkPage (copy), Cryo (copy), ResetNavigationHistory (copy), ApiFetchAccessStatus (copy), CloseCentralOverlay (copy)
	return React.createElement(AccountUnlockDeepLinkPage, Cryo.Dictionary.join(p1 or {}, {
		ResetNavigationHistory = ResetNavigationHistory,
		ApiFetchAccessStatus = ApiFetchAccessStatus,
		closeCentralOverlayThunk = CloseCentralOverlay
	}))
end
