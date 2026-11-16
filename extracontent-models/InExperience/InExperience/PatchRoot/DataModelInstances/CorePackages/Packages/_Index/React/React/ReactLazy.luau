local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

local Shared = require(parent.Shared)
local console = Shared.console
local LuauPolyfill = require(parent.LuauPolyfill)
local inspect = LuauPolyfill.util.inspect

require(parent.Shared)

local Shared2 = require(parent.Shared)
local REACT_LAZY_TYPE = Shared2.ReactSymbols.REACT_LAZY_TYPE

function lazyInitializer(state)
	if state._status == -1 then
		local result = state._result()

		state._status = 0
		state._result = result
		result:andThen(function(p)
			if state._status == 0 then
				local default = p.default

				if ReactGlobals.__DEV__ and default == nil then
					console.error(
						"lazy: Expected the result of a dynamic import() call. Instead received: `%s`\n\nYour code should look like: \n  local MyComponent = lazy(function() return reqquire(script.Parent.MyComponent) end)",
						inspect(p)
					)
				end

				local v = state
				v._status = 1
				v._result = default
			end
		end, function(p)
			if state._status == 0 then
				local v = state
				v._status = 2
				v._result = p
			end
		end)
	end

	if state._status == 1 then
		return state._result
	end

	error(state._result)
end

return {
	lazy = function(callback)
		local v = {
			["$$typeof"] = REACT_LAZY_TYPE,
			_payload = { _status = -1, _result = callback },
			_init = lazyInitializer
		}

		if ReactGlobals.__DEV__ then
			local v2 = nil
			local v3 = nil

			setmetatable(v, {
				__index = function(_, p)
					if p == "defaultProps" then
						return v2
					elseif p == "propTypes" then
						return v3
					end
				end,
				__newindex = function(p, p2, p3)
					if p2 == "defaultProps" then
						console.error("React.lazy(...): It is not supported to assign `defaultProps` to a lazy component import. Either specify them where the component is defined, or create a wrapping component around it.")

						v2 = p3

						setmetatable(p, {
							__index = function() end,
							__newindex = function() end
						})
					end

					if p2 == "propTypes" then
						console.error("React.lazy(...): It is not supported to assign `propTypes` to a lazy component import. Either specify them where the component is defined, or create a wrapping component around it.")

						v3 = p3

						setmetatable(p, {
							__index = function() end,
							__newindex = function() end
						})
					end
				end
			})
		end

		return v
	end
}
