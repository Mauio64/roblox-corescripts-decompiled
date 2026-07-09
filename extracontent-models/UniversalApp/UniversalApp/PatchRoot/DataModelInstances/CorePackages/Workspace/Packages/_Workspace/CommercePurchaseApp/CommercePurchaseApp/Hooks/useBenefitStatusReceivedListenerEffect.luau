local CommerceService = game:GetService("CommerceService")
local Parent = script:FindFirstAncestor("CommercePurchaseApp").Parent
local React = require(Parent.React)
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local ToastRodux = require(Parent.ToastRodux)
local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local function useBenefitStatusReceivedListenerEffect() -- line: 13
	-- upvalues: useDispatch (copy), useLocalization (copy), React (copy), CommerceService (copy), ToastType (copy), SetCurrentToastMessage (copy)
	local v10 = useDispatch()
	local v11 = useLocalization({
		granted = "CoreScripts.CommercePurchasePrompt.SuccessToast.Granted",
		pending = "CoreScripts.CommercePurchasePrompt.SuccessToast.GrantPending"
	})

	React.useEffect(function() -- line: 19
		-- upvalues: v10 (copy), CommerceService (copy), ToastType (copy), v11 (copy), SetCurrentToastMessage (copy)
		local connection = nil

		if v10 then
			connection = CommerceService.BenefitStatusReceived:Connect(function(p1) -- line: 22
				-- upvalues: ToastType (copy), v11 (copy), v10 (copy), SetCurrentToastMessage (copy)
				local v14 = if not p1 then {
					toastType = ToastType.NetworkingError,
					toastTitle = v11.pending
				} else {
					toastType = ToastType.SuccessConfirmation,
					toastTitle = v11.granted
				}

				v10(SetCurrentToastMessage(v14))
			end)
		end

		return function() -- line: 29
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end, {
		v10,
		v11
	})
end

return useBenefitStatusReceivedListenerEffect
