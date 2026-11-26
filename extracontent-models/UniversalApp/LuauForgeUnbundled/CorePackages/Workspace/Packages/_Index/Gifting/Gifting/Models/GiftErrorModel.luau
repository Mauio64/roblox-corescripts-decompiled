local t = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/t")

local AmpRecourseAction = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Enums/AmpRecourseAction")
local FailureReason = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Enums/FailureReason")
local GiftModelUtils = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/GiftModelUtils")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")

local function formatInvalidItems(invalidItems)
	if not t.table(invalidItems) then
		return nil
	end

	local result = {}

	for k, item in invalidItems do
		local v5 = if t.table(item) then GiftModelUtils.formatItem(item.item) else nil

		if v5 ~= nil then
			table.insert(result, { item = v5, reason = item.reason })
		end
	end

	return result
end

return {
	format = function(data, p2, p3)
		return {
			failureReason = FailureReason.fromValue(data.failureReason),
			ampFeatureCheck = data.ampFeatureCheck,
			ampRecourseActions = AmpRecourseAction.fromValues(data.ampRecourseActions),
			invalidItems = formatInvalidItems(data.invalidItems),
			purchaseGiftRequest = data.purchaseGiftRequest,
			acceptGiftRequest = data.acceptGiftRequest,
			status = p2,
			errorMessage = p3
		}
	end,
	invalidRequest = function(p2)
		return { failureReason = FailureReason.InvalidInput, errorMessage = p2 }
	end
}
