local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local defineFastFlag = game:DefineFastFlag("IECFunnelContextIds", false)

local v5 = {
	ItemType = { Asset = "Asset", Outfit = "Outfit" },
	Section = {
		BuyCreationPage = "buy_creation_page",
		BuyItemModal = "buy_item_modal",
		ProcessCompleteModal = "process_complete_modal"
	},
	Action = {
		FieldTouched = "field_touched",
		ButtonClicked = "button_clicked",
		PageLoad = "page_load"
	},
	Element = {
		Name = "name",
		Description = "description",
		X = "x",
		Expand = "expand",
		Buy = "buy",
		Cancel = "cancel"
	}
}

local v6 = nil
local v7 = nil

local function sendEvent(p2, p3, p4)
	local v12 = {
		section = p2,
		action = p3,
		element = p4,
		itemType = v6,
		itemSubType = v7,
		universeid = 0,
		placeid = 0,
		sessionid = 0
	}

	local v13 = if defineFastFlag then tostring(game.GameId) else nil
	v12.universeid = v13
	local v14 = if defineFastFlag then tostring(game.PlaceId) else nil
	v12.placeid = v14
	local v15 = if defineFastFlag then RbxAnalyticsService:GetSessionId() else nil
	v12.sessionid = v15
	RbxAnalyticsService:SendEventDeferred(
		"client",
		"publish_avatar_prompt",
		"iec_funnel_user_creation",
		v12
	)
end

function v5.setItemDetails(p2, p3)
	v6 = p2
	v7 = p3
end

function v5.sendPageLoad(p2)
	sendEvent(p2, v5.Action.PageLoad)
end

function v5.sendFieldTouched(p2, p3)
	sendEvent(p2, v5.Action.FieldTouched, p3)
end

function v5.sendButtonClicked(p2, p3)
	sendEvent(p2, v5.Action.ButtonClicked, p3)
end

return v5
