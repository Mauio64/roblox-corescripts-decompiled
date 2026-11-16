local parent = script.Parent.Parent
local Promise = require(parent.Promise)
local parseSubscriptionError = require(parent.Utils.parseSubscriptionError)

local function getSubscriptionPurchaseInfo(p, p2)
	return p.getSubscriptionPurchaseInfo(p2):catch(function(p3)
		return Promise.reject(parseSubscriptionError(p3))
	end)
end

return getSubscriptionPurchaseInfo
