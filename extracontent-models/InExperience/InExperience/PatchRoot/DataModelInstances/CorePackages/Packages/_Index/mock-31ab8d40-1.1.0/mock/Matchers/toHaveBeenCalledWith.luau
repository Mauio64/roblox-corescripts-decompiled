local ParentParent = script.Parent.Parent
local MagicMock = require(ParentParent.MagicMock)
local Spy = require(ParentParent.Spy)
local AnyCallMatches = require(ParentParent.AnyCallMatches)
local fmtArgs = require(ParentParent.fmtArgs)
local symbols = require(ParentParent.symbols)

local function getLiteralPredicate(p1) -- line: 8
	return function(p2) -- line: 9
		-- upvalues: p1 (copy)
		return p2 == p1
	end
end
local function isPredicate(p3) -- line: 14
	-- upvalues: symbols (copy), MagicMock (copy)
	if type(p3) == "table" and p3[symbols.isPredicate] then
		return not MagicMock.is(p3)
	end
end

return function(p4, ...) -- line: 20
	-- upvalues: MagicMock (copy), Spy (copy), symbols (copy), AnyCallMatches (copy), fmtArgs (copy)
	if not MagicMock.is(p4) and not Spy.is(p4) then
		return {
			pass = false,
			message = string.format("expect(mock) must be a MagicMock or Spy when .toHaveBeenCalledWith is used. Given %s instead", (tostring(p4)))
		}
	end

	local v12 = table.pack(...)
	local t1 = {}

	for _, v in ipairs(v12) do
		if if type(v) ~= "table" or not v[symbols.isPredicate] then nil else not MagicMock.is(v) then
			table.insert(t1, v.predicate)
		else
			table.insert(t1, function(p5) -- line: 9
				-- upvalues: v (copy)
				return p5 == v
			end)
		end
	end

	local v16, v17 = AnyCallMatches.predicates(p4, table.unpack(t1))

	return {
		pass = v16,
		message = v16 and string.format("Expected %s to never have been called with args: %s", tostring(p4), fmtArgs(v12)) or string.format("Expected %s to have been called with args: %s", tostring(p4), v17)
	}
end
