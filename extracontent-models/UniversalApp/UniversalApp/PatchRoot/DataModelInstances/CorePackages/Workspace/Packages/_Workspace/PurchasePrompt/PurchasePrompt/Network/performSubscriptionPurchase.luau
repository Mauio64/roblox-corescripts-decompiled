local ParentParent = script.Parent.Parent
local Promise = require(ParentParent.Promise)
local parseSubscriptionError = require(ParentParent.Utils.parseSubscriptionError)

local function performSubscriptionPurchase(p1, p2, p3) -- line: 5
	-- upvalues: Promise (copy), parseSubscriptionError (copy)
	return p1.performSubscriptionPurchase(p2, p3):catch(function(p4) -- line: 6
		-- upvalues: Promise (copy), parseSubscriptionError (copy)
		return Promise.reject(parseSubscriptionError(p4))
	end)
end

return performSubscriptionPurchase
