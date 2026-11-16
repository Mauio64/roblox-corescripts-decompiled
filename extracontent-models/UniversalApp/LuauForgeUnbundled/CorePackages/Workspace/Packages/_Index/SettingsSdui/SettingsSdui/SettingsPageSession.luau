local HttpService = game:GetService("HttpService")

local v5 = ""

return {
	Get = function(p2)
		if v5 == "" then
			v5 = HttpService:GenerateGUID(false)
		end

		return v5
	end,
	Refresh = function(self)
		v5 = HttpService:GenerateGUID(false)
		return v5
	end
}
