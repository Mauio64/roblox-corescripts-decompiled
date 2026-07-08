local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local console = require(ParentParent.Shared).console
local inspect = require(ParentParent.LuauPolyfill).util.inspect

require(ParentParent.Shared)

local REACT_LAZY_TYPE = require(ParentParent.Shared).ReactSymbols.REACT_LAZY_TYPE

function lazyInitializer(p1) -- line: 73
	-- upvalues: ReactGlobals (copy), console (copy), inspect (copy)
	if p1._status == -1 then
		local v7 = p1._result()

		p1._status = 0
		p1._result = v7
		v7:andThen(function(p2) -- line: 81
			-- upvalues: p1 (copy), ReactGlobals (copy), console (copy), inspect (copy)
			if p1._status == 0 then
				local default = p2.default

				if ReactGlobals.__DEV__ and default == nil then
					console.error("lazy: Expected the result of a dynamic import() call. Instead received: `%s`\n\nYour code should look like: \n  local MyComponent = lazy(function() return reqquire(script.Parent.MyComponent) end)", inspect(p2))
				end

				local v15 = p1

				v15._status = 1
				v15._result = default
			end
		end, function(p3) -- line: 102
			-- upvalues: p1 (copy)
			if p1._status == 0 then
				local v17 = p1

				v17._status = 2
				v17._result = p3
			end
		end)
	end

	if p1._status == 1 then
		return p1._result
	end

	error(p1._result)
end

return {
	lazy = function(p4: ((...any) -> ...any)) -- line: 128
		-- upvalues: REACT_LAZY_TYPE (copy), ReactGlobals (copy), console (copy)
		local t1 = {
			_status = -1,
			_result = p4
		}
		local t2 = {
			["$$typeof"] = REACT_LAZY_TYPE,
			_payload = t1,
			_init = lazyInitializer
		}

		if ReactGlobals.__DEV__ then
			local u11 = nil
			local u12 = nil

			setmetatable(t2, {
				__index = function(_, p6) -- line: 150
					-- upvalues: u11 (ref), u12 (ref)
					if p6 == "defaultProps" then
						return u11
					end

					if p6 == "propTypes" then
						return u12
					end
				end,
				__newindex = function(p7, p8, p9) -- line: 159
					-- upvalues: console (copy), u11 (ref), u12 (ref)
					if p8 == "defaultProps" then
						console.error("React.lazy(...): It is not supported to assign `defaultProps` to a lazy component import. Either specify them where the component is defined, or create a wrapping component around it.")
						u11 = p9
						setmetatable(p7, {
							__index = function() -- line: 170
							end,
							__newindex = function() -- line: 171
							end
						})
					end

					if p8 == "propTypes" then
						console.error("React.lazy(...): It is not supported to assign `propTypes` to a lazy component import. Either specify them where the component is defined, or create a wrapping component around it.")
						u12 = p9
						setmetatable(p7, {
							__index = function() -- line: 184
							end,
							__newindex = function() -- line: 185
							end
						})
					end
				end
			})
		end

		return t2
	end
}
