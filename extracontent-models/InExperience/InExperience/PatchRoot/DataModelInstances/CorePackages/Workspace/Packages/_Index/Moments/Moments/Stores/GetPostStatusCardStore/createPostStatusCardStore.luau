local parent = script:FindFirstAncestor("Moments").Parent

require(parent.MomentsTypes)
local Signals = require(parent.Signals)

local function createPostStatusCardStore()
	local signal, v = Signals.createSignal({})
	local v2 = {}
	local v3 = {}
	local set = {}
	local set2 = {}
	local idSet = {}
	local idSet2 = {}
	local set3 = {}

	local function add(p)
		if idSet[p.id] then
			return
		end

		idSet[p.id] = true

		if p.cardType == "Live" then
			idSet2[p.id] = true
		end

		v2[p.id] = nil
		v3[p.id] = nil
		local clone = table.clone(signal(false))
		table.insert(clone, 1, p)
		v(clone)
	end

	return {
		getCards = signal,
		add = add,
		markUploading = function(p: string)
			if not idSet[p] then
				v3[p] = true
			end
		end,
		isUploading = function(p: string): boolean
			return v3[p] == true
		end,
		awaitLiveCard = function(p: string)
			v3[p] = nil

			if not idSet[p] then
				v2[p] = true
			end
		end,
		isAwaitingLiveCard = function(p: string): boolean
			return v2[p] == true
		end,
		markToastHiddenFor = function(p: string)
			set[p] = true
		end,
		hadToastHidden = function(p: string): boolean
			return set[p] == true
		end,
		markToastProbablySpentFor = function(p: string)
			set2[p] = true
		end,
		hadToastProbablySpent = function(p: string): boolean
			return set2[p] == true
		end,
		stopAwaitingLiveCard = function(p: string, p2)
			v3[p] = nil

			if not v2[p] then
				return
			end

			v2[p] = nil

			if p2 ~= nil and set[p] then
				add(p2)
			end
		end,
		dismiss = function(p: string)
			local v4 = {}

			for _, v5 in signal(false) do
				if v5.id ~= p then
					table.insert(v4, v5)
				end
			end

			v(v4)
		end,
		hasHadLiveCard = function(p: string): boolean
			return idSet2[p] == true
		end,
		markShown = function(p: string): boolean
			if set3[p] then
				return false
			end

			set3[p] = true
			return true
		end,
		reset = function()
			v2 = {}
			v3 = {}
			set = {}
			set2 = {}
			idSet = {}
			idSet2 = {}
			set3 = {}
			v({})
		end
	}
end

return createPostStatusCardStore
