local scriptParent = script.Parent
local Error = require(scriptParent.Error)
local format = require(scriptParent.format)
local v4 = Error.new("ReadonlyKey", "Attempted to write to readonly key {key:?} of frozen object {objectName:?}")
local v5 = Error.new("MissingKey", "Attempted to read missing key {key:?} of frozen object {objectName:?}")

local function freeze(s1: string, p1, b1: boolean?) -- line: 35
	-- upvalues: v5 (copy), v4 (copy), format (copy)
	local t1 = {}

	assert(type(p1) == "table", `Attempted to call Dash.freeze with argument #2 of type { type(p1) }, but it should be table `)
	setmetatable(t1, {
		__index = function(_, p3) -- line: 44
			-- upvalues: p1 (copy), b1 (copy), v5 (copy), s1 (copy)
			local v13 = p1[p3]

			if v13 == nil and b1 then
				v5:throw({
					key = p3,
					objectName = s1
				})
			end

			return v13
		end,
		__newindex = function(_, p5) -- line: 55
			-- upvalues: v4 (copy), s1 (copy)
			v4:throw({
				key = p5,
				objectName = s1
			})
		end,
		__len = function() -- line: 62
			-- upvalues: p1 (copy)
			return #p1
		end,
		__tostring = function() -- line: 65
			-- upvalues: format (copy), s1 (copy)
			return format("Frozen({})", s1)
		end,
		__call = function(_, ...) -- line: 68
			-- upvalues: p1 (copy)
			return p1(...)
		end
	})

	return t1
end

return freeze
