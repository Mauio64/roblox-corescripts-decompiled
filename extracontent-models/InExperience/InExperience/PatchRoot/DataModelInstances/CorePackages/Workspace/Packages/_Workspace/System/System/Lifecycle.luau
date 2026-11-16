local parent = script:FindFirstAncestor("System").Parent
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal
local createEffect = Signals.createEffect

local Lifecycle = {}
Lifecycle.__index = Lifecycle

function Lifecycle.new(p)
	local object = setmetatable({}, Lifecycle)
	local v, v2

	if p then
		v = p.defaultVisible
		v2 = p.defaultEnabled
	else
		v = false
		v2 = false
	end

	local signal, setVisible = createSignal(v)
	local signal2, setEnabled = createSignal(v2)

	object.getVisible = signal
	object.setVisible = setVisible
	object.getEnabled = signal2
	object.setEnabled = setEnabled

	local v3 = {}
	local callbacks = {}

	local effect = createEffect(function(p2)
		local v4 = signal(p2)

		if object.getEnabled(false) then
			for _, v5 in v3 do
				local v6 = v5(v4)

				if type(v6) == "boolean" and v6 ~= v4 then
					setVisible(v6)
					return
				end
			end
		end
	end)

	local effect2 = createEffect(function(p2)
		local v4 = signal2(p2)

		for _, v5 in callbacks do
			v5(v4)
		end
	end)

	function object.dispose(_)
		effect()
		effect2()
	end

	function object.onVisibilityChanged(_, callback)
		table.insert(v3, callback)

		return function()
			local index = table.find(v3, callback)

			if index then
				table.remove(v3, index)
			end
		end
	end

	function object.onEnabledChanged(_, callback)
		table.insert(callbacks, callback)
		callback(signal2(false))
		return function()
			local index = table.find(callbacks, callback)

			if index then
				table.remove(callbacks, index)
			end
		end
	end

	return object
end

return Lifecycle
