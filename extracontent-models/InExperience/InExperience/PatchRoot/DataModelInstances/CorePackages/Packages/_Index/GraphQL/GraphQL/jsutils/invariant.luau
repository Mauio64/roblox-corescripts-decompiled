return {
	invariant = function(p, value: string?)
		if not p then
			error(value or "Unexpected invariant triggered.")
		end
	end
}
