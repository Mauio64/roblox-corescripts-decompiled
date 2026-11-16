return {
	devAssert = function(p, message: string)
		if not p then
			error(message, 2)
		end
	end
}
