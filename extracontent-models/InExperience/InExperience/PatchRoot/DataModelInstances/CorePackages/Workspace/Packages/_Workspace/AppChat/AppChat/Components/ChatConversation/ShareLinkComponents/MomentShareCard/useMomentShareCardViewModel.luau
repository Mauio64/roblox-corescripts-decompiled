local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.MomentsTypes)
local RoactUtils = require(parent.RoactUtils)
local UserProfiles = require(parent.UserProfiles)

require(script.Parent.MomentShareCardView)

local MomentDetailsStatus = require(script.Parent.MomentDetailsStatus)
local buildMomentShareCardMedia = require(script.Parent.buildMomentShareCardMedia)

local getMomentShareCardCornerRadii = require(script.Parent.getMomentShareCardCornerRadii)
local resolveMomentShareCardMetadataText = require(script.Parent.resolveMomentShareCardMetadataText)
local useExperienceName = require(script.Parent.useExperienceName)
local useIsMomentsViewingEligible = require(script.Parent.useIsMomentsViewingEligible)
local useMomentDetails = require(script.Parent.useMomentDetails)
local useMomentShareCardVideoFrame = require(script.Parent.useMomentShareCardVideoFrame)

local Constants = require(AppChat.Constants)
local FFlagAppChatMomentShareCardLoadingSkeletons = require(AppChat.Flags.FFlagAppChatMomentShareCardLoadingSkeletons)
local FFlagAppChatMomentShareCardEdgeCases = require(AppChat.Flags.FFlagAppChatMomentShareCardEdgeCases)
local FFlagAppChatUseUserProfileHydration = require(AppChat.Flags.FFlagAppChatUseUserProfileHydration)
local useProfileName = require(AppChat.Hooks.useProfileName)
local DataHydration = require(parent.DataHydration)
local DataStatus = DataHydration.DataStatus

local useScaledValue = Foundation.Hooks.useScaledValue
local useAssetFetchStatus = RoactUtils.Hooks.useAssetFetchStatus
local useTokens = Foundation.Hooks.useTokens

local function useMomentShareCardViewModel(data)
	local v = useMomentDetails(data.momentId, data.targetIdType)
	local status = v.status
	local mediaSize = useScaledValue(Constants.GameCard.THUMBNAIL_WIDTH)
	local v2 = useTokens()

	local v3 = not FFlagAppChatMomentShareCardEdgeCases or useIsMomentsViewingEligible()
	local v4 = FFlagAppChatMomentShareCardEdgeCases and not v3
	local creatorId = v.creatorId
	local v5 = nil
	local v6 = nil

	if FFlagAppChatUseUserProfileHydration then
		local v7

		if creatorId then
			v7 = tostring(creatorId)
		end

		v6 = useProfileName(v7)
	else
		v5 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = creatorId and { (tostring(creatorId)) } or {},
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
		})
	end

	local username

	if FFlagAppChatUseUserProfileHydration then
		username = v6.username
	elseif creatorId and v5.data then
		username = UserProfiles.Selectors.getUsernameFromId(v5.data, creatorId)
	end

	local momentShareCardMetadataText = resolveMomentShareCardMetadataText(v.description, nil, nil)
	local momentShareCardMetadataText2 = resolveMomentShareCardMetadataText(nil, v.experienceName, nil)
	local v7

	if momentShareCardMetadataText == nil then
		v7 = momentShareCardMetadataText2 == nil
	else
		v7 = false
	end

	local v8 = useExperienceName(v.universeId, v7)

	local momentShareCardMetadataText3 = resolveMomentShareCardMetadataText(
		momentShareCardMetadataText,
		momentShareCardMetadataText2,
		v8.name
	)
	local v9 = status == MomentDetailsStatus.Loading
	local v10

	if FFlagAppChatUseUserProfileHydration then
		if creatorId == nil then
			v10 = false
		else
			v10 = v6.status == DataStatus.NotReady
		end
	elseif creatorId == nil then
		v10 = false
	else
		v10 = v5.loading == true or v5.isRetrying == true
	end

	local isUsernameLoading = FFlagAppChatMomentShareCardLoadingSkeletons

	if isUsernameLoading then
		if username == nil then
			isUsernameLoading = v9 or v10
		else
			isUsernameLoading = false
		end
	end

	local isMetadataLoading = FFlagAppChatMomentShareCardLoadingSkeletons

	if isMetadataLoading then
		if momentShareCardMetadataText3 == nil then
			isMetadataLoading = v9 or v8.isLoading
		else
			isMetadataLoading = false
		end
	end

	local assetId = v.assetId
	local captureType = v.captureType
	local assetAccessContext = v.assetAccessContext
	local v11 = React.useMemo(function()
		if v4 or status ~= MomentDetailsStatus.Ready then
			return nil
		end

		return buildMomentShareCardMedia({
			assetId = assetId,
			captureType = captureType,
			assetAccessContext = assetAccessContext
		})
	end, { v4, status, assetId, captureType, assetAccessContext })
	local isVideo

	if v11 == nil then
		isVideo = false
	else
		isVideo = v11.captureType == Enum.CaptureType.Video
	end

	local v12

	if not (v11 == nil or v11.captureType ~= Enum.CaptureType.Video) then
		v12 = v11.content
	end

	local v13 = useMomentShareCardVideoFrame(v12)
	local posterContent

	if v11 ~= nil then
		posterContent = if isVideo then v13 else v11.posterContent
	end

	local v14

	if not (isVideo or posterContent == nil) then
		v14 = posterContent.Uri
	end

	local isPosterLoaded = useAssetFetchStatus(v14) == Enum.AssetFetchStatus.Success

	if isVideo then
		isPosterLoaded = v13 ~= nil
	end

	local size_500 = v2.Size.Size_500

	local cornerRadii = React.useMemo(function()
		return getMomentShareCardCornerRadii(data.isStartOfGroup, data.isIncoming, size_500)
	end, { data.isStartOfGroup, data.isIncoming, size_500 })

	local openMomentsDeepLink = data.openMomentsDeepLink
	local onActivated = React.useCallback(function()
		if v4 then
			return
		end

		if openMomentsDeepLink and v.status == MomentDetailsStatus.Ready then
			openMomentsDeepLink(data.momentId, data.targetIdType)
		end
	end, { v4, openMomentsDeepLink, v.status, data.momentId, data.targetIdType })

	local status2 = if v4 then MomentDetailsStatus.Locked else v.status
	local v15 = {
		status = status2,
		mediaSize = mediaSize,
		hasMedia = not v4 and (status == MomentDetailsStatus.Loading or v11 ~= nil),
		isVideo = isVideo,
		playIconStyle = v2.Color.Content.Emphasis,
		posterContent = posterContent,
		isPosterLoaded = isPosterLoaded,
		cornerRadii = cornerRadii,
		username = username,
		metadataText = momentShareCardMetadataText3,
		isUsernameLoading = isUsernameLoading,
		isMetadataLoading = isMetadataLoading,
		onActivated = onActivated,
		selectable = 0,
		LayoutOrder = 0
	}

	local selectable = not v4

	if selectable then
		if status == MomentDetailsStatus.Ready then
			selectable = openMomentsDeepLink ~= nil
		else
			selectable = false
		end
	end

	v15.selectable = selectable
	v15.LayoutOrder = data.LayoutOrder
	return v15
end

return useMomentShareCardViewModel
