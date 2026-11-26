local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dQW")
local module2 = require("@luauforge/bundled/dQX")
local module3 = require("@luauforge/bundled/dQY")

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

return (Rodux.createReducer({}, {
	[module.name] = function(p2, data)
		if not data.query then
			return p2
		end

		local v6 = {
			Details = data.widgetInfo,
			RequestId = data.requestId,
			FetchTime = tick(),
			Configuration = data.configuration
		}

		return Cryo.Dictionary.join(p2, { [data.query] = v6 })
	end,
	[module2.name] = function(p2, p3)
		if not p3.query then
			return p2
		end

		return Cryo.Dictionary.join(p2, { [p3.query] = Cryo.None })
	end,
	[module3.name] = function(items, p2)
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
	end
}))
