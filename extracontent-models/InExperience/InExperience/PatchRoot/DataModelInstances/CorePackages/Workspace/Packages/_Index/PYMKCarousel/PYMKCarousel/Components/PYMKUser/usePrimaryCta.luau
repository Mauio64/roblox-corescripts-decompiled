local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local parent2 = parent.Parent

local react = dependencies.React
local usePYMKCarouselUserButtons = require(parent.Components.PYMKUser.usePYMKCarouselUserButtons)
require(parent.Common.DirectRecommendationTypes)

local SharedFlags = require(parent2.SharedFlags)
local FFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local SharedFlags2 = require(parent2.SharedFlags)
local FFlagPymkCarouselExtendProps = SharedFlags2.FFlagPymkCarouselExtendProps

local UserList = require(parent2.UserList)

local EntityType = UserList.Enums.EntityType

local function usePrimaryCta(data)
	local v = {
		userId = data.entityId,
		showToast = data.showToast,
		fireAnalyticsEvent = data.fireAnalyticsEvent,
		absolutePosition = data.absolutePosition,
		contactId = 0,
		recommendation = 0
	}
	local contactId

	if data.entityType == EntityType.Contact then
		contactId = data.entityId
	end

	v.contactId = contactId
	local recommendation

	if FFlagPymkCarouselExtendProps or FFlagLuaAppEnableSduiHomePage then
		recommendation = data.recommendation
	end

	v.recommendation = recommendation
	local v2 = usePYMKCarouselUserButtons(v)

	return react.useMemo(function()
		local v3 = v2()[1]

		if v3 then
			return {
				type = v3.buttonType,
				onActivated = v3.onActivated,
				isDisabled = v3.isDisabled,
				isLoading = v3.isLoading,
				icon = nil,
				focusEventName = v3.focusEvent,
				disabledReason = nil
			}
		end

		return nil
	end, { v2 })
end

return usePrimaryCta
