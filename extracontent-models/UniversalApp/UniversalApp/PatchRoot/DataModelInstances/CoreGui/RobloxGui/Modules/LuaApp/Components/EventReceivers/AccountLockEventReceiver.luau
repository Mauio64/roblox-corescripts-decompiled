local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local SetCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Actions.SetCentralOverlay
local CentralOverlayType = require(CorePackages.Workspace.Packages.RobloxAppEnums).CentralOverlayType
local FFlagAccountLockReceiverClosesModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAccountLockReceiverClosesModal
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RestrictionSource = require(Modules.LuaApp.Models.UserModerationApi.RestrictionSource)
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local ApiFetchAccessStatus = require(Modules.LuaApp.Thunks.Moderation.ApiFetchAccessStatus)
local ChallengeError = require(Modules.LuaApp.Util.ChallengeError)

local function AccountLockEventReceiver() -- line: 35
	-- upvalues: useDispatch (copy), useSelector (copy), FFlagAccountLockReceiverClosesModal (copy), React (copy), RestrictionSource (copy), SetCentralOverlay (copy), CentralOverlayType (copy), Logout (copy), ResetNavigationHistory (copy), ApiFetchAccessStatus (copy), ChallengeError (copy)
	local v15 = useDispatch()
	local v16 = useSelector(function(p1) -- line: 37
		return p1.UserAccess
	end)
	local u17 = nil

	if FFlagAccountLockReceiverClosesModal then
		u17 = useSelector(function(p2) -- line: 43
			return p2.CentralOverlay and p2.CentralOverlay.OverlayType
		end)
	end

	React.useEffect(function() -- line: 48
		-- upvalues: v16 (copy), RestrictionSource (copy), v15 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), Logout (copy), ResetNavigationHistory (copy), ApiFetchAccessStatus (copy), ChallengeError (copy)
		if not v16 or (not v16.restrictionDetail or v16.restrictionDetail.source ~= RestrictionSource.AccountLock) then
			return
		end

		v15(SetCentralOverlay(CentralOverlayType.AccountLockModal, {
			Logout = Logout,
			ResetNavigationHistory = ResetNavigationHistory,
			ApiFetchAccessStatus = ApiFetchAccessStatus,
			ChallengeError = ChallengeError
		}))
	end, { v16 })

	if FFlagAccountLockReceiverClosesModal then
		React.useEffect(function() -- line: 68
			-- upvalues: v16 (copy), RestrictionSource (copy), u17 (ref), CentralOverlayType (copy), v15 (copy), SetCentralOverlay (copy)
			local v20 = v16 and v16.restrictionDetail

			if (not v20 or v20.source ~= RestrictionSource.AccountLock) and u17 == CentralOverlayType.AccountLockModal then
				v15(SetCentralOverlay())
			end
		end, {
			v16,
			u17,
			v15
		})
	end

	return nil
end

return AccountLockEventReceiver
