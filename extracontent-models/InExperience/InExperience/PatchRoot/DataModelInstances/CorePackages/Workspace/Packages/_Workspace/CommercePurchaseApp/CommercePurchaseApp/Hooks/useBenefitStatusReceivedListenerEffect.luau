local CommerceService = game:GetService("CommerceService")

local parent = script:FindFirstAncestor("CommercePurchaseApp").Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local ToastRodux = require(parent.ToastRodux)
local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local function useBenefitStatusReceivedListenerEffect()
	local v = useDispatch()
	local v2 = useLocalization({
		granted = "CoreScripts.CommercePurchasePrompt.SuccessToast.Granted",
		pending = "CoreScripts.CommercePurchasePrompt.SuccessToast.GrantPending"
	})

	React.useEffect(function()
		local benefitStatusReceivedConnection

		if v then
			benefitStatusReceivedConnection = CommerceService.BenefitStatusReceived:Connect(function(p)
				local v3

				if p then
					v3 = { toastType = ToastType.SuccessConfirmation, toastTitle = v2.granted }
				else
					v3 = { toastType = ToastType.NetworkingError, toastTitle = v2.pending }
				end

				v(SetCurrentToastMessage(v3))
			end)
		else
			benefitStatusReceivedConnection = nil
		end

		return function()
			if benefitStatusReceivedConnection then
				benefitStatusReceivedConnection:Disconnect()
				benefitStatusReceivedConnection = nil
			end
		end
	end, { v, v2 })
end
return useBenefitStatusReceivedListenerEffect
