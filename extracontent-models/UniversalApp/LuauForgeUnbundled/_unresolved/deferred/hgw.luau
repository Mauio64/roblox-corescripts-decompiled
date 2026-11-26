local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local Dash = require(CorePackages.Packages.Dash)

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
require("@game/CorePackages/Workspace/Packages/Http")

local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local module2 = require("@luauforge/bundled/dPU")
local module3 = require("@luauforge/bundled/dVl")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local module4 = require("@luauforge/bundled/dVG")

local function keyMapper(p2, p3, p4)
	return module2.GetTopicsKey .. module3.getTopicRequestKey(p2, p3, p4)
end

return function(p2, list, options, p3)
	return performFetch.Single(
		module2.GetTopicsKey .. module3.getTopicRequestKey(list, options, p3),
		function(object)
			local v5

			if #list == 0 and not p3 then
				v5 = GetExperienceSourceLanguage.GetInitialTopics(p2, options or {})
			else
				v5 = GetExperienceSourceLanguage.GetTopics(p2, list, p3)
			end

			return v5:andThen(function(p4)
				local responseBody = p4.responseBody or {}
				local mapped = Dash.map(responseBody.topics or {}, function(p5)
					return string.lower(p5.displayName)
				end)

				object:dispatch(module4(list, options, p3, mapped))
				return Promise.resolve(mapped)
			end, function(p4)
				logging.warn("FetchTopics failure: " .. tostring(p4))
			end)
		end
	)
end
