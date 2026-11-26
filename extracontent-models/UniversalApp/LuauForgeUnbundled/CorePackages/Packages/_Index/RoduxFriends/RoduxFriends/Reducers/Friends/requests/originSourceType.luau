local Rodux = require("@game/CorePackages/Workspace/Packages/Rodux")
local getDeepValue = require("@luauforge/bundled/ejr").SocialLibraries.config({}).Dictionary.getDeepValue

local Cryo = require("@game/CorePackages/Workspace/Packages/Cryo")

local module3 = require("@luauforge/bundled/ejt")

return Rodux.createReducer({}, {
	[module3.GetFriendRequests.Succeeded.name] = function(options, p2)
		local data = p2.responseBody.data

		local foldLeft = Cryo.List.foldLeft(data, function(deepValuesById, p3)
			local deepValue = getDeepValue(p3, "friendRequest.originSourceType")
			deepValuesById[tostring(p3.id)] = deepValue
			return deepValuesById
		end, {})

		return (Cryo.Dictionary.join(options or {}, foldLeft))
	end
})
