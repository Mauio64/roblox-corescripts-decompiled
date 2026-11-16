local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

local Shared = require(parent.Shared)
local console = Shared.console

local Shared2 = require(parent.Shared)
local ReactSymbols = Shared2.ReactSymbols
local REACT_PROVIDER_TYPE = ReactSymbols.REACT_PROVIDER_TYPE
local REACT_CONTEXT_TYPE = ReactSymbols.REACT_CONTEXT_TYPE

return {
	createContext = function(currentValue, calculateChangedBits)
		local v = {
			["$$typeof"] = REACT_CONTEXT_TYPE,
			_calculateChangedBits = calculateChangedBits,
			_currentValue = currentValue,
			_currentValue2 = currentValue,
			_threadCount = 0,
			Provider = nil,
			Consumer = nil,
			displayName = nil,
			_currentRenderer = nil,
			_currentRenderer2 = nil
		}

		v.Provider = { ["$$typeof"] = REACT_PROVIDER_TYPE, _context = v }

		local v2 = false

		if ReactGlobals.__DEV__ then
			local consumer = {
				["$$typeof"] = REACT_CONTEXT_TYPE,
				_context = v,
				_calculateChangedBits = v._calculateChangedBits
			}

			setmetatable(consumer, {
				__index = function(_, p)
					if p == "_currentValue" then
						return v._currentValue
					elseif p == "_currentValue2" then
						return v._currentValue2
					elseif p == "_threadCount" then
						return v._threadCount
					elseif p == "displayName" then
						return v.displayName
					end

					return nil
				end,
				__newindex = function(_, p, p2)
					if p == "_currentValue" then
						v._currentValue = p2
					elseif p == "_currentValue2" then
						v._currentValue2 = p2
					elseif p == "_threadCount" then
						v._threadCount = p2
					elseif p == "displayName" and not v2 then
						console.warn("Setting `displayName` on Context.Consumer has no effect. " .. "You should set it directly on the context with Context.displayName = " .. p2 .. ".")

						v2 = true
					end
				end
			})

			v.Consumer = consumer
		else
			v.Consumer = v
		end

		if ReactGlobals.__DEV__ then
			v._currentRenderer = nil
			v._currentRenderer2 = nil
		end

		return v
	end
}
