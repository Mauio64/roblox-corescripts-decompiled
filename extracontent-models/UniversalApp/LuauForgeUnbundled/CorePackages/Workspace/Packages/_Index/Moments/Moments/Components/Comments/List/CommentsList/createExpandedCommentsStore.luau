local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local function createExpandedCommentsStore()
	local signal, v5 = Signals.createSignal({})

	return {
		getExpandedCommentIds = signal,
		toggle = function(p2)
			v5(function(p3)
				local clone = table.clone(p3)

				if clone[p2] then
					clone[p2] = nil
					return clone
				end

				clone[p2] = true

				return clone
			end)
		end
	}
end

return createExpandedCommentsStore
