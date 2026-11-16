local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local defineFastFlag = game:DefineFastFlag("IECFunnelContextIds", false)

local PublishAssetAnalytics = {
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

local itemType = nil
local itemSubType = nil

local function sendEvent(section: string, action: string, element: string?)
	local v = {
		section = section,
		action = action,
		element = element,
		itemType = itemType,
		itemSubType = itemSubType,
		universeid = 0,
		placeid = 0,
		sessionid = 0
	}
	local universeid

	if defineFastFlag then
		universeid = tostring(game.GameId)
	end

	v.universeid = universeid
	local placeid

	if defineFastFlag then
		placeid = tostring(game.PlaceId)
	end

	v.placeid = placeid
	local sessionid

	if defineFastFlag then
		sessionid = RbxAnalyticsService:GetSessionId()
	end

	v.sessionid = sessionid
	RbxAnalyticsService:SendEventDeferred("client", "publish_avatar_prompt", "iec_funnel_user_creation", v)
end

function PublishAssetAnalytics.setItemDetails(p: string?, p2: string?)
	itemType = p
	itemSubType = p2
end

function PublishAssetAnalytics.sendPageLoad(p)
	sendEvent(p, PublishAssetAnalytics.Action.PageLoad)
end

function PublishAssetAnalytics.sendFieldTouched(section, element)
	sendEvent(section, PublishAssetAnalytics.Action.FieldTouched, element)
end

function PublishAssetAnalytics.sendButtonClicked(section, element)
	sendEvent(section, PublishAssetAnalytics.Action.ButtonClicked, element)
end

return PublishAssetAnalytics
