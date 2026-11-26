local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsExperimental")

local snapMath = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/snapMath")

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createPagerStore()
	local signal, v5 = createSignal({})
	local signal2, v6 = createSignal(1)

	return {
		getItems = signal,
		getCount = createComputed(function(p2)
			return #signal(p2)
		end),
		getCurrentIndex = signal2,
		getCurrentItem = createComputed(function(p2)
			return signal(p2)[signal2(p2)]
		end),
		addItems = function(list)
			if #list == 0 then
				return
			end

			v5(Cryo.List.join(signal(false), list))
		end,
		addItemAt = function(value, p2)
			local v7 = signal(false)
			local count = #v7
			local v8 = math.clamp(value, 1, count + 1)

			local clone = table.clone(v7)
			table.insert(clone, v8, p2)

			SignalsExperimental.batch(function()
				v5(clone)

				if count > 0 then
					local v9 = signal2(false)

					if v8 <= v9 then
						v6(snapMath.clampIndex(v9 + 1, #clone))
					end
				end
			end)
		end,
		removeItem = function(p2)
			local v7 = signal(false)

			if p2 < 1 or #v7 < p2 then
				return
			end

			local clone = table.clone(v7)
			table.remove(clone, p2)

			SignalsExperimental.batch(function()
				v5(clone)
				v6(snapMath.reindexAfterRemoval(signal2(false), p2, #clone))
			end)
		end,
		setItems = function(list)
			SignalsExperimental.batch(function()
				v5(table.clone(list))
				v6(snapMath.clampIndex(signal2(false), #list))
			end)
		end,
		reset = function()
			SignalsExperimental.batch(function()
				v5({})
				v6(1)
			end)
		end,
		nextItem = function()
			local v7 = signal2(false) + 1
			v6(snapMath.clampIndex(v7, #signal(false)))
		end,
		previousItem = function()
			local v7 = signal2(false) - 1
			v6(snapMath.clampIndex(v7, #signal(false)))
		end,
		goToItem = function(p2)
			v6(snapMath.clampIndex(p2, #signal(false)))
		end,
		dispose = function() end
	}
end

return createPagerStore
