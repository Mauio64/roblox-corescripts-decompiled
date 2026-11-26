local module = require("@luauforge/deferred/gzz")

return function(p2, p3)
	return module(p2, p3):andThen(function(p4): boolean
		local responseBody = p4 and p4.responseBody
		local consents = if typeof(responseBody) == "table" then responseBody.consents else nil

		if typeof(consents) ~= "table" then
			return false
		end

		for i, consent in ipairs(consents) do
			local consentData = if typeof(consent) == "table" then consent.consentData else nil

			if typeof(consentData) == "table" and consentData.restrictionType == "PlatformAccess" then
				return true
			end
		end

		return false
	end, function(): boolean
		return false
	end)
end
