local UnifiedEventLogEnums = require(script.Parent.UnifiedEventLogEnums)
local sendUnifiedEventLog = require(script.Parent.sendUnifiedEventLog)

local function logWidgetLoaded(p1, p2) -- line: 4
	-- upvalues: sendUnifiedEventLog (copy), UnifiedEventLogEnums (copy)
	for v6, v7 in p1 do
		local t1 = {}
		local t2 = {}
		local t3 = {}

		if v7.content then
			for _, v12 in v7.content do
				if v12.type == "Asset" then
					table.insert(t1, v12.id)
				elseif v12.type == "Bundle" then
					table.insert(t2, v12.id)
				end

				table.insert(t3, v12.id)
			end
		end

		sendUnifiedEventLog({
			gridPositionColumn = 1,
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_LOADED,
			requestId = p2,
			widgetId = v7.id,
			widgetType = v7.type,
			themeId = v7.tagId,
			gridPositionRow = v6,
			assetIds = table.concat(t1, ","),
			bundleIds = table.concat(t2, ","),
			widgetItemIds = table.concat(t3, ",")
		})
	end
end

return logWidgetLoaded
