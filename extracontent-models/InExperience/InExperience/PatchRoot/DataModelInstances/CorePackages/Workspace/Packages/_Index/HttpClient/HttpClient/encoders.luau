local HttpService = game:GetService("HttpService")

require(script.Parent.types)

return {
	encodeJson = function(p1) -- line: 8
		-- upvalues: HttpService (copy)
		return HttpService:JSONEncode(p1), "application/json"
	end,
	encodeRaw = function(s1: string) -- line: 13
		return function(p2) -- line: 14
			-- upvalues: s1 (copy)
			local v5 = typeof(p2)

			if v5 ~= "string" and v5 ~= "buffer" then
				error(`encodeRaw: expected string or buffer body, got { v5 }`)
			end

			return p2, s1
		end
	end
}
