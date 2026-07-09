local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local MemStorageService = game:GetService("MemStorageService")
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local LoginStatus = require(CorePackages.Workspace.Packages.RobloxAppEnums).LoginStatus
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local MemStorageKeys = require(Modules.LuaApp.Enum.MemStorageKeys)
local ApiFetchReminderOfNorms = require(Modules.LuaApp.Thunks.Moderation.ApiFetchReminderOfNorms)
local GetFFlagEnableCachingforReminderOfNorms = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableCachingforReminderOfNorms

local function shouldFetchReminderOfNorms(p1, p2, p3) -- line: 19
	-- upvalues: MemStorageService (copy), MemStorageKeys (copy)
	if not p1 then
		return false
	end

	if not p2 then
		return true
	end

	return not MemStorageService:HasItem(MemStorageKeys.ReminderOfNorms) or p3 ~= MemStorageService:GetItem(MemStorageKeys.ReminderOfNorms)
end
local function CheckForReminderOfNorms(_) -- line: 34
	-- upvalues: useSelector (copy), LoginStatus (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), React (copy), GetFFlagEnableCachingforReminderOfNorms (copy), MemStorageService (copy), MemStorageKeys (copy), ApiFetchReminderOfNorms (copy)
	local v19 = useSelector(function(p5) -- line: 35
		-- upvalues: LoginStatus (copy)
		return p5.AuthenticationStatus.status == LoginStatus.LOGGED_IN
	end)
	local v20 = useSelector(function(p6) -- line: 38
		return p6.LocalUserId
	end)
	local v21 = useDispatch()
	local v22 = useRoactService(RoactNetworking)

	React.useEffect(function() -- line: 45
		-- upvalues: v19 (copy), GetFFlagEnableCachingforReminderOfNorms (copy), v20 (copy), MemStorageService (copy), MemStorageKeys (copy), v21 (copy), ApiFetchReminderOfNorms (copy), v22 (copy)
		local v25 = v19
		local v26 = GetFFlagEnableCachingforReminderOfNorms()
		local v27 = v20

		if if v25 then not v26 or (not MemStorageService:HasItem(MemStorageKeys.ReminderOfNorms) or v27 ~= MemStorageService:GetItem(MemStorageKeys.ReminderOfNorms)) else false then
			v21(ApiFetchReminderOfNorms(v22)):andThen(function() -- line: 48
				-- upvalues: MemStorageService (copy), MemStorageKeys (copy), v20 (copy)
				MemStorageService:SetItem(MemStorageKeys.ReminderOfNorms, v20)
			end):catch(function() -- line: 51
			end)
		end

		return nil
	end, {
		v19,
		v20,
		v22
	})

	return nil
end

return CheckForReminderOfNorms
