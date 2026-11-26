local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local MomentsTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/MomentsTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")

local GetMomentDetailsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetMomentDetailsStore")
local MomentDetailsStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/MomentDetailsStatus")

local FFlagAppChatMomentShareCardEdgeCases = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMomentShareCardEdgeCases")

local momentStatus = MomentsTypes.Enums.MomentStatus

local v5 = { metadata = {} }

local function useMomentDetails(p2, p3)
	local v6 = GetMomentDetailsStore(false)
	local v7 = React.useMemo(function()
		return v6.getAndFetchMomentDetails(p2, p3)
	end, { v6, p2, p3 })
	local v8 = SignalsReact.useSignalState(v7.data)
	local v9 = SignalsReact.useSignalState(v7.status)
	local v10 = v8 or v5
	local metadata = v10.metadata
	local creatorId = v10.creatorId
	local description = metadata.description
	local universeId = metadata.universeId
	local experienceName = metadata.experienceName
	local likeCount = metadata.likeCount
	local assetId = v10.assetId
	local captureType = metadata.captureType
	local assetAccessContext = metadata.assetAccessContext
	local isModerated = v10.isModerated
	local status = v10.status

	return React.useMemo(function()
		if v8 == nil then
			if v9 == DataHydration.DataStatus.Failed then
				return { status = MomentDetailsStatus.Error }
			end

			return { status = MomentDetailsStatus.Loading }
		elseif FFlagAppChatMomentShareCardEdgeCases and (isModerated == true or status == momentStatus.Deleted) then
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
		v9,
		v8 ~= nil,
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
