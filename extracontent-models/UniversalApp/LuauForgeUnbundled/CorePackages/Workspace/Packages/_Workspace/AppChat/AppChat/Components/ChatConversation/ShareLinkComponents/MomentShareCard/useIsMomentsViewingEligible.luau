local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")

local fFlagEnableArgus = SharedFlags.FFlagEnableArgus

local GetMomentsCapabilities = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/MomentsCommon/GetMomentsCapabilities")

local function useIsMomentsViewingEligible()
	local v5 = SignalsReact.useSignalState(GetMomentsCapabilities(false).getHasMomentsAccess)

	return fFlagEnableArgus and v5
end

return useIsMomentsViewingEligible
