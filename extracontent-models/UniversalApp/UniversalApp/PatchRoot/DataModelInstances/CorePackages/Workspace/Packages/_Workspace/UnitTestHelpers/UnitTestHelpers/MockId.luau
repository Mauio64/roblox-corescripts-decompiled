local n1 = 0

return function() -- line: 14
	-- upvalues: n1 (ref)
	n1 += 1

	return (tostring(n1))
end
