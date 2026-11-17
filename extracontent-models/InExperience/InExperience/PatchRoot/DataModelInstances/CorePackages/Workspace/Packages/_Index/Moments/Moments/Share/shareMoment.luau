local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local MomentsCommon = require(parent.MomentsCommon)

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default

local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local makeFeedActionFields = require(Moments.Analytics.makeFeedActionFields)
local fetchShareLink = require(script.Parent.fetchShareLink)
local GetShareCountsStore = require(Moments.Stores.GetShareCountsStore)
local GetToastStore = require(Moments.Stores.GetToastStore)
local readAppPolicy = require(script.Parent.readAppPolicy)
local FFlagMomentsLinkCopiedOnlyWhenCopied = require(Moments.Flags.FFlagMomentsLinkCopiedOnlyWhenCopied)

local function shareMoment(data)
	local momentId = data.momentId
	local strings = data.strings

	task.spawn(function()
		local function notifyFailure() -- 3 equivalent calls inferred from this helper
			GetToastStore(false).triggerToast({ title = strings.linkCopyFailed, text = "" })
		end

		if data.feedItemId == nil or data.feedItemId == "" then
			notifyFailure() -- inferred equivalent call
			return
		end

		local success, result = pcall(fetchShareLink, {
			momentId = momentId,
			feedItemId = data.feedItemId,
			description = data.description,
			title = strings.linkPreviewTitle
		})

		if not (success and result) then
			notifyFailure() -- inferred equivalent call
			return
		end

		local v

		if FFlagMomentsLinkCopiedOnlyWhenCopied then
			v = false
		else
			v = nil
		end

		if not pcall(function()
			local v2 = readAppPolicy()

			if v2 and v2.EnableShareCaptureCTA and v2.EligibleForCapturesFeature then
				default:shareUrl({ url = result, context = "MomentsFeed" })

				return
			end

			default:setClipboardText({ text = result, context = "MomentsFeed" })

			if FFlagMomentsLinkCopiedOnlyWhenCopied then
				v = true
			end
		end) then
			notifyFailure() -- inferred equivalent call
			return
		end

		GetShareCountsStore(false).markShared(momentId)

		if data.logAction then
			data.logAction({})
		end

		local feedActionFields = makeFeedActionFields(momentId, data.feedItemId, data.feedSessionId, "share")

		if feedActionFields then
			Analytics.fireAnalyticsEvent(EventNames.FeedShareButtonPressed, feedActionFields)
		end

		if not FFlagMomentsLinkCopiedOnlyWhenCopied or v then
			GetToastStore(false).triggerToast({ title = strings.linkCopied, text = "" })
		end
	end)
end

return shareMoment
