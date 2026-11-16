local parent = script:FindFirstAncestor("AvatarSwitcher").Parent

local JestGlobals = require(parent.Dev.JestGlobals)
local jest = JestGlobals.jest

local function createAnalyticsMock()
	local addUnifiedEventLogging = jest.fn()

	return {
		addUnifiedEventLogging = addUnifiedEventLogging,
		sendAXCounterV2 = jest.fn(),
		useUnifiedEventListener = { useUnifiedEventListenerInExperience = jest.fn() },
		UnifiedEventLogEnums = {
			MarketplaceUnifiedAction = { UI_ELEMENT_CLICK = "UI_ELEMENT_CLICK" }
		}
	}, addUnifiedEventLogging
end

return createAnalyticsMock
