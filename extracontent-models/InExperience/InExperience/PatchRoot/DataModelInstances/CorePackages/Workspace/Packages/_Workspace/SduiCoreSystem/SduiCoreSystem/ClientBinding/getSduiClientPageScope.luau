local parent = script:FindFirstAncestor("SduiCoreSystem").Parent

local Signals = require(parent.Signals)

local object = setmetatable({}, { __mode = "v" })

local function ensureFieldSignal(p, p2: string)
	local v = p[p2]

	if v then
		return v
	end

	local signal, set = Signals.createSignal(nil)
	local v2 = { get = signal, set = set }

	p[p2] = v2
	return v2
end

local function getSduiClientPageScope(p: string)
	local v = object[p]

	if v then
		return v
	end

	local v2 = {}

	local v3 = {
		get = function(p2: string)
			local v3 = v2
			local v4 = v3[p2]

			if not v4 then
				local signal, set = Signals.createSignal(nil)
				v4 = { get = signal, set = set }

				v3[p2] = v4
			end

			return v4.get(false)
		end,
		set = function(p2: string, p3)
			local v3 = v2
			local v4 = v3[p2]

			if not v4 then
				local signal, set = Signals.createSignal(nil)
				v4 = { get = signal, set = set }

				v3[p2] = v4
			end

			v4.set(p3)
		end,
		getSignal = function(p2: string)
			local v3 = v2
			local v4 = v3[p2]

			if not v4 then
				local signal, set = Signals.createSignal(nil)
				v4 = { get = signal, set = set }

				v3[p2] = v4
			end

			return v4.get
		end
	}

	object[p] = v3
	return v3
end

return getSduiClientPageScope
