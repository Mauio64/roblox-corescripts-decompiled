local parent = script:FindFirstAncestor("Moments").Parent

local MomentsCommon = require(parent.MomentsCommon)
local SharedFlags = require(parent.SharedFlags)
local SignalsReact = require(parent.SignalsReact)

local GetMomentsCapabilities = MomentsCommon.Stores.GetMomentsCapabilities

local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local FFlagMomentsCommentsIxpEnabled = SharedFlags.FFlagMomentsCommentsIxpEnabled

local frozen = table.freeze({ canRead = true, canWrite = true, canReact = true })

local function useGuacCommentCapabilities()
	local momentsCapabilities = GetMomentsCapabilities(false)
	return {
		canRead = SignalsReact.useSignalState(momentsCapabilities.getCanReadComments),
		canWrite = SignalsReact.useSignalState(momentsCapabilities.getCanWriteComments),
		canReact = SignalsReact.useSignalState(momentsCapabilities.getCanReactToComments)
	}
end

local function useAllowedCommentCapabilities()
	return frozen
end

if FFlagMomentsComments or FFlagMomentsCommentsIxpEnabled then
	return useGuacCommentCapabilities
end

return useAllowedCommentCapabilities
