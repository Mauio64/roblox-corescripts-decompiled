local Gifting = script:FindFirstAncestor("Gifting")
local parent = Gifting.Parent

local t = require(parent.t)

local AmpRecourseAction = require(Gifting.Enums.AmpRecourseAction)
local FailureReason = require(Gifting.Enums.FailureReason)
local GiftModelUtils = require(Gifting.Models.GiftModelUtils)
require(Gifting.Types)

local function formatInvalidItems(invalidItems)
	if not t.table(invalidItems) then
		return nil
	end

	local result = {}

	for _, item in invalidItems do
		local v

		if t.table(item) then
			v = GiftModelUtils.formatItem(item.item)
		end

		if v ~= nil then
			table.insert(result, { item = v, reason = item.reason })
		end
	end

	return result
end

local GiftErrorModel = {}

function GiftErrorModel.format(data, status: number?, errorMessage: string?)
	return {
		failureReason = FailureReason.fromValue(data.failureReason),
		ampFeatureCheck = data.ampFeatureCheck,
		ampRecourseActions = AmpRecourseAction.fromValues(data.ampRecourseActions),
		invalidItems = formatInvalidItems(data.invalidItems),
		purchaseGiftRequest = data.purchaseGiftRequest,
		acceptGiftRequest = data.acceptGiftRequest,
		status = status,
		errorMessage = errorMessage
	}
end

function GiftErrorModel.invalidRequest(errorMessage: string?)
	return { failureReason = FailureReason.InvalidInput, errorMessage = errorMessage }
end

return GiftErrorModel
