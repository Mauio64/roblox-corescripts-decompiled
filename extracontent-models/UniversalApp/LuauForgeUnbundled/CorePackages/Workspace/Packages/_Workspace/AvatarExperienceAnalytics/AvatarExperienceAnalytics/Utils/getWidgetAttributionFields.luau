require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceCommon")

local function getWidgetAttributionFields(data)
	if data == nil or data.widgetType == nil then
		return nil
	end

	local v5 = {
		widgetId = data.widgetId,
		widgetType = data.widgetType,
		widgetItemIds = 0,
		requestId = 0,
		uiTreatmentType = 0
	}
	local v6 = if data.widgetItemIds then table.concat(data.widgetItemIds, ",") else nil
	v5.widgetItemIds = v6
	v5.requestId = data.requestId
	v5.uiTreatmentType = data.uiTreatmentType
	return v5
end

return getWidgetAttributionFields
