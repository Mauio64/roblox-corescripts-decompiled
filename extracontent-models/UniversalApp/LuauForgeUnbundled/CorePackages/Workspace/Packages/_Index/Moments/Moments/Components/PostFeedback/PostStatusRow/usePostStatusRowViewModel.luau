require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/PostStatusRow/PostStatusRowView")
local usePendingMomentRecord = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/usePendingMomentRecord")
local usePostingProgress = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/usePostingProgress")
local usePostFeedbackStrings = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/usePostFeedbackStrings")

local function usePostStatusRowViewModel(p2)
	local v5 = usePendingMomentRecord(p2.momentId)
	local status = v5 ~= nil and (v5.status or "Posting") or nil
	local v6 = usePostFeedbackStrings()
	local v8 = if v5 ~= nil then v5.startedAtClock else nil
	local v9 = usePostingProgress(v8)

	if status == "Moderated" then
		return {
			variant = "moderated",
			title = v6.moderatedTitle,
			body = v6.moderatedBody,
			LayoutOrder = p2.LayoutOrder
		}
	elseif status == "Posting" then
		return {
			variant = "posting",
			title = v6.postingTitle,
			body = v6.postingBody,
			progress = v9,
			LayoutOrder = p2.LayoutOrder
		}
	end

	return nil
end

return usePostStatusRowViewModel
