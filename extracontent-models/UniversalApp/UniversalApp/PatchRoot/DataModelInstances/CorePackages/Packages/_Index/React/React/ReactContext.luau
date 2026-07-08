local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local console = require(ParentParent.Shared).console
local ReactSymbols = require(ParentParent.Shared).ReactSymbols
local REACT_PROVIDER_TYPE = ReactSymbols.REACT_PROVIDER_TYPE
local REACT_CONTEXT_TYPE = ReactSymbols.REACT_CONTEXT_TYPE

return {
	createContext = function(p1, p2: ((...any) -> ...any)?) -- line: 34
		-- upvalues: REACT_CONTEXT_TYPE (copy), REACT_PROVIDER_TYPE (copy), ReactGlobals (copy), console (copy)
		local t1 = {
			["$$typeof"] = REACT_CONTEXT_TYPE,
			_calculateChangedBits = p2,
			_currentValue = p1,
			_currentValue2 = p1,
			_threadCount = 0,
			Provider = nil,
			Consumer = nil,
			displayName = nil,
			_currentRenderer = nil,
			_currentRenderer2 = nil
		}

		t1.Provider = {
			["$$typeof"] = REACT_PROVIDER_TYPE,
			_context = t1
		}

		local u10 = false

		if ReactGlobals.__DEV__ then
			local t2 = {
				["$$typeof"] = REACT_CONTEXT_TYPE,
				_context = t1,
				_calculateChangedBits = t1._calculateChangedBits
			}

			setmetatable(t2, {
				__index = function(_, p4) -- line: 79
					-- upvalues: t1 (copy)
					if p4 == "_currentValue" then
						return t1._currentValue
					end

					if p4 == "_currentValue2" then
						return t1._currentValue2
					end

					if p4 == "_threadCount" then
						return t1._threadCount
					end

					if p4 == "displayName" then
						return t1.displayName
					end

					return nil
				end,
				__newindex = function(_, p6, p7) -- line: 92
					-- upvalues: t1 (copy), u10 (ref), console (copy)
					if p6 == "_currentValue" then
						t1._currentValue = p7

						return
					end

					if p6 == "_currentValue2" then
						t1._currentValue2 = p7

						return
					end

					if p6 == "_threadCount" then
						t1._threadCount = p7

						return
					end

					if p6 == "displayName" and not u10 then
						console.warn("Setting `displayName` on Context.Consumer has no effect. " .. "You should set it directly on the context with Context.displayName = " .. p7 .. ".")
						u10 = true
					end
				end
			})
			t1.Consumer = t2
		else
			t1.Consumer = t1
		end

		if ReactGlobals.__DEV__ then
			t1._currentRenderer = nil
			t1._currentRenderer2 = nil
		end

		return t1
	end
}
