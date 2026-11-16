local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(parent.MomentsTypes)
local Signals = require(parent.Signals)

require(Moments.Components.Feed.Items.Moment.createMomentStore)

local createSignal = Signals.createSignal

local function createPostInsightsPageStore()
	local signal, v = createSignal(false)

	local signal2, v2 = createSignal(nil)

	return {
		getIsOpen = signal,
		getContext = signal2,
		open = function(p)
			v2(p)
			v(true)
		end,
		close = function()
			v(false)
		end,
		reset = function()
			v(false)
			v2(nil)
		end
	}
end

return createPostInsightsPageStore
