local module = require("@luauforge/bundled/fAO")
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local module2 = require("@luauforge/bundled/ecV")

return function(p2, p3, p4)
	return function(object)
		local fetchingStatus = module.GetFetchingStatus(object:getState(), p3, p2)

		if fetchingStatus == retrievalStatus.Done or fetchingStatus == retrievalStatus.Failed then
			return module2.resolve()
		end

		return module2.new(function(callback, p5)
			object:dispatch(module.Fetch(p2, p3, p4)):andThen(function()
				callback()
			end, function()
				callback()
			end)
		end)
	end
end
