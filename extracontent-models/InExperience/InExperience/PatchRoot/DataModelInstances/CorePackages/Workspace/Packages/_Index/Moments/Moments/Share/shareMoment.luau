local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local MomentsCommon = require(MomentsParent.MomentsCommon)
local SharedFlags = require(MomentsParent.SharedFlags)
local default = require(MomentsParent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local FFlagMomentsCopyShareLinkWhenShareSheetUnavailable = require(Moments.Flags.FFlagMomentsCopyShareLinkWhenShareSheetUnavailable)
local FFlagMomentsPassFeedItemIdToBackendApis = SharedFlags.FFlagMomentsPassFeedItemIdToBackendApis
local makeFeedActionFields = require(Moments.Analytics.makeFeedActionFields)
local fetchShareLink = require(script.Parent.fetchShareLink)
local GetShareCountsStore = require(Moments.Stores.GetShareCountsStore)
local GetToastStore = require(Moments.Stores.GetToastStore)
local readAppPolicy = require(script.Parent.readAppPolicy)

local function shareMoment(t1: {[any]: any}) -- line: 43
	-- upvalues: GetToastStore (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), fetchShareLink (copy), FFlagMomentsCopyShareLinkWhenShareSheetUnavailable (copy), readAppPolicy (copy), default (copy), GetShareCountsStore (copy), makeFeedActionFields (copy), MomentsCommon (copy), Analytics (copy), EventNames (copy)
	local momentId = t1.momentId
	local strings = t1.strings

	task.spawn(function() -- line: 47
		-- upvalues: GetToastStore (copy), strings (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), t1 (copy), fetchShareLink (copy), momentId (copy), FFlagMomentsCopyShareLinkWhenShareSheetUnavailable (copy), readAppPolicy (copy), default (copy), GetShareCountsStore (copy), makeFeedActionFields (copy), MomentsCommon (copy), Analytics (copy), EventNames (copy)
		local function notifyFailure() -- line: 48
			-- upvalues: GetToastStore (copy), strings (copy)
			GetToastStore(false).triggerToast({
				text = "",
				title = strings.linkCopyFailed
			})
		end

		if FFlagMomentsPassFeedItemIdToBackendApis and (t1.feedItemId == nil or t1.feedItemId == "") then
			GetToastStore(false).triggerToast({
				text = "",
				title = strings.linkCopyFailed
			})

			return
		end

		local ok, result = pcall(fetchShareLink, {
			momentId = momentId,
			feedItemId = if not FFlagMomentsPassFeedItemIdToBackendApis then nil else t1.feedItemId,
			description = t1.description,
			title = strings.linkPreviewTitle
		})

		if not ok or not result then
			GetToastStore(false).triggerToast({
				text = "",
				title = strings.linkCopyFailed
			})

			return
		end

		if not pcall(function() -- line: 68
			-- upvalues: FFlagMomentsCopyShareLinkWhenShareSheetUnavailable (copy), readAppPolicy (copy), default (copy), result (copy)
			if FFlagMomentsCopyShareLinkWhenShareSheetUnavailable then
				local v23 = readAppPolicy()

				if not v23 or (not v23.EnableShareCaptureCTA or not v23.EligibleForCapturesFeature and not false) then
					default:setClipboardText({
						context = "MomentsFeed",
						text = result
					})

					return
				end
			end

			default:shareUrl({
				context = "MomentsFeed",
				url = result
			})
		end) then
			GetToastStore(false).triggerToast({
				text = "",
				title = strings.linkCopyFailed
			})

			return
		end

		GetShareCountsStore(false).markShared(momentId)

		if t1.logAction then
			t1.logAction({})
		end

		local v22 = makeFeedActionFields(momentId, t1.feedItemId, t1.feedSessionId, if not MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity() then nil else "share")

		if v22 then
			Analytics.fireAnalyticsEvent(EventNames.FeedShareButtonPressed, v22)
		end

		GetToastStore(false).triggerToast({
			text = "",
			title = strings.linkCopied
		})
	end)
end

return shareMoment
