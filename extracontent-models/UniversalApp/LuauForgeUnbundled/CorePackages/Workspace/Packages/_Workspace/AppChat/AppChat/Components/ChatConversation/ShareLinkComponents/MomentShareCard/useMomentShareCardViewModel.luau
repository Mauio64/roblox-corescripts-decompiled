local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/MomentsTypes")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserProfiles")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/MomentShareCardView")

local MomentDetailsStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/MomentDetailsStatus")
local buildMomentShareCardMedia = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/buildMomentShareCardMedia")

local getMomentShareCardCornerRadii = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/getMomentShareCardCornerRadii")
local resolveMomentShareCardMetadataText = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/resolveMomentShareCardMetadataText")
local useExperienceName = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/useExperienceName")
local useIsMomentsViewingEligible = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/useIsMomentsViewingEligible")
local useMomentDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/useMomentDetails")
local useMomentShareCardVideoFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/useMomentShareCardVideoFrame")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
local FFlagAppChatMomentShareCardLoadingSkeletons = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMomentShareCardLoadingSkeletons")
local FFlagAppChatMomentShareCardEdgeCases = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMomentShareCardEdgeCases")
local FFlagAppChatUseUserProfileHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseUserProfileHydration")
local useProfileName = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useProfileName")
local dataStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration").DataStatus

local useScaledValue = Foundation.Hooks.useScaledValue
local useAssetFetchStatus = RoactUtils.Hooks.useAssetFetchStatus
local useTokens = Foundation.Hooks.useTokens

local function useMomentShareCardViewModel(data)
	local v5 = useMomentDetails(data.momentId, data.targetIdType)
	local status = v5.status
	local v6 = useScaledValue(Constants.GameCard.THUMBNAIL_WIDTH)
	local v7 = useTokens()

	local v8 = not FFlagAppChatMomentShareCardEdgeCases or useIsMomentsViewingEligible()
	local v9 = FFlagAppChatMomentShareCardEdgeCases and not v8
	local creatorId = v5.creatorId
	local v10 = nil
	local v11 = nil

	if FFlagAppChatUseUserProfileHydration then
		local v13 = if creatorId then tostring(creatorId) else nil
		v11 = useProfileName(v13)
	else
		v10 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = creatorId and { (tostring(creatorId)) } or {},
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
		})
	end

	local v12

	if FFlagAppChatUseUserProfileHydration then
		v12 = v11.username
	elseif creatorId and v10.data then
		v12 = UserProfiles.Selectors.getUsernameFromId(v10.data, creatorId)
	end

	local v13 = resolveMomentShareCardMetadataText(v5.description, nil, nil)
	local v14 = resolveMomentShareCardMetadataText(nil, v5.experienceName, nil)
	local v15 = v13 == nil and v14 == nil
	local v16 = useExperienceName(v5.universeId, v15)

	local v17 = resolveMomentShareCardMetadataText(v13, v14, v16.name)
	local v18 = status == MomentDetailsStatus.Loading
	local v19

	if FFlagAppChatUseUserProfileHydration then
		v19 = not (creatorId == nil) and v11.status == dataStatus.NotReady
	else
		v19 = not (creatorId == nil) and (v10.loading == true or v10.isRetrying == true)
	end

	local v20 = FFlagAppChatMomentShareCardLoadingSkeletons

	if v20 then
		v20 = v12 == nil and (v18 or v19)
	end

	local v21 = FFlagAppChatMomentShareCardLoadingSkeletons

	if v21 then
		v21 = v17 == nil and (v18 or v16.isLoading)
	end

	local assetId = v5.assetId
	local captureType = v5.captureType
	local assetAccessContext = v5.assetAccessContext
	local v22 = React.useMemo(function()
		if v9 or status ~= MomentDetailsStatus.Ready then
			return nil
		end

		return buildMomentShareCardMedia({
			assetId = assetId,
			captureType = captureType,
			assetAccessContext = assetAccessContext
		})
	end, { v9, status, assetId, captureType, assetAccessContext })

	local v23 = not (v22 == nil) and v22.captureType == Enum.CaptureType.Video
	local v24 = if not (v22 == nil or v22.captureType ~= Enum.CaptureType.Video) then v22.content else nil
	local v25 = useMomentShareCardVideoFrame(v24)
	local v26 = if v22 ~= nil then (if v23 then v25 else v22.posterContent) else nil
	local v27 = if not (v23 or v26 == nil) then v26.Uri else nil
	local v28 = useAssetFetchStatus(v27) == Enum.AssetFetchStatus.Success

	if v23 then
		v28 = v25 ~= nil
	end

	local size_500 = v7.Size.Size_500

	local v29 = React.useMemo(function()
		return getMomentShareCardCornerRadii(data.isStartOfGroup, data.isIncoming, size_500)
	end, { data.isStartOfGroup, data.isIncoming, size_500 })

	local openMomentsDeepLink = data.openMomentsDeepLink
	local v30 = React.useCallback(function()
		if v9 then
			return
		end

		if openMomentsDeepLink and v5.status == MomentDetailsStatus.Ready then
			openMomentsDeepLink(data.momentId, data.targetIdType)
		end
	end, { v9, openMomentsDeepLink, v5.status, data.momentId, data.targetIdType })

	local v32 = if v9 then MomentDetailsStatus.Locked else v5.status
	local v31 = {
		status = v32,
		mediaSize = v6,
		hasMedia = not v9 and (status == MomentDetailsStatus.Loading or v22 ~= nil),
		isVideo = v23,
		playIconStyle = v7.Color.Content.Emphasis,
		posterContent = v26,
		isPosterLoaded = v28,
		cornerRadii = v29,
		username = v12,
		metadataText = v17,
		isUsernameLoading = v20,
		isMetadataLoading = v21,
		onActivated = v30,
		selectable = 0,
		LayoutOrder = 0
	}

	local v33 = not v9

	if v33 then
		v33 = status == MomentDetailsStatus.Ready and openMomentsDeepLink ~= nil
	end

	v31.selectable = v33
	v31.LayoutOrder = data.LayoutOrder
	return v31
end

return useMomentShareCardViewModel
