local WhatsNew = script:FindFirstAncestor("WhatsNew")
local WhatsNewParent = WhatsNew.Parent
local Signals = require(WhatsNewParent.Signals)

require(WhatsNew.Types)

local function assertValidKey(s1: string) -- line: 39
	assert(s1 ~= "", "scope action key must be a non-empty string")
end

return {
	createScopeActions = function(p1) -- line: 43
		-- upvalues: Signals (copy)
		local t1 = {
			_actions = {},
			_openStateBindings = {},
			_openStateDisposers = {}
		}

		if p1 ~= nil then
			for v8, v9 in p1 do
				assert(v8 ~= "", "scope action key must be a non-empty string")
				t1._actions[v8] = v9
			end
		end

		local t10 = {
			register = function(_: {[any]: any}, s2: string, p2) -- line: 59
				-- upvalues: t1 (copy)
				assert(s2 ~= "", "scope action key must be a non-empty string")
				assert(t1._actions[s2] == nil, `scope action already registered: { s2 }`)
				t1._actions[s2] = p2
			end,
			has = function(_: {[any]: any}, s3: string) -- line: 65
				-- upvalues: t1 (copy)
				return t1._actions[s3] ~= nil
			end,
			invoke = function(_: {[any]: any}, s4: string) -- line: 69
				-- upvalues: t1 (copy)
				local v26 = t1._actions[s4]

				assert(v26 ~= nil, `unknown scope action key: { s4 }`)
				v26()
			end,
			getRegisteredKeys = function(_: {[any]: any}) -- line: 75
				-- upvalues: t1 (copy)
				local t6 = {}

				for v29 in t1._actions do
					table.insert(t6, v29)
				end

				table.sort(t6)

				return t6
			end,
			toMap = function(_: {[any]: any}) -- line: 84
				-- upvalues: t1 (copy)
				return (table.clone(t1._actions))
			end,
			bindOpenState = function(_: {[any]: any}, p3) -- line: 89
				-- upvalues: t1 (copy)
				assert(p3.openActionKey ~= "", "scope action key must be a non-empty string")
				assert(p3.closeActionKey ~= "", "scope action key must be a non-empty string")
				assert(p3.getIsOpen ~= nil, "bindOpenState requires getIsOpen")
				assert(t1._actions[p3.openActionKey] ~= nil, `bindOpenState openActionKey not registered: { p3.openActionKey }`)
				assert(t1._actions[p3.closeActionKey] ~= nil, `bindOpenState closeActionKey not registered: { p3.closeActionKey }`)

				for _, v34 in t1._openStateBindings do
					assert(v34.openActionKey ~= p3.openActionKey, `open state already bound for openActionKey: { p3.openActionKey }`)
					assert(v34.closeActionKey ~= p3.closeActionKey, `open state already bound for closeActionKey: { p3.closeActionKey }`)
				end

				table.insert(t1._openStateBindings, p3)
			end,
			stopOpenStateWiring = function(_: {[any]: any}) -- line: 116
				-- upvalues: t1 (copy)
				for _, v37 in t1._openStateDisposers do
					v37()
				end

				table.clear(t1._openStateDisposers)
			end
		}

		function t10.startOpenStateWiring(_: {[any]: any}, p4) -- line: 123
			-- upvalues: t10 (copy), t1 (copy), Signals (copy)
			t10:stopOpenStateWiring()

			for _, v41 in t1._openStateBindings do
				local v42 = Signals.createEffect(function(p5) -- line: 128
					-- upvalues: v41 (copy), p4 (copy)
					local v45 = v41.getIsOpen(p5)

					p4.getRuntimeStateSignal(p5)

					if v45 then
						p4.notifyScopeOpened(v41.openActionKey)

						return
					end

					p4.notifyScopeClosed(v41.closeActionKey)
				end)

				table.insert(t1._openStateDisposers, v42)
			end
		end

		return t10
	end,
	collectRegistryActionKeys = function(p6) -- line: 145
		local t12 = {}
		local t13 = {}

		local function addKey(s5: string?) -- line: 149
			-- upvalues: t12 (copy), t13 (copy)
			if s5 == nil or (s5 == "" or t12[s5]) then
				return
			end

			t12[s5] = true
			table.insert(t13, s5)
		end

		for _, v16 in p6.scopeTours do
			local openActionKey = v16.openActionKey

			if openActionKey ~= nil and openActionKey ~= "" and not t12[openActionKey] then
				t12[openActionKey] = true
				table.insert(t13, openActionKey)
			end

			local closeActionKey = v16.closeActionKey

			if closeActionKey ~= nil and closeActionKey ~= "" and not t12[closeActionKey] then
				t12[closeActionKey] = true
				table.insert(t13, closeActionKey)
			end
		end

		table.sort(t13)

		return t13
	end
}
