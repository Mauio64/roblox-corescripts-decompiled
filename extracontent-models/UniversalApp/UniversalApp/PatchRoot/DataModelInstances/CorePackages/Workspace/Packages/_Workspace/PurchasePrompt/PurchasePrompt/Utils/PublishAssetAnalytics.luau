local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local t1 = {
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

local function sendEvent(s1: string, s2: string, s3: string?) -- line: 26
	-- upvalues: RbxAnalyticsService (copy)
	RbxAnalyticsService:SendEventDeferred("client", "publish_avatar_prompt", "iec_funnel_user_creation", {
		section = s1,
		action = s2,
		element = s3
	})
end

function t1.sendPageLoad(p1) -- line: 34
	-- upvalues: t1 (copy), RbxAnalyticsService (copy)
	local PageLoad = t1.Action.PageLoad

	RbxAnalyticsService:SendEventDeferred("client", "publish_avatar_prompt", "iec_funnel_user_creation", {
		element = nil,
		section = p1,
		action = PageLoad
	})
end
function t1.sendFieldTouched(p2, p3) -- line: 38
	-- upvalues: t1 (copy), RbxAnalyticsService (copy)
	local FieldTouched = t1.Action.FieldTouched

	RbxAnalyticsService:SendEventDeferred("client", "publish_avatar_prompt", "iec_funnel_user_creation", {
		section = p2,
		action = FieldTouched,
		element = p3
	})
end
function t1.sendButtonClicked(p4, p5) -- line: 42
	-- upvalues: t1 (copy), RbxAnalyticsService (copy)
	local ButtonClicked = t1.Action.ButtonClicked

	RbxAnalyticsService:SendEventDeferred("client", "publish_avatar_prompt", "iec_funnel_user_creation", {
		section = p4,
		action = ButtonClicked,
		element = p5
	})
end

return t1
