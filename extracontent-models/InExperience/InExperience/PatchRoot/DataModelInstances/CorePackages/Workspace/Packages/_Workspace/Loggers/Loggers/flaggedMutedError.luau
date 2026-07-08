local mutedError = require(script.Parent.mutedError)

game:DefineFastString("SuppressMutedErrorKeys", "")

local function getFStringSuppressMutedErrorKeys() -- line: 32
	return game:GetFastString("SuppressMutedErrorKeys")
end

local s1 = ""
local t1 = {}

local function shouldSuppressMutedError(s2: string) -- line: 39
	-- upvalues: s1 (ref), t1 (ref)
	local FastString = game:GetFastString("SuppressMutedErrorKeys")

	if FastString ~= s1 then
		s1 = FastString
		t1 = {}

		for _, v10 in (FastString:split(",")) do
			t1[v10] = true
		end
	end

	return t1[s2] or false
end
local function flaggedMutedError(s3: string, s4: string, p1) -- line: 53
	-- upvalues: shouldSuppressMutedError (copy), mutedError (copy)
	if not shouldSuppressMutedError(s3) then
		mutedError(s4, p1)
	end
end

return flaggedMutedError
