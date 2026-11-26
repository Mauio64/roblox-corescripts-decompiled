local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local getMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities

local fFlagMomentsComments = SharedFlags.FFlagMomentsComments
local fFlagMomentsCommentsIxpEnabled = SharedFlags.FFlagMomentsCommentsIxpEnabled

local frozen = table.freeze({ canRead = true, canWrite = true, canReact = true })

local function useGuacCommentCapabilities()
	local momentsCapabilities = getMomentsCapabilities(false)
	return {
		canRead = SignalsReact.useSignalState(momentsCapabilities.getCanReadComments),
		canWrite = SignalsReact.useSignalState(momentsCapabilities.getCanWriteComments),
		canReact = SignalsReact.useSignalState(momentsCapabilities.getCanReactToComments)
	}
end

local function useAllowedCommentCapabilities()
	return frozen
end

if fFlagMomentsComments or fFlagMomentsCommentsIxpEnabled then
	return useGuacCommentCapabilities
end

return useAllowedCommentCapabilities
