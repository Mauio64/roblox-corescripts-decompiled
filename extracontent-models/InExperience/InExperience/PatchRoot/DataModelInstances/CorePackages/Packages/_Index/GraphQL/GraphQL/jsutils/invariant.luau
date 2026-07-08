return {
	invariant = function(p1, s1: string?) -- line: 8
		if not p1 then
			error(s1 or "Unexpected invariant triggered.")
		end
	end
}
