local getUnifiedDeferredEventStore = require(script.Parent.Store.getUnifiedDeferredEventStore)
local UnifiedEventLogEnums = require(script.Parent.UnifiedEventLogEnums)

local WIDGET_LOADED = UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_LOADED

local function flushDeferredWidgetLoaded()
	local unifiedDeferredEventStore = getUnifiedDeferredEventStore(false)
	unifiedDeferredEventStore.markEntered()

	local v = unifiedDeferredEventStore.takePending(WIDGET_LOADED)

	for _, v2 in v do
		v2()
	end
end

return flushDeferredWidgetLoaded
