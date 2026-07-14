local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local MomentsCommon = require(MomentsParent.MomentsCommon)
local default = require(MomentsParent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local makeFeedActionFields = require(Moments.Analytics.makeFeedActionFields)
local fetchShareLink = require(script.Parent.fetchShareLink)
local GetShareCountsStore = require(Moments.Stores.GetShareCountsStore)
local GetToastStore = require(Moments.Stores.GetToastStore)

local function shareMoment(t1: {[any]: any}) -- line: 38
	-- upvalues: GetToastStore (copy), fetchShareLink (copy), default (copy), GetShareCountsStore (copy), makeFeedActionFields (copy), MomentsCommon (copy), Analytics (copy), EventNames (copy)
	local momentId = t1.momentId
	local strings = t1.strings

	task.spawn(function() -- line: 42
		-- upvalues: GetToastStore (copy), strings (copy), fetchShareLink (copy), momentId (copy), t1 (copy), default (copy), GetShareCountsStore (copy), makeFeedActionFields (copy), MomentsCommon (copy), Analytics (copy), EventNames (copy)
		local function notifyFailure() -- line: 43
			-- upvalues: GetToastStore (copy), strings (copy)
			GetToastStore(false).triggerToast({
				text = "",
				title = strings.linkCopyFailed
			})
		end

		local ok, result = pcall(fetchShareLink, {
			momentId = momentId,
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

		if not pcall(function() -- line: 57
			-- upvalues: default (copy), result (copy)
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

		local v18 = makeFeedActionFields(momentId, t1.feedItemId, t1.feedSessionId, if not MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity() then nil else "share")

		if v18 then
			Analytics.fireAnalyticsEvent(EventNames.FeedShareButtonPressed, v18)
		end

		GetToastStore(false).triggerToast({
			text = "",
			title = strings.linkCopied
		})
	end)
end

return shareMoment
