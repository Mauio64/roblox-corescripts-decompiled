local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local SignalsUtils = require(parent.SignalsUtils)
local createCurrentTimeSignal = SignalsUtils.createCurrentTimeSignal

local getUserSendEligibilityStatus = require(AppChat.Utils.getUserSendEligibilityStatus)

local function areResultsEqual(p, p2): boolean
	return p.isEligible == p2.isEligible and p.isLoading == p2.isLoading
end

local function useExternalChatUserEligibility(p)
	local v = React.useMemo(function()
		return createCurrentTimeSignal(1)
	end, {})

	local v2 = React.useMemo(function()
		return Signals.createComputed(function(scope)
			if not p.isActive then
				return { isEligible = false, isLoading = true }
			end

			local userSendEligibilityStatus = getUserSendEligibilityStatus({
				currentTimestamp = v(scope),
				isAvailable = true,
				scope = scope
			})

			return {
				isEligible = userSendEligibilityStatus == "eligible",
				isLoading = userSendEligibilityStatus == "loading"
			}
		end, areResultsEqual)
	end, { v, p.isActive })

	return SignalsReact.useSignalState(v2)
end

return useExternalChatUserEligibility
