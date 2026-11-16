local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local Signals = require(parent.Signals)

local createSignal = Signals.createSignal

local function createExpressionCooldownStore()
	local signal, v = createSignal({})

	local function getCooldownEndsAt(p: string) -- 1 equivalent call inferred from this helper
		return signal(false)[p]
	end

	local function setDeadline(p: string, p2: number?) -- 1 equivalent call inferred from this helper
		local clone = table.clone(signal(false))

		if p2 == nil then
			clone[p] = nil
		else
			clone[p] = p2
		end

		v(clone)
	end

	return {
		getCooldownEndsAtByKey = signal,
		getCooldownEndsAt = getCooldownEndsAt,
		startCooldown = function(p: string, p2: number)
			setDeadline(p, p2) -- inferred equivalent call
			task.delay(math.max(0, p2 - os.clock()), function()
				if getCooldownEndsAt(p) == p2 then -- inferred equivalent call
					local clone = table.clone(signal(false))

					clone[p] = nil

					v(clone)
				end
			end)
		end,
		clearCooldown = function(p: string)
			local clone = table.clone(signal(false))

			clone[p] = nil

			v(clone)
		end,
		_resetForTesting = function()
			v({})
		end
	}
end

return createExpressionCooldownStore
