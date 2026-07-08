local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Enums.Device)

local Flags = require(Foundation.Utility.Flags)

require(Foundation.Enums.Theme)

local TokenProcessingUtilities = require(Foundation.Providers.Style.Tokens.TokenProcessingUtilities)
local Tokens = require(Foundation.Providers.Style.Tokens)

local function tokenPathToAttributeBase(s1: string) -- line: 14
	return s1:gsub("%.", ""):gsub("_", "")
end
local function emitLeafAttributes(t1: {[any]: any}, s2: string, p1) -- line: 19
	-- upvalues: emitLeafAttributes (copy)
	if type(p1) == "table" then
		for v12, v13 in p1 do
			emitLeafAttributes(t1, s2 .. tostring(v12), v13)
		end

		return
	end

	t1[s2] = p1
end
local function getOverrideAttributes(p2, p3, p4) -- line: 37
	-- upvalues: Flags (copy), Tokens (copy), TokenProcessingUtilities (copy), emitLeafAttributes (copy)
	local t2 = {}

	if not Flags.FoundationTokenOverrides then
		return t2
	end

	if not p4 or not next(p4) then
		return t2
	end

	local v18 = Tokens.getTokens(p2, p3, 1)

	for v19, v20 in p4 do
		local v21 = TokenProcessingUtilities.resolveTokenOverride(v18, v19, v20)

		if v21 ~= nil then
			emitLeafAttributes(t2, v19:gsub("%.", ""):gsub("_", ""), v21)
		end
	end

	return t2
end

return getOverrideAttributes
