local module = require("@luauforge/bundled/egs")
local module2 = require("@luauforge/bundled/hRN")
local module3 = require("@luauforge/bundled/ehl")
local module4 = require("@luauforge/bundled/ehm")

local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

return function(p2, p3, p4)
	return function(object)
		return module2(p2):andThen(function(p5)
			local v5 = p5.responseBody.verified
			local emailAddress = p5.responseBody.emailAddress
			local v6 = emailAddress and emailAddress ~= ""

			if p3 then
				v5 = v5 or v6
			end

			if v5 then
				return module.resolve({ EmailAddress = emailAddress })
			end

			local joined = { emailAddress = emailAddress }

			if p4 then
				joined = Cryo.Dictionary.join(joined, p4)
			end

			object:dispatch(module4(module3.EmailVerificationUpsellOverlay, joined))
			return module.reject()
		end, function(p5)
			return module.resolve()
		end)
	end
end
