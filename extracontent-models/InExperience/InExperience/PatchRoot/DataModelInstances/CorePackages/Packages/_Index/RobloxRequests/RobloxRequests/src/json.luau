local HttpService = game:GetService("HttpService")

return {
	enc = function(p1) -- line: 5
		-- upvalues: HttpService (copy)
		return HttpService:JSONEncode(p1)
	end,
	dec = function(p2) -- line: 9
		-- upvalues: HttpService (copy)
		return HttpService:JSONDecode(p2)
	end
}
