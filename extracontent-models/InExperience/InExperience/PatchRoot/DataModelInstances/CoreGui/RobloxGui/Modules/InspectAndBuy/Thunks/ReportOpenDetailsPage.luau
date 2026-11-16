local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Analytics = require(parent.Services.Analytics)
local UtilityFunctions = require(parent.UtilityFunctions)
local SendCounter = require(parent.Thunks.SendCounter)
local Constants = require(parent.Constants)

local v = { Analytics }

local function ReportOpenDetailsPage(p)
	return Thunk.new(script.Name, v, function(object, p2)
		local v2 = p2[Analytics]
		local v3, v4

		if p and p.parentBundleId ~= nil then
			v3 = UtilityFunctions.getBundleId(p)
			v4 = "Bundle"
		else
			v3 = p.assetId
			v4 = "Asset"
		end

		v2.reportItemDetailPageOpened(v4, v3)
		object:dispatch(SendCounter(Constants.Counters.ItemDetailPageOpened))
	end)
end

return ReportOpenDetailsPage
