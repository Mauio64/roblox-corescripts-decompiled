local ParentParent = script.Parent.Parent
local SignalsScheduler = require(ParentParent.SignalsScheduler)
local flush = SignalsScheduler.flush
local schedule = SignalsScheduler.schedule
local callUserSpace = require(script.Parent.callUserSpace)
local v6 = table.freeze({
	__mode = "k"
})

local function createWeakSet(t1: {[any]: any}) -- line: 29
	-- upvalues: v6 (copy)
	return (setmetatable(t1, v6))
end
local function defaultEquals(p1, p2) -- line: 33
	return p1 == p2
end
local function handleError(b1: boolean, ...) -- line: 37
	if not b1 then
		error((...))
	end
end
local function handleScopeValidation(p3: ((...any) -> ...any), b2: boolean, ...) -- line: 44
	-- upvalues: handleError (copy)
	p3()
	handleError(b2, ...)

	return ...
end
local function callUserSpaceWithScopeValidation(p4: ((...any) -> ...any), p5: ((...any) -> ...any)) -- line: 50
	-- upvalues: handleScopeValidation (copy), callUserSpace (copy)
	local u21 = true

	local function wrappedScope(p6: ((...any) -> ...any)) -- line: 53
		-- upvalues: u21 (ref), p5 (copy)
		if not u21 then
			error("attempted to use scope beyond scope's lifetime")
		end

		return p5(p6)
	end
	local function kill() -- line: 60
		-- upvalues: u21 (ref)
		u21 = false
	end

	return handleScopeValidation(kill, pcall(callUserSpace, p4, wrappedScope))
end

local v12 = if not (_G.__SIGNALS_VALIDATION_ENABLED__ or _G.__DEV__) then callUserSpace else callUserSpaceWithScopeValidation

