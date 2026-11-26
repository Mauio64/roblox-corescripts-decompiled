local module = require("@luauforge/bundled/hHX")
local module2 = require("@luauforge/bundled/hHP")
local module3 = require("@luauforge/bundled/hIe")
require("@luauforge/bundled/hIi")

local module4 = require("@luauforge/bundled/hHJ")

local viewName = module3.ViewName
local eventType = module3.EventType
local viewMessage = module3.ViewMessage

local v5 = {}

local function isNonEmptyString(value): boolean
	return typeof(value) == "string" and value ~= ""
end

local function findSubscriptionSection(p2)
	local section_map = p2.section_map or v5

	for k, v6 in p2.section_order or v5 do
		local v7 = section_map[v6]

		if v7 and v7.roblox_component == module3.SubscriptionSectionComponent then
			return v7
		end
	end

	return nil
end

local function countSubscriptionTiles(p2)
	return #(((((((p2.input_data or v5).kind or v5).value or v5).section or v5).value or v5).products or v5).always_visible_products or v5)
end

local function hasFreeTrial(data): boolean
	local subscription_product_ids = (data.analytics or v5).subscription_product_ids
	local v6 = typeof(subscription_product_ids) == "string" and subscription_product_ids ~= ""

	if not v6 then
		return false
	end

	for k, v7 in string.split(subscription_product_ids, ",") do
		local subscriptionProduct = module.getSubscriptionProduct(v7)

		if subscriptionProduct and subscriptionProduct.isFreeTrial == true then
			return true
		end
	end

	return false
end

local function trackBuyRobuxPageShown(data, data2)
	local v6

	if module4 then
		local transfers = data2.transfers

		if transfers then
			local send_button_text = transfers.send_button_text
			local v7 = typeof(send_button_text) == "string" and send_button_text ~= ""

			if v7 or #(transfers.pending_transfer_ids or v5) > 0 then
				data.addSeenSection(module3.SectionType.Transfers)
			end
		end

		v6 = data.getImpressionMetadata()
	end

	data.trackFlow(viewName.ProductPurchase, eventType.ViewShown, nil, v6)
	local section_map = data2.section_map or v5
	local flag = true
	local v7

	for k, v8 in data2.section_order or v5 do
		v7 = section_map[v8]

		if v7 and v7.roblox_component == module3.SubscriptionSectionComponent then
			flag = false
			break
		end
	end

	if flag then
		v7 = nil
	end

	if v7 then
		local freeTrial = hasFreeTrial(data2)
		local count = #(((((((v7.input_data or v5).kind or v5).value or v5).section or v5).value or v5).products or v5).always_visible_products or v5)

		module2.trackCounter("SubscriptionV2SectionShown", {
			variant = count > 1 and "carousel" or "single",
			tierCount = tostring(count),
			isFreeTrial = tostring(freeTrial)
		})

		data.trackFlow(viewName.RobloxPlusBuyRobux, eventType.ViewShown, nil, {
			isFreeTrial = freeTrial
		})
	end

	local transfers = data2.transfers

	if transfers == nil then
		return
	end

	local send_button_text = transfers.send_button_text
	local v8 = typeof(send_button_text) == "string" and send_button_text ~= ""

	local v9 = #(transfers.pending_transfer_ids or v5) > 0

	if v8 then
		data.trackFlow(viewName.RobuxSendTransfers, eventType.ViewShown, viewMessage.TransferSendButton)
		module2.trackCounter("TransferSendImpression")
	end

	if v9 then
		data.trackFlow(
			viewName.RobuxPendingTransfers,
			eventType.ViewShown,
			viewMessage.TransferPendingButton
		)
		module2.trackCounter("TransferPendingImpression")
	end

	if not module4 and (v8 or v9) then
		data.addSeenSection(module3.SectionType.Transfers)
	end
end

return trackBuyRobuxPageShown
