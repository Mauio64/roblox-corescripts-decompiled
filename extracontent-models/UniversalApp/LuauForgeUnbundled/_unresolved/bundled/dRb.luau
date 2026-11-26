local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module2 = require("@luauforge/bundled/dKU")

local module3 = require("@luauforge/bundled/dQW")
local module4 = require("@luauforge/bundled/dQX")
local module5 = require("@luauforge/bundled/dQY")
local removeLook = module2.Actions.RemoveLook

local module6 = require("@luauforge/bundled/dQr")

local axRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

return (Rodux.createReducer({}, {
	[module3.name] = function(p2, data)
		if not data.context then
			return p2
		end

		local v6 = {
			Details = data.widgetInfo,
			RequestId = data.requestId,
			FetchTime = tick(),
			Configuration = data.configuration
		}

		return Cryo.Dictionary.join(p2, { [data.context] = v6 })
	end,
	[module4.name] = function(p2, p3)
		if not p3.context then
			return p2
		end

		return Cryo.Dictionary.join(p2, { [p3.context] = Cryo.None })
	end,
	[module5.name] = function(items, p2)
		local widgetId = p2.widgetId

		local result = {}

		for k, item in items do
			local nones = {}

			for k2, detail in item.Details do
				if detail.id == widgetId then
					nones[k2] = Cryo.None
				end
			end

			result[k] = Cryo.Dictionary.join(item, {
				Details = Cryo.Dictionary.join(item.Details, nones)
			})
		end

		return result
	end,
	[removeLook.name] = function(items, p2)
		local clone = table.clone(items)

		for k, item in pairs(items) do
			local values = {}

			for k2, detail in pairs(item.Details) do
				if not detail.content then
					continue
				end

				local v6 = {}

				for k3, v7 in detail.content do
					if v7.id ~= p2.lookId then
						table.insert(v6, v7)
					end
				end

				values[k2] = Cryo.Dictionary.join(detail, { content = v6 })
			end

			clone[k] = Cryo.Dictionary.join(item, { Details = values })
		end

		return clone
	end,
	[module6.name] = axRecentlyViewedSearchItemsIXPTest.isEnabled() and function(p2, p3)
		local widget = p3.widget
		local v6 = {
			Details = widget.widgetInfo,
			RequestId = widget.requestId,
			FetchTime = tick()
		}

		return Cryo.Dictionary.join(p2, { [widget.context] = v6 })
	end or nil
}))
