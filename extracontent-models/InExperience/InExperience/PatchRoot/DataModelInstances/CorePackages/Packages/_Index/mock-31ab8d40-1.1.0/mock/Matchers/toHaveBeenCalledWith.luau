local parent = script.Parent.Parent
local MagicMock = require(parent.MagicMock)
local Spy = require(parent.Spy)
local AnyCallMatches = require(parent.AnyCallMatches)
local fmtArgs = require(parent.fmtArgs)
local symbols = require(parent.symbols)

local function getLiteralPredicate(p) -- 1 equivalent call inferred from this helper
	return function(p2): boolean
		return p2 == p
	end
end

local function isPredicate(p) -- 1 equivalent call inferred from this helper
	if type(p) == "table" and p[symbols.isPredicate] then
		return not MagicMock.is(p)
	end
end

return function(p, ...)
	if not (MagicMock.is(p) or Spy.is(p)) then
		return {
			pass = false,
			message = string.format(
				"expect(mock) must be a MagicMock or Spy when .toHaveBeenCalledWith is used. Given %s instead",
				(tostring(p))
			)
		}
	end

	local v = table.pack(...)

	local v2 = {}

	for _, v3 in ipairs(v) do
		if isPredicate(v3) then -- inferred equivalent call
			table.insert(v2, v3.predicate)
		else
			table.insert(v2, getLiteralPredicate(v3)) -- inferred equivalent call
		end
	end

	local predicates, v3 = AnyCallMatches.predicates(p, table.unpack(v2))
	return {
		pass = predicates,
		message = predicates and string.format(
			"Expected %s to never have been called with args: %s",
			tostring(p),
			fmtArgs(v)
		) or string.format("Expected %s to have been called with args: %s", tostring(p), v3)
	}
end
