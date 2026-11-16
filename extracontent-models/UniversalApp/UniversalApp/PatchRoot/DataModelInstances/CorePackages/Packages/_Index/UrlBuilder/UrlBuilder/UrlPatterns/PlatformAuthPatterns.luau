return function(p)
	return {
		account = function(p2: string)
			return p.fromString("auth:v1/" .. p2 .. "/account")
		end,
		connect = function(p2: string)
			return p.fromString("auth:v1/" .. p2 .. "/connect")
		end,
		disconnect = function(p2: string)
			return p.fromString("auth:v1/" .. p2 .. "/disconnect")
		end,
		login = function(p2: string)
			return p.fromString("auth:v1/" .. p2 .. "/login")
		end,
		signup = function(p2: string)
			return p.fromString("auth:v1/" .. p2 .. "/signup")
		end
	}
end
