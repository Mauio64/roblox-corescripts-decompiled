local fn = _G.__DEV__ and function(p: string?)
	if p == nil then
		error("invariant requires an error message argument")
	end
end or function(_: string?) end

local function invariant(flag: boolean, formatString: string?, ...)
	fn(formatString)

	if not flag then
		if formatString == nil then
			error(
				"Minified exception occurred; use the non-minified dev environment for the full error message and additional helpful warnings.",
				2
			)
		else
			error(string.format(formatString, ...), 2)
		end
	end
end

return invariant
