local WhatsNew = script:FindFirstAncestor("WhatsNew")
local parent = WhatsNew.Parent

local Signals = require(parent.Signals)
require(WhatsNew.Types)

local function assertValidKey(p: string) -- 4 equivalent calls inferred from this helper
	assert(p ~= "", "scope action key must be a non-empty string")
end

local ScopeActions = {}

function ScopeActions.createScopeActions(items)
	local v = { _actions = {}, _openStateBindings = {}, _openStateDisposers = {} }

	if items ~= nil then
		for k, item in items do
			assertValidKey(k) -- inferred equivalent call
			v._actions[k] = item
		end
	end

	local scopeActions = {}

	function scopeActions.register(_, p: string, p2)
		assertValidKey(p) -- inferred equivalent call
		assert(v._actions[p] == nil, `scope action already registered: {p}`)
		v._actions[p] = p2
	end

	function scopeActions.has(_, p: string): boolean
		return v._actions[p] ~= nil
	end

	function scopeActions.invoke(_, p: string)
		local action = v._actions[p]
		assert(action ~= nil, `unknown scope action key: {p}`)
		action()
	end

	function scopeActions.getRegisteredKeys(_)
		local registeredKeys = {}

		for k in v._actions do
			table.insert(registeredKeys, k)
		end

		table.sort(registeredKeys)
		return registeredKeys
	end

	function scopeActions.toMap(_)
		return (table.clone(v._actions))
	end

	function scopeActions.bindOpenState(_, data)
		assertValidKey(data.openActionKey) -- inferred equivalent call
		assertValidKey(data.closeActionKey) -- inferred equivalent call
		assert(data.getIsOpen ~= nil, "bindOpenState requires getIsOpen")
		assert(
			v._actions[data.openActionKey] ~= nil,
			`bindOpenState openActionKey not registered: {data.openActionKey}`
		)

		assert(
			v._actions[data.closeActionKey] ~= nil,
			`bindOpenState closeActionKey not registered: {data.closeActionKey}`
		)

		for _, openStateBinding in v._openStateBindings do
			assert(
				openStateBinding.openActionKey ~= data.openActionKey,
				`open state already bound for openActionKey: {data.openActionKey}`
			)

			assert(
				openStateBinding.closeActionKey ~= data.closeActionKey,
				`open state already bound for closeActionKey: {data.closeActionKey}`
			)
		end

		table.insert(v._openStateBindings, data)
	end

	function scopeActions:stopOpenStateWiring()
		for _, openStateDisposer in v._openStateDisposers do
			openStateDisposer()
		end

		table.clear(v._openStateDisposers)
	end

	function scopeActions.startOpenStateWiring(_, data)
		scopeActions:stopOpenStateWiring()

		for _, openStateBinding in v._openStateBindings do
			local effect = Signals.createEffect(function(p)
				local isOpen = openStateBinding.getIsOpen(p)

				data.getRuntimeStateSignal(p)

				if isOpen then
					data.notifyScopeOpened(openStateBinding.openActionKey)
				else
					data.notifyScopeClosed(openStateBinding.closeActionKey)
				end
			end)
			table.insert(v._openStateDisposers, effect)
		end
	end

	return scopeActions
end

function ScopeActions.collectRegistryActionKeys(p)
	local set = {}
	local registryActionKeys = {}

	local function addKey(openActionKey: string?) -- 1 equivalent call inferred from this helper
		if openActionKey == nil or openActionKey == "" or set[openActionKey] then
			return
		end

		set[openActionKey] = true
		table.insert(registryActionKeys, openActionKey)
	end

	for _, scopeTour in p.scopeTours do
		addKey(scopeTour.openActionKey) -- inferred equivalent call
		local closeActionKey = scopeTour.closeActionKey

		if closeActionKey == nil or closeActionKey == "" or set[closeActionKey] then
			continue
		end

		set[closeActionKey] = true
		table.insert(registryActionKeys, closeActionKey)
	end

	table.sort(registryActionKeys)
	return registryActionKeys
end

return ScopeActions
