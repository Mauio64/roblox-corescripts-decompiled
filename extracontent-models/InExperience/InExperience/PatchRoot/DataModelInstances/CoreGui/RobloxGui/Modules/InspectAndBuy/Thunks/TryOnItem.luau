local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Analytics = require(ParentParent.Services.Analytics)
local SetTryingOnInfo = require(ParentParent.Actions.SetTryingOnInfo)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local Constants = require(ParentParent.Constants)
local t1 = { Analytics }

local function TryOnItem(p1, p2, p3, p4, p5) -- line: 18
	-- upvalues: Thunk (copy), t1 (copy), Analytics (copy), SetTryingOnInfo (copy), SendCounter (copy), Constants (copy)
	return Thunk.new(script.Name, t1, function(p6, p7) -- line: 19
		-- upvalues: Analytics (copy), p4 (copy), p5 (copy), p2 (copy), SetTryingOnInfo (copy), p1 (copy), p3 (copy), SendCounter (copy), Constants (copy)
		local v16 = p7[Analytics]
		local s1, v18

		if p4 then
			s1 = "Bundle"
			v18 = p5
		else
			s1 = "Asset"
			v18 = p2
		end

		v16.reportTryOnButtonClicked(s1, v18)
		p6:dispatch(SetTryingOnInfo(p1, p2, p3))
		p6:dispatch(SendCounter(Constants.Counters.TryOnButtonClicked))
	end)
end

return TryOnItem
