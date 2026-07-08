local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local console = require(ParentParent.Shared).console
local ReactSymbols = require(ParentParent.Shared).ReactSymbols

require(ParentParent.Shared)

local REACT_FORWARD_REF_TYPE = ReactSymbols.REACT_FORWARD_REF_TYPE
local REACT_MEMO_TYPE = ReactSymbols.REACT_MEMO_TYPE

return {
	forwardRef = function(p1: ((...any) -> ...any)) -- line: 33
		-- upvalues: ReactGlobals (copy), REACT_MEMO_TYPE (copy), console (copy), REACT_FORWARD_REF_TYPE (copy)
		if ReactGlobals.__DEV__ then
			if typeof(p1) == "table" and p1["$$typeof"] == REACT_MEMO_TYPE then
				console.error("forwardRef requires a render function but received a `memo` component. Instead of forwardRef(memo(...)), use memo(forwardRef(...)).")
			elseif typeof(p1) ~= "function" then
				console.error("forwardRef requires a render function but was given %s.", (typeof(p1)))
			else
				local v8, _ = debug.info(p1, "a")

				if v8 ~= 0 and v8 ~= 2 then
					console.error("forwardRef render functions accept exactly two parameters: props and ref. %s", v8 ~= 1 and "Any additional parameter will be undefined." or "Did you forget to use the ref parameter?")
				end
			end
		end

		local t1 = {
			["$$typeof"] = REACT_FORWARD_REF_TYPE,
			render = p1
		}

		if ReactGlobals.__DEV__ then
			local u11 = nil

			setmetatable(t1, {
				__index = function(p2, p3) -- line: 96
					-- upvalues: u11 (ref)
					if p3 == "displayName" then
						return u11
					end

					return (rawget(p2, p3))
				end,
				__newindex = function(p4, p5, p6) -- line: 102
					-- upvalues: u11 (ref)
					if p5 == "displayName" then
						u11 = p6

						return
					end

					rawset(p4, p5, p6)
				end
			})
		end

		return t1
	end
}
