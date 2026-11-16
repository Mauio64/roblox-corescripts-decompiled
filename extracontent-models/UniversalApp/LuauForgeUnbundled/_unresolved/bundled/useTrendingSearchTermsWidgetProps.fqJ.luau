local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")
require("@luauforge/bundled/fpW")
local module2 = require("@luauforge/bundled/fqK")
local module3 = require("@luauforge/bundled/fqt")
local module4 = require("@luauforge/bundled/fpS")

local sendUnifiedEventLog = module2.sendUnifiedEventLog
local unifiedEventLogEnums = module2.UnifiedEventLogEnums
local unifiedLoggingSurface = module3.Enums.UnifiedLoggingSurface
local fFlagAXSearchTrendingChipLogging = module4.FFlagAXSearchTrendingChipLogging

local module5 = require("@luauforge/bundled/fqL")

local function useTrendingSearchTermsWidgetProps(p2)
	local v5 = module5()

	if fFlagAXSearchTrendingChipLogging then
		React.useEffect(function()
			for k, v6 in v5 do
				sendUnifiedEventLog({
					action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_IMPRESSION,
					surface = unifiedLoggingSurface.SEARCH_LANDING_PAGE,
					elementName = "TRENDING_SEARCH_CHIP",
					elementMetadata = HttpService:JSONEncode({
						keyword = v6,
						rank = tostring(k)
					})
				})
			end
		end, { v5 })
	end

	local v6

	if fFlagAXSearchTrendingChipLogging then
		local v7 = React.useCallback(function(p3, p4)
			sendUnifiedEventLog({
				action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
				surface = unifiedLoggingSurface.SEARCH_LANDING_PAGE,
				elementName = "TRENDING_SEARCH_CHIP",
				elementMetadata = HttpService:JSONEncode({
					keyword = p3,
					rank = tostring(p4)
				})
			})

			p2.onSubmitSearch(p3)
		end, { p2.onSubmitSearch })

		v6 = React.useMemo(function()
			local result = {}

			for k, v8 in v5 do
				result[k] = {
					text = v8,
					onActivated = function()
						v7(v8, k)
					end
				}
			end

			return result
		end, { v5, v7 })
	else
		v6 = React.useMemo(function()
			local result = {}

			for k, v7 in v5 do
				result[k] = {
					text = v7,
					onActivated = function()
						p2.onSubmitSearch(v7)
					end
				}
			end

			return result
		end, { v5, p2.onSubmitSearch })
	end

	return { chips = v6 }
end

return useTrendingSearchTermsWidgetProps
