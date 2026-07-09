return {
	getStringParam = function(t1: {[any]: any}, s1: string, s2: string?) -- line: 7
		local v4 = t1[s1]

		if typeof(v4) == "string" then
			return v4
		end

		return s2
	end,
	getBooleanParam = function(t2: {[any]: any}, s3: string, b1: boolean) -- line: 12
		local v8 = t2[s3]

		if typeof(v8) == "boolean" then
			return v8
		end

		return b1
	end,
	getCallbackParam = function(t3: {[any]: any}, s4: string, p1: ((...any) -> ...any)?) -- line: 17
		local v12 = t3[s4]

		if typeof(v12) ~= "function" then
			return p1
		end

		return function() -- line: 23
			-- upvalues: v12 (copy)
			v12()
		end
	end
}
