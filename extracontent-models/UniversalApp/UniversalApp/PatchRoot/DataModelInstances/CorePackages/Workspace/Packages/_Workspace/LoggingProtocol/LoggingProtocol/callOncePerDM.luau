local t1 = {}

return function(s1: string, p1: ((...any) -> ...any)) -- line: 3
	-- upvalues: t1 (copy)
	if t1[s1] then
		return
	end

	t1[s1] = true
	p1()
end
