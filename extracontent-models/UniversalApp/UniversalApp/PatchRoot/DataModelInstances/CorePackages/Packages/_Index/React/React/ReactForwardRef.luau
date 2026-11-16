local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

local Shared = require(parent.Shared)
local console = Shared.console

local Shared2 = require(parent.Shared)
local ReactSymbols = Shared2.ReactSymbols
require(parent.Shared)

local REACT_FORWARD_REF_TYPE = ReactSymbols.REACT_FORWARD_REF_TYPE
local REACT_MEMO_TYPE = ReactSymbols.REACT_MEMO_TYPE

return {
	forwardRef = function(render)
		if ReactGlobals.__DEV__ then
			if typeof(render) == "table" and render["$$typeof"] == REACT_MEMO_TYPE then
				console.error("forwardRef requires a render function but received a `memo` component. Instead of forwardRef(memo(...)), use memo(forwardRef(...)).")
			elseif typeof(render) == "function" then
				local v, _ = debug.info(render, "a")

				if v ~= 0 and v ~= 2 then
					console.error(
						"forwardRef render functions accept exactly two parameters: props and ref. %s",
						v == 1 and "Did you forget to use the ref parameter?" or "Any additional parameter will be undefined."
					)
				end
			else
				console.error("forwardRef requires a render function but was given %s.", (typeof(render)))
			end
		end

		local v = { ["$$typeof"] = REACT_FORWARD_REF_TYPE, render = render }

		if ReactGlobals.__DEV__ then
			local v2 = nil

			setmetatable(v, {
				__index = function(p, p2)
					if p2 == "displayName" then
						return v2
					end

					return (rawget(p, p2))
				end,
				__newindex = function(p, p2, p3)
					if p2 == "displayName" then
						v2 = p3
					else
						rawset(p, p2, p3)
					end
				end
			})
		end

		return v
	end
}
