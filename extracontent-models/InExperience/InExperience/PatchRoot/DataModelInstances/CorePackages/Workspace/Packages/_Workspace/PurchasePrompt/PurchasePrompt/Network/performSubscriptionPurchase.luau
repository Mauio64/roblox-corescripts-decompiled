local parent = script.Parent.Parent
local Promise = require(parent.Promise)
local parseSubscriptionError = require(parent.Utils.parseSubscriptionError)

local function performSubscriptionPurchase(p, p2, p3)
	return p.performSubscriptionPurchase(p2, p3):catch(function(p4)
		return Promise.reject(parseSubscriptionError(p4))
	end)
end

return performSubscriptionPurchase
