local module = require("@luauforge/bundled/egs")
local module2 = require("@luauforge/bundled/guQ")
local HttpService = game:GetService("HttpService")

return function(p2, p3, p4)
	return module2(p2, p3, p4):andThen(function(p5)
		if p5 and p5.responseBody and p5.responseBody.data then
			local jsonDecode = HttpService:JSONDecode(p5.responseBody.data)
			return module.resolve(jsonDecode)
		end

		return module.reject()
	end, function(p5)
		return module.reject({ p5.StatusCode })
	end)
end
