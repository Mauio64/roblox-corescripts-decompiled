local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dwM")
require(CorePackages.Packages.Dash)

local module2 = require("@luauforge/bundled/dTM")
local module3 = require("@luauforge/bundled/fuD")
local module4 = require("@luauforge/bundled/dRQ")
local module5 = require("@luauforge/deferred/fuz")
require("@luauforge/deferred/ggE")
require("@luauforge/bundled/dMc")

local selectSearchKeyword = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.selectSearchKeyword

local module6 = require("@luauforge/deferred/gfO")

return function(data)
	module.assert(not (data.mountAsFullView and data.showFullWithNoPeekView))
	return function(object)
		if data.closePreviousItemDetails then
			module2.closeFiltersAndItemDetails(data.navigation)
		end

		local v5 = {
			itemId = data.itemId,
			itemType = data.itemType,
			itemSubType = data.itemSubType,
			itemDetailsPeekViewRefs = data.itemDetailsPeekViewRefs,
			resultsListRef = data.resultsListRef,
			isFirstItemDetails = true,
			mountAsFullView = data.mountAsFullView,
			showFullWithNoPeekView = data.showFullWithNoPeekView,
			widgetInfo = data.widgetInfo,
			onItemDetailsClosed = data.onItemDetailsClosed
		}

		if data.showFullWithNoPeekView or data.mountAsFullView then
			local currentScreenIgnoreItemDetails = module3.getCurrentScreenIgnoreItemDetails(data.avatarRoute)

			if module6() then
				local state = object:getState()
				local v6 = selectSearchKeyword(state)
				local categoryAndSubcategory, v7 = module4.getCategoryAndSubcategory(state)
				local requestId = state.AvatarExperience.Common.Widgets.WidgetInfo.RequestId
				data.catalogAnalytics.openItemDetailsV2(
					data.itemId,
					data.itemType,
					data.priceInRobux,
					currentScreenIgnoreItemDetails,
					requestId,
					v6,
					categoryAndSubcategory,
					v7,
					state.AvatarExperience.AnalyticsMetadata
				)
			else
				data.catalogAnalytics.openItemDetails(
					data.itemId,
					data.itemType,
					data.priceInRobux,
					currentScreenIgnoreItemDetails
				)
			end
		end

		object:dispatch(module5(data.navigation, v5))
	end
end
