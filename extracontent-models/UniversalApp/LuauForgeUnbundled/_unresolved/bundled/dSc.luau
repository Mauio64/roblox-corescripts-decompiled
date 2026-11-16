local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dSd")
local module2 = require("@luauforge/bundled/dSe")
local module3 = require("@luauforge/bundled/dSf")
local Cryo = require(CorePackages.Packages.Cryo)

return Rodux.createReducer({}, {
	[module.name] = function(p2, p3)
		local assetId = p3.assetId
		local userAssetIdList = p3.userAssetIdList

		return Cryo.Dictionary.join(p2, { [assetId] = userAssetIdList })
	end,
	[module2.name] = function(p2, p3)
		local assetId = p3.assetId
		local joined = { p3.userAssetId }

		local v6 = p2[assetId]

		if v6 then
			joined = Cryo.List.join(v6, joined)
		end

		return Cryo.Dictionary.join(p2, { [assetId] = joined })
	end,
	[module3.name] = function(p2, p3)
		local assetId = p3.assetId

		local v6 = p2[assetId]

		if not v6 then
			return p2
		end

		local v7 = Cryo.List.removeValue(v6, p3.userAssetId)

		return Cryo.Dictionary.join(p2, { [assetId] = v7 })
	end
})
