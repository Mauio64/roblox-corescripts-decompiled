local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local MomentsCommon = require(MomentsParent.MomentsCommon)
local default = require(MomentsParent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local FFlagMomentsCopyShareLinkWhenShareSheetUnavailable = require(Moments.Flags.FFlagMomentsCopyShareLinkWhenShareSheetUnavailable)
local makeFeedActionFields = require(Moments.Analytics.makeFeedActionFields)
local fetchShareLink = require(script.Parent.fetchShareLink)
local GetShareCountsStore = require(Moments.Stores.GetShareCountsStore)
local GetToastStore = require(Moments.Stores.GetToastStore)
local readAppPolicy = require(script.Parent.readAppPolicy)

local function shareMoment(t1: {[any]: any}) -- line: 41
	-- upvalues: GetToastStore (copy), fetchShareLink (copy), FFlagMomentsCopyShareLinkWhenShareSheetUnavailable (copy), readAppPolicy (copy), default (copy), GetShareCountsStore (copy), makeFeedActionFields (copy), MomentsCommon (copy), Analytics (copy), EventNames (copy)
	local momentId = t1.momentId
	local strings = t1.strings

	task.spawn(function() -- line: 45
		-- upvalues: GetToastStore (copy), strings (copy), fetchShareLink (copy), momentId (copy), t1 (copy), FFlagMomentsCopyShareLinkWhenShareSheetUnavailable (copy), readAppPolicy (copy), default (copy), GetShareCountsStore (copy), makeFeedActionFields (copy), MomentsCommon (copy), Analytics (copy), EventNames (copy)
		local function notifyFailure() -- line: 46
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

		if not pcall(function() -- line: 60
			-- upvalues: FFlagMomentsCopyShareLinkWhenShareSheetUnavailable (copy), readAppPolicy (copy), default (copy), result (copy)
			if FFlagMomentsCopyShareLinkWhenShareSheetUnavailable then
				local v21 = readAppPolicy()

				if not v21 or (not v21.EnableShareCaptureCTA or not v21.EligibleForCapturesFeature and not false) then
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

		local v20 = makeFeedActionFields(momentId, t1.feedItemId, t1.feedSessionId, if not MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity() then nil else "share")

		if v20 then
			Analytics.fireAnalyticsEvent(EventNames.FeedShareButtonPressed, v20)
		end

		GetToastStore(false).triggerToast({
			text = "",
			title = strings.linkCopied
		})
	end)
end

return shareMoment
