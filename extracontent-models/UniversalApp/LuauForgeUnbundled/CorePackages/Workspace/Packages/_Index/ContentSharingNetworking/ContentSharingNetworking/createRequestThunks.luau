local fFlagContentFeedEnableReactions = require("@game/CorePackages/Workspace/Packages/_Workspace/ContentSharingNetworking/SharedFlags").FFlagContentFeedEnableReactions

local createAddReaction = require("@game/CorePackages/Workspace/Packages/_Index/ContentSharingNetworking/ContentSharingNetworking/networkRequests/createAddReaction")
local createCheckMomentsEligibility = require("@game/CorePackages/Workspace/Packages/_Index/ContentSharingNetworking/ContentSharingNetworking/networkRequests/createCheckMomentsEligibility")
local createDeletePost = require("@game/CorePackages/Workspace/Packages/_Index/ContentSharingNetworking/ContentSharingNetworking/networkRequests/createDeletePost")
local createGetPostsByCursor = require("@game/CorePackages/Workspace/Packages/_Index/ContentSharingNetworking/ContentSharingNetworking/networkRequests/createGetPostsByCursor")
local createGetPostsByPostId = require("@game/CorePackages/Workspace/Packages/_Index/ContentSharingNetworking/ContentSharingNetworking/networkRequests/createGetPostsByPostId")
local createGetPostsByUserId = require("@game/CorePackages/Workspace/Packages/_Index/ContentSharingNetworking/ContentSharingNetworking/networkRequests/createGetPostsByUserId")
local createGetThumbnailByAssetId = require("@game/CorePackages/Workspace/Packages/_Index/ContentSharingNetworking/ContentSharingNetworking/networkRequests/createGetThumbnailByAssetId")
local createRemoveReaction = require("@game/CorePackages/Workspace/Packages/_Index/ContentSharingNetworking/ContentSharingNetworking/networkRequests/createRemoveReaction")

return function(p2)
	local v6 = if fFlagContentFeedEnableReactions then createAddReaction(p2) else nil
	local v5 = {
		AddReaction = v6,
		CheckMomentsEligibility = createCheckMomentsEligibility(p2),
		DeletePost = createDeletePost(p2),
		GetActiveCategories = require("@game/CorePackages/Workspace/Packages/_Index/ContentSharingNetworking/ContentSharingNetworking/networkRequests/createGetActiveCategories")(p2),
		GetPostsByCursor = createGetPostsByCursor(p2),
		GetPostsByPostId = createGetPostsByPostId(p2),
		GetPostsByUserId = createGetPostsByUserId(p2),
		GetThumbnailByAssetId = createGetThumbnailByAssetId(p2),
		RemoveReaction = 0
	}
	local v7 = if fFlagContentFeedEnableReactions then createRemoveReaction(p2) else nil
	v5.RemoveReaction = v7
	return v5
end
