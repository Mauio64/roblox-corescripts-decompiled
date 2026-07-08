return function(p1) -- line: 1
	return {
		account = function(s1: string) -- line: 4
			-- upvalues: p1 (copy)
			return p1.fromString("auth:v1/" .. s1 .. "/account")
		end,
		connect = function(s2: string) -- line: 8
			-- upvalues: p1 (copy)
			return p1.fromString("auth:v1/" .. s2 .. "/connect")
		end,
		disconnect = function(s3: string) -- line: 12
			-- upvalues: p1 (copy)
			return p1.fromString("auth:v1/" .. s3 .. "/disconnect")
		end,
		login = function(s4: string) -- line: 16
			-- upvalues: p1 (copy)
			return p1.fromString("auth:v1/" .. s4 .. "/login")
		end,
		signup = function(s5: string) -- line: 20
			-- upvalues: p1 (copy)
			return p1.fromString("auth:v1/" .. s5 .. "/signup")
		end
	}
end
