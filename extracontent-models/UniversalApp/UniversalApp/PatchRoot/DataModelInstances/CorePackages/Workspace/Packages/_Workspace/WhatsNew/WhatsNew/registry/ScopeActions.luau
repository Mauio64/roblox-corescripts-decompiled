local WhatsNew = script:FindFirstAncestor("WhatsNew")

require(WhatsNew.Types)

local function assertValidKey(s1: string) -- line: 25
	assert(s1 ~= "", "scope action key must be a non-empty string")
end

return {
	createScopeActions = function(p1) -- line: 29
		local t1 = {
			_actions = {}
		}

		if p1 ~= nil then
			for v6, v7 in p1 do
				assert(v6 ~= "", "scope action key must be a non-empty string")
				t1._actions[v6] = v7
			end
		end

		return {
			register = function(_: {[any]: any}, s2: string, p2) -- line: 43
				-- upvalues: t1 (copy)
				assert(s2 ~= "", "scope action key must be a non-empty string")
				assert(t1._actions[s2] == nil, `scope action already registered: { s2 }`)
				t1._actions[s2] = p2
			end,
			has = function(_: {[any]: any}, s3: string) -- line: 49
				-- upvalues: t1 (copy)
				return t1._actions[s3] ~= nil
			end,
			invoke = function(_: {[any]: any}, s4: string) -- line: 53
				-- upvalues: t1 (copy)
				local v23 = t1._actions[s4]

				assert(v23 ~= nil, `unknown scope action key: { s4 }`)
				v23()
			end,
			getRegisteredKeys = function(_: {[any]: any}) -- line: 59
				-- upvalues: t1 (copy)
				local t6 = {}

				for v26 in t1._actions do
					table.insert(t6, v26)
				end

				table.sort(t6)

				return t6
			end,
			toMap = function(_: {[any]: any}) -- line: 68
				-- upvalues: t1 (copy)
				return (table.clone(t1._actions))
			end
		}
	end,
	collectRegistryActionKeys = function(p3) -- line: 76
		local t8 = {}
		local t9 = {}

		local function addKey(s5: string?) -- line: 80
			-- upvalues: t8 (copy), t9 (copy)
			if s5 == nil or (s5 == "" or t8[s5]) then
				return
			end

			t8[s5] = true
			table.insert(t9, s5)
		end

		for _, v13 in p3.scopeTours do
			local openActionKey = v13.openActionKey

			if openActionKey ~= nil and openActionKey ~= "" and not t8[openActionKey] then
				t8[openActionKey] = true
				table.insert(t9, openActionKey)
			end

			local closeActionKey = v13.closeActionKey

			if closeActionKey ~= nil and closeActionKey ~= "" and not t8[closeActionKey] then
				t8[closeActionKey] = true
				table.insert(t9, closeActionKey)
			end
		end

		table.sort(t9)

		return t9
	end
}
