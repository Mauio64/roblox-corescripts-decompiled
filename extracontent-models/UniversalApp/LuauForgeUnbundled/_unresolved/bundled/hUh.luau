local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local tutils = require(CorePackages.Packages.tutils)
local module = require("@luauforge/bundled/hUi")

return Rodux.createReducer({ hasBlur = false, blurDisplayOrder = 0, details = {} }, {
	[module.name] = function(p2, data)
		local v6

		if data.blur == true then
			v6 = Cryo.Dictionary.join(p2.details, { [data.source] = data.displayOrder })
		else
			v6 = Cryo.Dictionary.join(p2.details, { [data.source] = Cryo.None })
		end

		local v7 = tutils.fieldCount(v6) > 0
		local maxValue = 0

		for k, v8 in pairs(v6) do
			maxValue = math.max(maxValue, v8)
		end

		return { hasBlur = v7, blurDisplayOrder = maxValue, details = v6 }
	end
})
