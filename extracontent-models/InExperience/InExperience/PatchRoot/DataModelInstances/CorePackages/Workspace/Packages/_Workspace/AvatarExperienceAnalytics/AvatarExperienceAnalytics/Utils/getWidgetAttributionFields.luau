local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

require(parent.AvatarExperienceCommon)

local function getWidgetAttributionFields(data)
	if data == nil or data.widgetType == nil then
		return nil
	end

	local v = {
		widgetId = data.widgetId,
		widgetType = data.widgetType,
		widgetItemIds = 0,
		requestId = 0,
		uiTreatmentType = 0
	}
	local widgetItemIds

	if data.widgetItemIds then
		widgetItemIds = table.concat(data.widgetItemIds, ",")
	end

	v.widgetItemIds = widgetItemIds
	v.requestId = data.requestId
	v.uiTreatmentType = data.uiTreatmentType
	return v
end

return getWidgetAttributionFields
