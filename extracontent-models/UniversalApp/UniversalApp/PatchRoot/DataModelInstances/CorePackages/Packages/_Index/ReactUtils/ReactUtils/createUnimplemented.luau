local function createUnimplemented(s1: string) -- line: 2
	return function() -- line: 3
		-- upvalues: s1 (copy)
		error(`Calling unimplemented function { s1 }`)
	end
end

return createUnimplemented
