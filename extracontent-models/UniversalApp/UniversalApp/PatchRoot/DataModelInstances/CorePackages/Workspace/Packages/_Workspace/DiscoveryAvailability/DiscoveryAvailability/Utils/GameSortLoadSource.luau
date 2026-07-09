local t1 = {}

return {
	GameSortLoadSourceType = {
		API = "API",
		ClientFallbackCache = "ClientFallbackCache"
	},
	setSortLoadSource = function(s1: string, s2: string?) -- line: 10
		-- upvalues: t1 (copy)
		if s2 then
			t1[s1] = s2

			return
		end

		t1[s1] = nil
	end,
	getSortLoadSource = function(s3: string) -- line: 18
		-- upvalues: t1 (copy)
		return t1[s3]
	end
}
