return function(p1, s1: string, s2: string, s3: string) -- line: 1
	local t1 = {
		aType = s3,
		origin = s2
	}

	p1.sendEventDeferred(s1, "modalAction", t1)
end
