local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dQW")
local module2 = require("@luauforge/bundled/dQX")
local module3 = require("@luauforge/bundled/dQY")

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

return (Rodux.createReducer({
	Details = {},
	RequestId = nil,
	FetchTime = nil,
	Configuration = nil
}, {
	[module.name] = function(p2, data)
		if data.query or data.context then
			return p2
		end

		return {
			Details = data.widgetInfo,
			RequestId = data.requestId,
			FetchTime = tick(),
			Configuration = data.configuration
		}
	end,
	[module2.name] = function(p2, p3)
		if p3.query or p3.context then
			return p2
		end

		return { Details = {} }
	end,
	[module3.name] = function(p2, p3)
		local widgetId = p3.widgetId

		local nones = {}

		for k, detail in p2.Details do
			if detail.id == widgetId then
				nones[k] = Cryo.None
			end
		end

		return Cryo.Dictionary.join(p2, {
			Details = Cryo.Dictionary.join(p2.Details, nones)
		})
	end
}))
