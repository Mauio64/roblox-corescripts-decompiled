local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Analytics = require(ParentParent.Services.Analytics)
local UtilityFunctions = require(ParentParent.UtilityFunctions)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local t1 = { Analytics }

local function ReportOpenDetailsPage(p1) -- line: 18
	-- upvalues: Thunk (copy), t1 (copy), Analytics (copy), UtilityFunctions (copy), SendCounter (copy), Constants (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 19
		-- upvalues: Analytics (copy), p1 (copy), UtilityFunctions (copy), SendCounter (copy), Constants (copy)
		local v12 = p3[Analytics]
		local s1, v14

		if p1 and p1.parentBundleId ~= nil then
			s1 = "Bundle"
			v14 = UtilityFunctions.getBundleId(p1)
		else
			s1 = "Asset"
			v14 = p1.assetId
		end

		v12.reportItemDetailPageOpened(s1, v14)
		p2:dispatch(SendCounter(Constants.Counters.ItemDetailPageOpened))
	end)
end

return ReportOpenDetailsPage
