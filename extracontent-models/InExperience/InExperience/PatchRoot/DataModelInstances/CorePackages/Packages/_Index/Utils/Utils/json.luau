local HttpService = game:GetService("HttpService")

return {
	stringify = function(p1, ...) -- line: 20
		-- upvalues: HttpService (copy)
		if select("#", ...) > 0 then
			warn("JSON.stringify doesn't currently support more than 1 argument. All additional arguments will be ignored.")
		end

		return HttpService:JSONEncode(p1)
	end,
	parse = function(s1: string, ...) -- line: 28
		-- upvalues: HttpService (copy)
		if select("#", ...) > 0 then
			warn("JSON.parse doesn't currently support more than 1 argument. All additional arguments will be ignored.")
		end

		return HttpService:JSONDecode(s1)
	end
}
