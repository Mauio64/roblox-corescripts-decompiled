local Parent = script:FindFirstAncestor("AccountLockModal").Parent
local useCallback = require(Parent.React).useCallback
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local RoactNetworking = require(Parent.RoactServiceTags).RoactNetworking
local AppGuiService = require(Parent.RoactServiceTags).AppGuiService
local Responsive = require(Parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local LogoutReasonNames = require(Parent.AuthCommon).Enums.LogoutReasonNames
local ConsoleDisconnect = require(Parent.AuthCommon).Thunks.ConsoleDisconnect

local function useLogout(p1: ((...any) -> ...any)) -- line: 23
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), AppGuiService (copy), usePreferredInput (copy), Responsive (copy), useCallback (copy), ConsoleDisconnect (copy), LogoutReasonNames (copy)
	local v13 = useDispatch()
	local v14 = useRoactService(RoactNetworking)
	local v15 = useRoactService(AppGuiService)
	local v16 = usePreferredInput() == Responsive.Input.Directional

	return (useCallback(function() -- line: 29
		-- upvalues: v16 (copy), v13 (copy), ConsoleDisconnect (copy), v14 (copy), v15 (copy), p1 (copy), LogoutReasonNames (copy)
		if v16 then
			v13(ConsoleDisconnect(v14, v15, p1))

			return
		end

		v13(p1(v14, v15, LogoutReasonNames.AccountLock))
	end, {
		v13,
		v14,
		v15,
		p1,
		v16
	}))
end

return useLogout
