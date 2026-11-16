local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local MemStorageService = game:GetService("MemStorageService")

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local loginStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").LoginStatus

local module = require("@luauforge/bundled/eda")
local module2 = require("@luauforge/bundled/eeH")
local module3 = require("@luauforge/bundled/fBr")

local module4 = require("@luauforge/bundled/hFP")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local getFFlagEnableCachingforReminderOfNorms = SharedFlags.GetFFlagEnableCachingforReminderOfNorms
local fFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/fBO").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local function shouldFetchReminderOfNorms(p2, p3, p4): boolean
	if not p2 then
		return false
	end

	if p3 then
		return not MemStorageService:HasItem(module3.ReminderOfNorms)
			or p4 ~= MemStorageService:GetItem(module3.ReminderOfNorms)
	end

	return true
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
		local fFlagEnableCachingforReminderOfNorms = getFFlagEnableCachingforReminderOfNorms()
		local v10 = v6
		local v11

		if v5 then
			v11 = not fFlagEnableCachingforReminderOfNorms
				or (not MemStorageService:HasItem(module3.ReminderOfNorms) or v10 ~= MemStorageService:GetItem(module3.ReminderOfNorms))
		else
			v11 = false
		end

		if v11 then
			v7(module4(v8)):andThen(function()
				MemStorageService:SetItem(module3.ReminderOfNorms, v6)
			end):catch(function() end)
		end

		return nil
	end, { v5, v6, v8 })
	return nil
end

return CheckForReminderOfNorms
