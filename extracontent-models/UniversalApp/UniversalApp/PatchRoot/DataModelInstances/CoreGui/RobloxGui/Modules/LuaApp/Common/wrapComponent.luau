local CorePackages = game:GetService("CorePackages")

require(CorePackages.Packages.React)

return function(p1: ((...any) -> ...any)) -- line: 25
	return function(p2) -- line: 26
		-- upvalues: p1 (copy)
		return function(p3) -- line: 27
			-- upvalues: p1 (copy), p2 (copy)
			return p1(p2, p3)
		end
	end
end
