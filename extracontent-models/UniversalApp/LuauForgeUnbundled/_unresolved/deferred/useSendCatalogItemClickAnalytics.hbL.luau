local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local addAnalyticsMetadata = require("@luauforge/bundled/dKU").Actions.AddAnalyticsMetadata

local module = require("@luauforge/bundled/fDf")
local module2 = require("@luauforge/deferred/gPw")
require("@luauforge/bundled/dPs")

local function useSendCatalogItemClickAnalytics(data)
	local v5 = useDispatch()
	local v6 = useRoactService(module)

	local analyticsContext = data.analyticsContext
	local itemId = data.itemId
	local itemType = data.itemType
	local index = data.index
	local analyticsItemCountPerPage = data.analyticsItemCountPerPage

	return React.useCallback(function()
		if itemId and itemType then
			v5(addAnalyticsMetadata({ selectedItemIndex = index }))

			v5(module2(
				analyticsContext,
				v6.clickCatalogItem,
				itemId,
				itemType,
				index,
				analyticsItemCountPerPage,
				false
			))
		end
	end, {
		v5,
		v6,
		analyticsContext,
		itemId,
		itemType,
		index,
		analyticsItemCountPerPage
	})
end

return useSendCatalogItemClickAnalytics
