local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Actions.SetCentralOverlay
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").CentralOverlayType

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAccountLockReceiverClosesModal = SharedFlags.FFlagAccountLockReceiverClosesModal
local fFlagUseSignalsForUserAccess = SharedFlags.FFlagUseSignalsForUserAccess

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local getUserAccessStore = if fFlagUseSignalsForUserAccess then require("@luauforge/bundled/gin").GetUserAccessStore else nil

local module2 = require("@luauforge/bundled/gie")
local module3 = require("@luauforge/bundled/ggi")
local module4 = require("@luauforge/bundled/dKv")
local module5 = require("@luauforge/bundled/gXF")
local module6 = require("@luauforge/bundled/ilj")

local function AccountLockEventReceiver(): nil
	local v5 = useDispatch()
	local v6

	if fFlagUseSignalsForUserAccess then
		v6 = useSignalState(getUserAccessStore(false).getUserAccessRestrictionDetail)
	else
		v6 = nil
	end

	local v7

	if fFlagUseSignalsForUserAccess then
		v7 = React.useMemo(function()
			return { restrictionDetail = v6 }
		end, { v6 })
	else
		v7 = useSelector(function(p2)
			return p2.UserAccess
		end)
	end

	local v8

	if fFlagAccountLockReceiverClosesModal then
		v8 = useSelector(function(p2)
			return p2.CentralOverlay and p2.CentralOverlay.OverlayType
		end)
	else
		v8 = nil
	end

	React.useEffect(function()
		if not v7 or not v7.restrictionDetail or v7.restrictionDetail.source ~= module2.AccountLock then
			return
		end

		v5(setCentralOverlay(centralOverlayType.AccountLockModal, {
			Logout = module3,
			ResetNavigationHistory = module4,
			ApiFetchAccessStatus = module5,
			ChallengeError = module6
		}))
	end, { v7 })

	if fFlagAccountLockReceiverClosesModal then
		React.useEffect(function()
			local restrictionDetail = v7 and v7.restrictionDetail

			if
				(not restrictionDetail or restrictionDetail.source ~= module2.AccountLock)
				and v8 == centralOverlayType.AccountLockModal
			then
				v5(setCentralOverlay())
			end
		end, { v7, v8, v5 })
	end

	return nil
end

return AccountLockEventReceiver
