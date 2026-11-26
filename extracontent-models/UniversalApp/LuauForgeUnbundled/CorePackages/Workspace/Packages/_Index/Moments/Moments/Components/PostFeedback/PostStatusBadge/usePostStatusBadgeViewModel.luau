require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/PostStatusBadge/PostStatusBadgeView")
local usePendingMomentRecord = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/usePendingMomentRecord")
local usePostFeedbackStrings = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/usePostFeedbackStrings")

local function usePostStatusBadgeViewModel(p2)
	local v5 = usePendingMomentRecord(p2.momentId)
	local status = v5 ~= nil and (v5.status or "Posting") or nil
	local v6 = usePostFeedbackStrings()

	if status == "Moderated" then
		return { label = v6.moderatedBadge, ZIndex = p2.ZIndex }
	elseif status == "Posting" then
		return { label = v6.postingBadge, ZIndex = p2.ZIndex }
	end

	return nil
end

return usePostStatusBadgeViewModel
