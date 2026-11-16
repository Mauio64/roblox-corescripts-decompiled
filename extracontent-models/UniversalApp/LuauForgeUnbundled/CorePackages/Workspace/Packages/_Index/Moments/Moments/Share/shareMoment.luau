local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default

local analytics = MomentsCommon.Analytics
local eventNames = analytics.EventNames
local makeFeedActionFields = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makeFeedActionFields")
local fetchShareLink = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Share/fetchShareLink")
local GetShareCountsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetShareCountsStore")
local GetToastStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetToastStore")
local readAppPolicy = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Share/readAppPolicy")

local function shareMoment(data)
	local momentId = data.momentId
	local strings = data.strings

	task.spawn(function()
		local function notifyFailure()
			GetToastStore(false).triggerToast({ title = strings.linkCopyFailed, text = "" })
		end

		if data.feedItemId == nil or data.feedItemId == "" then
			GetToastStore(false).triggerToast({ title = strings.linkCopyFailed, text = "" })

			return
		end

		local success, result = pcall(fetchShareLink, {
			momentId = momentId,
			feedItemId = data.feedItemId,
			description = data.description,
			title = strings.linkPreviewTitle
		})

		if not (success and result) then
			GetToastStore(false).triggerToast({ title = strings.linkCopyFailed, text = "" })

			return
		end

		if not pcall(function()
			local v5 = readAppPolicy()

			if v5 and v5.EnableShareCaptureCTA and v5.EligibleForCapturesFeature then
				default:shareUrl({ url = result, context = "MomentsFeed" })
			else
				default:setClipboardText({ text = result, context = "MomentsFeed" })
			end
		end) then
			GetToastStore(false).triggerToast({ title = strings.linkCopyFailed, text = "" })

			return
		end

		GetShareCountsStore(false).markShared(momentId)

		if data.logAction then
			data.logAction({})
		end

		local v5 = makeFeedActionFields(momentId, data.feedItemId, data.feedSessionId, "share")

		if v5 then
			analytics.fireAnalyticsEvent(eventNames.FeedShareButtonPressed, v5)
		end

		GetToastStore(false).triggerToast({ title = strings.linkCopied, text = "" })
	end)
end

return shareMoment
