local module = require("@luauforge/bundled/hwP")
local module2 = require("@luauforge/bundled/hwH")
local module3 = require("@luauforge/bundled/hwW")
require("@luauforge/bundled/hxa")

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

local function trackBuyRobuxPageShown(p2, data)
	p2.trackFlow(viewName.ProductPurchase, eventType.ViewShown)
	local section_map = data.section_map or v5
	local flag = true
	local v6

	for k, v7 in data.section_order or v5 do
		v6 = section_map[v7]

		if v6 and v6.roblox_component == module3.SubscriptionSectionComponent then
			flag = false
			break
		end
	end

	if flag then
		v6 = nil
	end

	if v6 then
		local freeTrial = hasFreeTrial(data)
		local count = #(((((((v6.input_data or v5).kind or v5).value or v5).section or v5).value or v5).products or v5).always_visible_products or v5)

		module2.trackCounter("SubscriptionV2SectionShown", {
			variant = count > 1 and "carousel" or "single",
			tierCount = tostring(count),
			isFreeTrial = tostring(freeTrial)
		})

		p2.trackFlow(viewName.RobloxPlusBuyRobux, eventType.ViewShown, nil, {
			isFreeTrial = freeTrial
		})
	end

	local transfers = data.transfers

	if transfers == nil then
		return
	end

	local send_button_text = transfers.send_button_text
	local v7 = typeof(send_button_text) == "string" and send_button_text ~= ""

	local v8 = #(transfers.pending_transfer_ids or v5) > 0

	if v7 then
		p2.trackFlow(viewName.RobuxSendTransfers, eventType.ViewShown, viewMessage.TransferSendButton)
		module2.trackCounter("TransferSendImpression")
	end

	if v8 then
		p2.trackFlow(viewName.RobuxPendingTransfers, eventType.ViewShown, viewMessage.TransferPendingButton)
		module2.trackCounter("TransferPendingImpression")
	end

	if v7 or v8 then
		p2.addSeenSection(module3.SectionType.Transfers)
	end
end

return trackBuyRobuxPageShown
