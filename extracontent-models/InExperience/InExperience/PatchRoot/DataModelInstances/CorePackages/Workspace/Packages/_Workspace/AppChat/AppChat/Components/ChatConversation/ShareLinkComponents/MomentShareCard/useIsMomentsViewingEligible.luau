local parent = script:FindFirstAncestor("AppChat").Parent

local SharedFlags = require(parent.SharedFlags)
local SignalsReact = require(parent.SignalsReact)

local FFlagEnableArgus = SharedFlags.FFlagEnableArgus

local GetMomentsCapabilities = require(parent.MomentsCommon.GetMomentsCapabilities)

local function useIsMomentsViewingEligible()
	local v = SignalsReact.useSignalState(GetMomentsCapabilities(false).getHasMomentsAccess)

	return FFlagEnableArgus and v
end

return useIsMomentsViewingEligible
