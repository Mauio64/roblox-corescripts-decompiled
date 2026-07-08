return {
	rectangle = function(p1, p2) -- line: 2
		return {
			top = p2,
			bottom = p2,
			left = p1,
			right = p1
		}
	end,
	square = function(p3) -- line: 10
		return {
			top = p3,
			bottom = p3,
			left = p3,
			right = p3
		}
	end,
	quad = function(p4, p5, p6, p7) -- line: 18
		return {
			top = p4,
			bottom = p6,
			left = p7,
			right = p5
		}
	end
}
