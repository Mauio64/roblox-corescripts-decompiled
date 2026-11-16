local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage

local module = require("@luauforge/bundled/eeD")

local addFriendsScreen = require("@luauforge/deferred/eeL").AddFriendsScreen

local function AddFriendsUniversalAppWrapper()
	local v5 = useDispatch()

	local v6 = React.useCallback(function(...)
		return v5(module(...))
	end, { v5 })

	local v7 = React.useMemo(function()
		return { [appPage.ProfileQRCodePage] = v6 }
	end, { v6 })

	return React.createElement(addFriendsScreen, { navigateToLuaAppPages = v7 })
end

return AddFriendsUniversalAppWrapper
