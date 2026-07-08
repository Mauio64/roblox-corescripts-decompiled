local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local Shared = require(ParentParent.Shared)
local console = Shared.console
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local inspect = LuauPolyfill.util.inspect
local ReactSymbols = Shared.ReactSymbols
local REACT_MEMO_TYPE = ReactSymbols.REACT_MEMO_TYPE
local REACT_ELEMENT_TYPE = ReactSymbols.REACT_ELEMENT_TYPE
local isValidElementType = Shared.isValidElementType
local getComponentName = Shared.getComponentName

return {
	memo = function(p1, p2: ((...any) -> ...any)?) -- line: 47
		-- upvalues: ReactGlobals (copy), isValidElementType (copy), Object (copy), Array (copy), REACT_ELEMENT_TYPE (copy), getComponentName (copy), inspect (copy), console (copy), REACT_MEMO_TYPE (copy)
		if ReactGlobals.__DEV__ and not isValidElementType(p1) then
			local s1 = ""

			if p1 == nil or typeof(p1) == "table" and #Object.keys(p1) == 0 then
				s1 ..= " You likely forgot to export your component from the file it's defined in, or you might have mixed up default and named imports."
			end

			local s2

			if p1 == nil then
				s2 = "nil"
			elseif Array.isArray(p1) then
				s2 = "array"
			elseif p1 ~= nil and typeof(p1) == "table" and p1["$$typeof"] == REACT_ELEMENT_TYPE then
				s2 = string.format("<%s />", getComponentName(p1.type) or "UNKNOWN")
				s1 = " Did you accidentally export a JSX literal or Element instead of a component?"
			else
				s2 = typeof(p1)

				if p1 ~= nil then
					s1 = "\n" .. inspect(p1)
				end
			end

			console.error("memo: The first argument must be a component. Instead received: `%s`.%s", s2, s1)
		end

		local t1 = {
			["$$typeof"] = REACT_MEMO_TYPE,
			type = p1,
			compare = p2 or nil
		}

		if ReactGlobals.__DEV__ then
			local u19 = nil

			setmetatable(t1, {
				__index = function(p3, p4) -- line: 113
					-- upvalues: u19 (ref)
					if p4 == "displayName" then
						return u19
					end

					return (rawget(p3, p4))
				end,
				__newindex = function(p5, p6, p7) -- line: 119
					-- upvalues: u19 (ref), p1 (copy)
					if p6 == "displayName" then
						u19 = p7

						if typeof(p1) == "table" and p1.displayName == nil then
							p1.displayName = u19

							return
						end
					else
						rawset(p5, p6, p7)
					end
				end
			})
		end

		return t1
	end
}
