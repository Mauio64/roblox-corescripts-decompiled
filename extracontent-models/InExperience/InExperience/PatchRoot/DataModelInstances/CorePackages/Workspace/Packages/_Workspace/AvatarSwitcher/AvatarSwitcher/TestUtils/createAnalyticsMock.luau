local Parent = script:FindFirstAncestor("AvatarSwitcher").Parent
local jest = require(Parent.Dev.JestGlobals).jest

local function createAnalyticsMock() -- line: 7
	-- upvalues: jest (copy)
	local v4 = jest.fn()

	return {
		addUnifiedEventLogging = v4,
		sendAXCounterV2 = jest.fn(),
		useUnifiedEventListener = {
			useUnifiedEventListenerInExperience = jest.fn()
		},
		UnifiedEventLogEnums = {
			MarketplaceUnifiedAction = {
				UI_ELEMENT_CLICK = "UI_ELEMENT_CLICK"
			}
		}
	}, v4
end

return createAnalyticsMock
