local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Analytics = require(parent.Services.Analytics)
local GetPurchaseAnalyticsOptions = require(parent.Selectors.GetPurchaseAnalyticsOptions)

local v = { Analytics }

local function ReportPurchaseSuccessUnifiedEvent(p, p2, p3: number?)
	return Thunk.new(script.Name, v, function(object, p4)
		p4[Analytics].reportPurchaseSuccessUnifiedEvent(
			p2,
			p,
			GetPurchaseAnalyticsOptions(object:getState(), p, p2, p3)
		)
	end)
end

return ReportPurchaseSuccessUnifiedEvent
