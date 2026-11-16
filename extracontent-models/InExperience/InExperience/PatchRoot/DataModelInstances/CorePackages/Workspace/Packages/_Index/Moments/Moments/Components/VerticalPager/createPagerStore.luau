local parent = script:FindFirstAncestor("Moments").Parent

local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)
local SignalsExperimental = require(parent.SignalsExperimental)

local snapMath = require(script.Parent.snapMath)

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createPagerStore()
	local signal, v = createSignal({})
	local signal2, v2 = createSignal(1)

	local function goToItem(p: number) -- 2 equivalent calls inferred from this helper
		v2(snapMath.clampIndex(p, #signal(false)))
	end

	return {
		getItems = signal,
		getCount = createComputed(function(p)
			return #signal(p)
		end),
		getCurrentIndex = signal2,
		getCurrentItem = createComputed(function(p)
			return signal(p)[signal2(p)]
		end),
		addItems = function(list)
			if #list == 0 then
				return
			end

			v((Cryo.List.join(signal(false), list)))
		end,
		addItemAt = function(value: number, p)
			local v3 = signal(false)
			local count = #v3
			local v4 = math.clamp(value, 1, count + 1)

			local clone = table.clone(v3)
			table.insert(clone, v4, p)

			SignalsExperimental.batch(function()
				v(clone)

				if count > 0 then
					local v5 = signal2(false)

					if v4 <= v5 then
						v2(snapMath.clampIndex(v5 + 1, #clone))
					end
				end
			end)
		end,
		removeItem = function(p: number)
			local v3 = signal(false)

			if p < 1 or #v3 < p then
				return
			end

			local clone = table.clone(v3)
			table.remove(clone, p)

			SignalsExperimental.batch(function()
				v(clone)
				v2(snapMath.reindexAfterRemoval(signal2(false), p, #clone))
			end)
		end,
		setItems = function(list)
			SignalsExperimental.batch(function()
				v(table.clone(list))
				v2(snapMath.clampIndex(signal2(false), #list))
			end)
		end,
		reset = function()
			SignalsExperimental.batch(function()
				v({})
				v2(1)
			end)
		end,
		nextItem = function()
			goToItem(signal2(false) + 1) -- inferred equivalent call
		end,
		previousItem = function()
			goToItem(signal2(false) - 1) -- inferred equivalent call
		end,
		goToItem = goToItem,
		dispose = function() end
	}
end

return createPagerStore
