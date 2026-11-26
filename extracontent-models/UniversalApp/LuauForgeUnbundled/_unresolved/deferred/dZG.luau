local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/Rodux")
local module2 = require("@luauforge/deferred/dZD")

local networkingCurrentlyWearing = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/App/Networking").NetworkingCurrentlyWearing
local module3 = require("@luauforge/deferred/eac")

return Rodux.createReducer({}, {
	[networkingCurrentlyWearing.GetItemDetails.Succeeded.name] = function(p2, p3)
		local v6 = {}

		for k, v7 in p3.responseBody.data do
			local v8 = module3.fromAsset(v7)
			v6[v8.id] = v8
		end

		return module2.Dictionary.join(p2, v6)
	end
})
