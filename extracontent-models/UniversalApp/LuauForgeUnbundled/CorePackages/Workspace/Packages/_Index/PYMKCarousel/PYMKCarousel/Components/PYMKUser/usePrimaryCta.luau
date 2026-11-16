local react = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies").React
local usePYMKCarouselUserButtons = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Components/PYMKUser/usePYMKCarouselUserButtons")
require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/DirectRecommendationTypes")

local fFlagLuaAppEnableSduiHomePage = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags").FFlagLuaAppEnableSduiHomePage

local entityType = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/UserList").Enums.EntityType

local function usePrimaryCta(data)
	local v6 = {
		userId = data.entityId,
		showToast = data.showToast,
		fireAnalyticsEvent = data.fireAnalyticsEvent,
		absolutePosition = data.absolutePosition,
		contactId = 0,
		recommendation = 0
	}
	local v7 = if data.entityType == entityType.Contact then data.entityId else nil
	v6.contactId = v7
	local v8 = if fFlagLuaAppEnableSduiHomePage then data.recommendation else nil
	v6.recommendation = v8
	local v9 = usePYMKCarouselUserButtons(v6)

	return react.useMemo(function()
		local v10 = v9()[1]

		if v10 then
			return {
				type = v10.buttonType,
				onActivated = v10.onActivated,
				isDisabled = v10.isDisabled,
				isLoading = v10.isLoading,
				icon = nil,
				focusEventName = v10.focusEvent,
				disabledReason = nil
			}
		end

		return nil
	end, { v9 })
end

return usePrimaryCta
