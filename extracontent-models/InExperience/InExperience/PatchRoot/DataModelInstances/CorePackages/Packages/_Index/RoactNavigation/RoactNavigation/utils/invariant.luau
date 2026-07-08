local function u1(_: string?) -- line: 12
end

if _G.__DEV__ then
	function u1(s2: string?) -- line: 15
		if s2 == nil then
			error("invariant requires an error message argument")
		end
	end
end

local function invariant(b1: boolean, s3: string?, ...) -- line: 22
	-- upvalues: u1 (ref)
	u1(s3)

	if not b1 then
		if s3 == nil then
			error("Minified exception occurred; use the non-minified dev environment for the full error message and additional helpful warnings.", 2)

			return
		end

		error(string.format(s3, ...), 2)
	end
end

return invariant
