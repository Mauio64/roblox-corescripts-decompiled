local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dVN")

return Rodux.createReducer({ nextPageCursor = nil, hasMoreRows = nil }, {
	[module.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, {
			nextPageCursor = p3.cursor,
			hasMoreRows = p3.cursor ~= nil
		})
	end
})
