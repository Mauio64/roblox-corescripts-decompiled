local n1 = 0

return function() -- line: 7
	-- upvalues: n1 (ref)
	n1 += 1

	return ("MOCK-%d"):format(n1)
end
