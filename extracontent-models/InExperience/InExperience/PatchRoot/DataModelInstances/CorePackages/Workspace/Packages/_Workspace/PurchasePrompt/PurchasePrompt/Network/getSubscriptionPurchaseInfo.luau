local ParentParent = script.Parent.Parent
local Promise = require(ParentParent.Promise)
local parseSubscriptionError = require(ParentParent.Utils.parseSubscriptionError)

local function getSubscriptionPurchaseInfo(p1, p2) -- line: 5
	-- upvalues: Promise (copy), parseSubscriptionError (copy)
	return p1.getSubscriptionPurchaseInfo(p2):catch(function(p3) -- line: 6
		-- upvalues: Promise (copy), parseSubscriptionError (copy)
		return Promise.reject(parseSubscriptionError(p3))
	end)
end

return getSubscriptionPurchaseInfo
