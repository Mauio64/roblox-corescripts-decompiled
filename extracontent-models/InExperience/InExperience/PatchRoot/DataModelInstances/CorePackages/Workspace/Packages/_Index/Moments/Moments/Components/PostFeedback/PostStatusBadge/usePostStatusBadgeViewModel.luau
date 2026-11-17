local Moments = script:FindFirstAncestor("Moments")

require(script.Parent.PostStatusBadgeView)
local usePendingMomentRecord = require(Moments.Components.PostFeedback.usePendingMomentRecord)
local usePostFeedbackStrings = require(Moments.Components.PostFeedback.usePostFeedbackStrings)

local function usePostStatusBadgeViewModel(p)
	local v = usePendingMomentRecord(p.momentId)
	local status = v ~= nil and (v.status or "Posting") or nil
	local v2 = usePostFeedbackStrings()

	if status == "Moderated" then
		return { label = v2.moderatedBadge, ZIndex = p.ZIndex }
	elseif status == "Posting" then
		return { label = v2.postingBadge, ZIndex = p.ZIndex }
	end

	return nil
end

return usePostStatusBadgeViewModel
