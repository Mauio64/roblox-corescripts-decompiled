local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)

local function createToggledTranslationsStore()
	local signal, v = Signals.createSignal({})

	return {
		getToggledCommentIds = signal,
		toggle = function(p: string)
			v(function(p2)
				local clone = table.clone(p2)

				if clone[p] then
					clone[p] = nil
					return clone
				end

				clone[p] = true

				return clone
			end)
		end
	}
end

return createToggledTranslationsStore
