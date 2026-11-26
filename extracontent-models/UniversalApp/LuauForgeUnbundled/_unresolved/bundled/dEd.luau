local CorePackages = game:GetService("CorePackages")
local module = require("@luauforge/bundled/dzP")
local module2 = require("@luauforge/bundled/cBc")
local Cryo = require(CorePackages.Packages.Cryo)
local omniFeedService = require("@luauforge/bundled/dEe").OmniFeedService

local feedItemModel = require("@luauforge/bundled/dtb").Modules.Personalization.OmniFeed.DataStore.FeedItemModel

local defineFastFlag = game:DefineFastFlag("FixFeedItemRenderedRowsEqualityCheck", false)

return {
	combineOmniFeedItems = function(list, list2)
		local result = {}
		local v5 = {}

		local omniFeedItemMap = omniFeedService.get():getOmniFeedItemMap()

		if list2 then
			for i, item in ipairs(list2) do
				if not (item.dataSource ~= module2.DataSourceType.Local and omniFeedItemMap.hasComponent(item.treatmentType)) then
					continue
				end

				local uniqueNameForFeed = feedItemModel.getUniqueNameForFeed(item)

				if uniqueNameForFeed then
					module.assert(
						v5[uniqueNameForFeed] == nil,
						"Duplicate feed item id detected: " .. tostring(uniqueNameForFeed)
					)

					v5[uniqueNameForFeed] = item
				end

				table.insert(result, item)
			end
		end

		if not list then
			return result
		end

		for i, item in ipairs(list) do
			if not (item.dataSource == module2.DataSourceType.Local and omniFeedItemMap.hasComponent(item.treatmentType)) then
				continue
			end

			local uniqueNameForFeed = feedItemModel.getUniqueNameForFeed(item)

			assert(uniqueNameForFeed)

			if v5[uniqueNameForFeed] ~= nil then
				continue
			end

			v5[uniqueNameForFeed] = item
			local orderHint

			if item.orderHint then
				orderHint = item.orderHint

				while
					orderHint <= #result
					and result[orderHint]
					and result[orderHint].dataSource == module2.DataSourceType.Local
					and result[orderHint].orderHint
					and result[orderHint].orderHint == item.orderHint
				do
					orderHint += 1
				end
			end

			if orderHint == nil or not (orderHint <= #result) then
				table.insert(result, item)
			else
				table.insert(result, orderHint, item)
			end
		end

		return result
	end,
	setFeedItemRenderedRows = function(p2, p3, p4, value)
		if not p2 then
			return nil
		end

		local v5 = p2[p3]

		if not (v5 and v5 == p4) then
			return nil
		end

		module.assert(
			v5.actualRenderedRows ~= nil,
			`WARNING: feed item was not set up for overwriting its number of rows.  "actualRenderedRows" should be defined in the FeedItemModel (feed item: {feedItemModel.getUniqueNameForAnalytics(v5)}`
		)
		local v6 = defineFastFlag and (value or -1) or nil
		local actualRenderedRows = v5.actualRenderedRows
		local v7 = if defineFastFlag then v6 else value

		if actualRenderedRows == v7 then
			return nil
		end

		local clone = table.clone(p2)
		clone[p3] = Cryo.Dictionary.join(clone[p3], {
			actualRenderedRows = not defineFastFlag and (value or -1) or v6
		})

		return clone
	end
}
