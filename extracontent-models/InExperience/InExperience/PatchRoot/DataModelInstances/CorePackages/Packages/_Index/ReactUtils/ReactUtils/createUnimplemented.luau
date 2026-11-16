local function createUnimplemented(p: string)
	return function()
		error(`Calling unimplemented function {p}`)
	end
end

return createUnimplemented
