return function(p1, s1: string, s2: string, s3: string) -- line: 1
	local t1 = {
		origin = s2,
		btn = s3
	}

	p1.sendEventDeferred(s1, "buttonClick", t1)
end
