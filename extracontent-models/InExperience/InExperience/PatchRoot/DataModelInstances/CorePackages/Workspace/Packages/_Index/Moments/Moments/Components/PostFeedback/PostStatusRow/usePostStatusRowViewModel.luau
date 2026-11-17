local Moments = script:FindFirstAncestor("Moments")

require(script.Parent.PostStatusRowView)
local usePendingMomentRecord = require(Moments.Components.PostFeedback.usePendingMomentRecord)
local usePostingProgress = require(Moments.Components.PostFeedback.usePostingProgress)
local usePostFeedbackStrings = require(Moments.Components.PostFeedback.usePostFeedbackStrings)

local function usePostStatusRowViewModel(p)
	local v = usePendingMomentRecord(p.momentId)
	local status = v ~= nil and (v.status or "Posting") or nil
	local v2 = usePostFeedbackStrings()
	local v3

	if v ~= nil then
		v3 = v.startedAtClock
	end

	local progress = usePostingProgress(v3)

	if status == "Moderated" then
		return {
			variant = "moderated",
			title = v2.moderatedTitle,
			body = v2.moderatedBody,
			LayoutOrder = p.LayoutOrder
		}
	elseif status == "Posting" then
		return {
			variant = "posting",
			title = v2.postingTitle,
			body = v2.postingBody,
			progress = progress,
			LayoutOrder = p.LayoutOrder
		}
	end

	return nil
end

return usePostStatusRowViewModel
