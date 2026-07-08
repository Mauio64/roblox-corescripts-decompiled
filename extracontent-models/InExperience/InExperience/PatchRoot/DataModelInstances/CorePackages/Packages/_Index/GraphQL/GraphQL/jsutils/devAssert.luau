return {
	devAssert = function(p1, s1: string) -- line: 9
		if not p1 then
			error(s1, 2)
		end
	end
}