return {
	createSignal = function(p7, p8: ((...any) -> ...any)?) -- line: 70
		-- upvalues: defaultEquals (copy), callUserSpace (copy), v6 (copy), flush (copy)
		local u26 = false
		local n1 = 0
		local u28 = nil
		local self = nil
		local v30 = if p8 == nil then defaultEquals else p8

		local function ensureInitialized() -- line: 79
			-- upvalues: u26 (ref), u28 (ref), p7 (copy), callUserSpace (copy), n1 (ref), self (ref), v6 (copy)
			if not u26 then
				u26 = true
				u28 = if typeof(p7) ~= "function" then p7 else callUserSpace(p7)
				n1 = os.clock()
				self = setmetatable({}, v6)
			end
		end
		local function source(p9: ((...any) -> ...any)?, b3: boolean?) -- line: 88
			-- upvalues: self (ref), n1 (ref)
			if p9 ~= nil then
				if b3 then
					self[p9] = nil
				else
					self[p9] = true
				end

				return 0
			end

			return n1
		end
		local function connectToScope(p10) -- line: 101
			-- upvalues: source (copy), self (ref)
			if p10 then
				self[p10(source)] = true
			end
		end
		local function notifyObservers() -- line: 108
			-- upvalues: self (ref)
			for v70 in self do
				v70()
			end

			table.clear(self)
		end
		local function getter(p11) -- line: 115
			-- upvalues: ensureInitialized (copy), source (copy), self (ref), u28 (ref)
			ensureInitialized()

			if p11 then
				self[p11(source)] = true
			end

			return u28
		end
		local function setter(p12) -- line: 121
			-- upvalues: ensureInitialized (copy), callUserSpace (copy), u28 (ref), v30 (copy), n1 (ref), self (ref), flush (copy)
			ensureInitialized()

			local v73 = if typeof(p12) ~= "function" then p12 else callUserSpace(p12, u28)

			if not callUserSpace(v30, u28, v73) then
				u28 = v73
				n1 = os.clock()

				for v74 in self do
					v74()
				end

				table.clear(self)
				flush()
			end
		end

		return getter, setter
	end,
	createComputed = function(p13: ((...any) -> ...any), p14: ((...any) -> ...any)?) -- line: 135
		-- upvalues: defaultEquals (copy), v6 (copy), v12 (copy), callUserSpace (copy)
		local u39 = false
		local u40 = false
		local n2 = 0
		local n3 = 0
		local u43 = nil
		local t2 = nil
		local self = nil
		local v46 = if p14 == nil then defaultEquals else p14

		local function notifyObservers() -- line: 147
			-- upvalues: self (ref)
			for v75 in self do
				v75()
			end

			table.clear(self)
		end
		local function observer() -- line: 154
			-- upvalues: u40 (ref), self (ref)
			if not u40 then
				u40 = true

				for v76 in self do
					v76()
				end

				table.clear(self)
			end
		end
		local function scope(p15: ((...any) -> ...any)) -- line: 161
			-- upvalues: t2 (ref), observer (copy)
			t2[p15] = true

			return observer
		end
		local function ensureInitialized() -- line: 166
			-- upvalues: u39 (ref), self (ref), v6 (copy), t2 (ref), u43 (ref), v12 (copy), p13 (copy), scope (copy), n3 (ref), n2 (ref)
			if not u39 then
				u39 = true
				self = setmetatable({}, v6)
				t2 = {}
				u43 = v12(p13, scope)
				n3 = os.clock()
				n2 = n3
			end
		end
		local function disconnectSources() -- line: 177
			-- upvalues: t2 (ref), observer (copy)
			for v78 in t2 do
				v78(observer, true)
			end

			table.clear(t2)
		end
		local function flushNotifications() -- line: 184
			-- upvalues: u40 (ref), t2 (ref), n3 (ref), observer (copy), v12 (copy), p13 (copy), scope (copy), callUserSpace (copy), v46 (copy), u43 (ref), n2 (ref)
			if u40 then
				u40 = false

				for v79 in t2 do
					if v79() > n3 then
						for v80 in t2 do
							v80(observer, true)
						end

						table.clear(t2)

						local v81 = v12(p13, scope)

						n3 = os.clock()

						if not callUserSpace(v46, u43, v81) then
							u43 = v81
							n2 = n3
						end

						return
					end
				end

				for v82 in t2 do
					v82(observer)
				end
			end
		end
		local function source(p16: ((...any) -> ...any)?, b4: boolean?) -- line: 206
			-- upvalues: self (ref), flushNotifications (copy), n2 (ref)
			if p16 ~= nil then
				if b4 then
					self[p16] = nil
				else
					self[p16] = true
				end

				return 0
			end

			flushNotifications()

			return n2
		end
		local function connectToScope(p17) -- line: 220
			-- upvalues: source (copy), self (ref)
			if p17 then
				self[p17(source)] = true
			end
		end
		local function getter(p18) -- line: 227
			-- upvalues: ensureInitialized (copy), flushNotifications (copy), source (copy), self (ref), u43 (ref)
			ensureInitialized()
			flushNotifications()

			if p18 then
				self[p18(source)] = true
			end

			return u43
		end

		return getter
	end,
	createEffect = function(p19: ((...any) -> ...any)) -- line: 237
		-- upvalues: v12 (copy), schedule (copy)
		local u57 = false
		local u58 = false
		local n4 = 0
		local t3 = {}
		local observer = nil

		local function disconnectSources() -- line: 246
			-- upvalues: t3 (copy), observer (ref)
			for v87 in t3 do
				v87(observer, true)
			end

			table.clear(t3)
		end
		local function dispose() -- line: 253
			-- upvalues: u58 (ref), t3 (copy), observer (ref)
			u58 = true

			for v88 in t3 do
				v88(observer, true)
			end

			table.clear(t3)
		end
		local function scope(p20: ((...any) -> ...any)) -- line: 258
			-- upvalues: t3 (copy), observer (ref)
			t3[p20] = true

			return observer
		end
		local function processNotification() -- line: 263
			-- upvalues: u58 (ref), u57 (ref), t3 (copy), n4 (ref), observer (ref), v12 (copy), p19 (copy), scope (copy)
			if not u58 then
				u57 = false

				for v90 in t3 do
					if v90() > n4 then
						for v91 in t3 do
							v91(observer, true)
						end

						table.clear(t3)
						v12(p19, scope)
						n4 = os.clock()

						return
					end
				end

				for v92 in t3 do
					v92(observer)
				end
			end
		end

		function observer() -- line: 281
			-- upvalues: u58 (ref), u57 (ref), schedule (copy), processNotification (copy)
			if not u58 and not u57 then
				u57 = true
				schedule(processNotification)
			end
		end

		v12(p19, scope)
		n4 = os.clock()

		return dispose
	end
}
