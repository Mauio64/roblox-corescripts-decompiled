local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)

require(ParentParent.Shared)

local lib = require(script.Parent["ReactBinding.roblox"])

return {
	createRef = function() -- line: 26
		-- upvalues: lib (copy), ReactGlobals (copy)
		local v4, _ = lib.create(nil)
		local t1 = {}

		if ReactGlobals.__DEV__ then
			v4._source = debug.traceback("Ref created at:", 1)
		end

		setmetatable(t1, {
			__index = function(_, p2) -- line: 44
				-- upvalues: v4 (copy)
				if p2 == "current" then
					return v4:getValue()
				end

				return v4[p2]
			end,
			__newindex = function(_, p4, p5) -- line: 51
				-- upvalues: lib (copy), v4 (copy)
				if p4 == "current" then
					lib.update(v4, p5)
				end

				v4[p4] = p5
			end,
			__tostring = function(_) -- line: 62
				-- upvalues: v4 (copy)
				return string.format("Ref(%s)", (tostring(v4:getValue())))
			end
		})

		return t1
	end
}
