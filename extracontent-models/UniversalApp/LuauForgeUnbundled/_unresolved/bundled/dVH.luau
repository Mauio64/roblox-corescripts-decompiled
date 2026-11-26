local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dVl")
local module2 = require("@luauforge/bundled/dVG")

return Rodux.createReducer({}, {
	[module2.name] = function(p2, data)
		local topicRequestKey = module.getTopicRequestKey(
			data.selectedTopics,
			data.initialItems,
			data.searchKeyword
		)
		local now = tick()

		return Cryo.Dictionary.join(p2, { [topicRequestKey] = now })
	end
})
