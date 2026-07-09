local ParentParent = script.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local ParentParentParent = ParentParent.Parent
local React = dependencies.React
local usePYMKCarouselUserButtons = require(ParentParent.Components.PYMKCarouselUserTile.usePYMKCarouselUserButtons)
local EntityType = require(ParentParentParent.UserList).Enums.EntityType

local function usePrimaryCta(t1: {[any]: any}) -- line: 20
	-- upvalues: usePYMKCarouselUserButtons (copy), EntityType (copy), React (copy)
	local v9 = usePYMKCarouselUserButtons({
		userId = t1.entityId,
		showToast = t1.showToast,
		fireAnalyticsEvent = t1.fireAnalyticsEvent,
		absolutePosition = t1.absolutePosition,
		contactId = if t1.entityType ~= EntityType.Contact then nil else t1.entityId
	})

	return React.useMemo(function() -- line: 29
		-- upvalues: v9 (copy)
		local v10 = v9()[1]

		if not v10 then
			return nil
		end

		return {
			icon = nil,
			disabledReason = nil,
			type = v10.buttonType,
			onActivated = v10.onActivated,
			isDisabled = v10.isDisabled,
			isLoading = v10.isLoading,
			focusEventName = v10.focusEvent
		}
	end, { v9 })
end

return usePrimaryCta
