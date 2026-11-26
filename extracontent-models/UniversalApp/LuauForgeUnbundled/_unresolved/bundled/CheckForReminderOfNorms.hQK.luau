local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local loginStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").LoginStatus

local module = require("@luauforge/bundled/egx")
local module2 = require("@luauforge/bundled/eie")

local module3 = require("@luauforge/bundled/hQL")
local fFlagUseSignalsForAuthenticationStatus = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/ggh").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local function CheckForReminderOfNorms(p2): nil
	local v5

	if fFlagUseSignalsForAuthenticationStatus then
		v5 = useSignalState(getAuthenticationStatusStore(false).getStatus) == loginStatus.LOGGED_IN
	else
		v5 = useSelector(function(p3): boolean
			return p3.AuthenticationStatus.status == loginStatus.LOGGED_IN
		end)
	end

	local v6 = useSelector(function(p3)
		return p3.LocalUserId
	end)

	local v7 = useDispatch()
	local v8 = module2(module)

	React.useEffect(function(): nil
		if v5 then
			v7(module3(v8)):catch(function() end)
		end

		return nil
	end, { v5, v6, v8 })
	return nil
end

return CheckForReminderOfNorms
