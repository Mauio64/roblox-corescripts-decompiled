local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")

local object = setmetatable({}, { __mode = "v" })

local function ensureFieldSignal(p2, p3)
	local v5 = p2[p3]

	if v5 then
		return v5
	end

	local signal, v6 = Signals.createSignal(nil)
	local v7 = { get = signal, set = v6 }

	p2[p3] = v7
	return v7
end

local function getSduiClientPageScope(p2)
	local v5 = object[p2]

	if v5 then
		return v5
	end

	local v6 = {}

	local v7 = {
		get = function(p3)
			local v8 = v6
			local v9 = v8[p3]

			if not v9 then
				local signal, v10 = Signals.createSignal(nil)
				v9 = { get = signal, set = v10 }

				v8[p3] = v9
			end

			return v9.get(false)
		end,
		set = function(p3, p4)
			local v8 = v6
			local v9 = v8[p3]

			if not v9 then
				local signal, v10 = Signals.createSignal(nil)
				v9 = { get = signal, set = v10 }

				v8[p3] = v9
			end

			v9.set(p4)
		end,
		getSignal = function(p3)
			local v8 = v6
			local v9 = v8[p3]

			if not v9 then
				local signal, v10 = Signals.createSignal(nil)
				v9 = { get = signal, set = v10 }

				v8[p3] = v9
			end

			return v9.get
		end
	}

	object[p2] = v7
	return v7
end

return getSduiClientPageScope
