local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local DataHydration = require(parent.DataHydration)
local MomentsTypes = require(parent.MomentsTypes)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local GetMomentDetailsStore = require(AppChat.Stores.GetMomentDetailsStore)
local MomentDetailsStatus = require(script.Parent.MomentDetailsStatus)

local FFlagAppChatMomentShareCardEdgeCases = require(AppChat.Flags.FFlagAppChatMomentShareCardEdgeCases)

local MomentStatus = MomentsTypes.Enums.MomentStatus

local v = { metadata = {} }

local function useMomentDetails(p: string, p2)
	local momentDetailsStore = GetMomentDetailsStore(false)
	local v2 = React.useMemo(function()
		return momentDetailsStore.getAndFetchMomentDetails(p, p2)
	end, { momentDetailsStore, p, p2 })
	local v3 = SignalsReact.useSignalState(v2.data)
	local v4 = SignalsReact.useSignalState(v2.status)
	local v5 = v3 or v
	local metadata = v5.metadata
	local creatorId = v5.creatorId
	local description = metadata.description
	local universeId = metadata.universeId
	local experienceName = metadata.experienceName
	local likeCount = metadata.likeCount
	local assetId = v5.assetId
	local captureType = metadata.captureType
	local assetAccessContext = metadata.assetAccessContext
	local isModerated = v5.isModerated
	local status = v5.status

	return React.useMemo(function()
		if v3 == nil then
			if v4 == DataHydration.DataStatus.Failed then
				return { status = MomentDetailsStatus.Error }
			end

			return { status = MomentDetailsStatus.Loading }
		elseif FFlagAppChatMomentShareCardEdgeCases and (isModerated == true or status == MomentStatus.Deleted) then
			return { status = MomentDetailsStatus.Unavailable }
		else
			return {
				status = MomentDetailsStatus.Ready,
				creatorId = creatorId,
				description = description,
				universeId = universeId,
				experienceName = experienceName,
				likeCount = likeCount,
				assetId = assetId,
				captureType = captureType,
				assetAccessContext = assetAccessContext
			}
		end
	end, {
		v4,
		v3 ~= nil,
		creatorId,
		description,
		universeId,
		experienceName,
		likeCount,
		assetId,
		captureType,
		assetAccessContext,
		isModerated,
		status
	})
end

return useMomentDetails
