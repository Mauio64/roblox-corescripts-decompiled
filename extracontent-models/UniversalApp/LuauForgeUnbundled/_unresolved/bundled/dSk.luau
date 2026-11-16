local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dRQ")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module2 = require("@luauforge/bundled/dSl")

return Rodux.createReducer({}, {
	[module2.name] = function(p2, data)
		local topicRequestKey = module.getTopicRequestKey(
			data.selectedTopics,
			data.initialItems,
			data.searchKeyword
		)
		return Cryo.Dictionary.join(p2, { [topicRequestKey] = data.newTopics })
	end
})
