local parent = script:FindFirstAncestor("SplitPane").Parent

local Signals = require(parent.Signals)

local entries = {}

local function getOrCreateEntry(p: string) -- 2 equivalent calls inferred from this helper
	local entry = entries[p]

	if entry == nil then
		local signal, set = Signals.createSignal(nil)
		entry = { get = signal, set = set }
		entries[p] = entry
	end

	return entry
end

local OnScreenStore = {}

function OnScreenStore.setRouteOnScreen(p: string, p2)
	getOrCreateEntry(p).set(p2) -- inferred equivalent call
end

function OnScreenStore.getRouteOnScreen(p, p2: string)
	return getOrCreateEntry(p2).get(p) -- inferred equivalent call
end

function OnScreenStore._resetForTest()
	table.clear(entries)
end

return OnScreenStore
