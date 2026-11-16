local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local createCurrentTimeSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsUtils").createCurrentTimeSignal

local getUserSendEligibilityStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getUserSendEligibilityStatus")

local function areResultsEqual(p2, p3): boolean
	return p2.isEligible == p3.isEligible and p2.isLoading == p3.isLoading
end

local function useExternalChatUserEligibility(p2)
	local v5 = React.useMemo(function()
		return createCurrentTimeSignal(1)
	end, {})

	local v6 = React.useMemo(function()
		return Signals.createComputed(function(p3)
			if not p2.isActive then
				return { isEligible = false, isLoading = true }
			end

			local v7 = getUserSendEligibilityStatus({
				currentTimestamp = v5(p3),
				isAvailable = true,
				scope = p3
			})

			return {
				isEligible = v7 == "eligible",
				isLoading = v7 == "loading"
			}
		end, areResultsEqual)
	end, { v5, p2.isActive })

	return SignalsReact.useSignalState(v6)
end

return useExternalChatUserEligibility
