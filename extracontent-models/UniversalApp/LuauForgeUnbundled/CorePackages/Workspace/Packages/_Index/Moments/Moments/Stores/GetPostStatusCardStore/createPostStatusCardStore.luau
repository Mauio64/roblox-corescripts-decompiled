require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local function createPostStatusCardStore()
	local signal, v5 = Signals.createSignal({})
	local v6 = {}
	local v7 = {}
	local set = {}
	local set2 = {}
	local idSet = {}
	local idSet2 = {}
	local set3 = {}

	local function add(p2)
		if idSet[p2.id] then
			return
		end

		idSet[p2.id] = true

		if p2.cardType == "Live" then
			idSet2[p2.id] = true
		end

		v6[p2.id] = nil
		v7[p2.id] = nil
		local clone = table.clone(signal(false))
		table.insert(clone, 1, p2)
		v5(clone)
	end

	return {
		getCards = signal,
		add = add,
		markUploading = function(p2)
			if not idSet[p2] then
				v7[p2] = true
			end
		end,
		isUploading = function(p2): boolean
			return v7[p2] == true
		end,
		awaitLiveCard = function(p2)
			v7[p2] = nil

			if not idSet[p2] then
				v6[p2] = true
			end
		end,
		isAwaitingLiveCard = function(p2): boolean
			return v6[p2] == true
		end,
		markToastHiddenFor = function(p2)
			set[p2] = true
		end,
		hadToastHidden = function(p2): boolean
			return set[p2] == true
		end,
		markToastProbablySpentFor = function(p2)
			set2[p2] = true
		end,
		hadToastProbablySpent = function(p2): boolean
			return set2[p2] == true
		end,
		stopAwaitingLiveCard = function(p2, p3)
			v7[p2] = nil

			if not v6[p2] then
				return
			end

			v6[p2] = nil

			if p3 ~= nil and set[p2] then
				add(p3)
			end
		end,
		dismiss = function(p2)
			local v8 = {}

			for k, v9 in signal(false) do
				if v9.id ~= p2 then
					table.insert(v8, v9)
				end
			end

			v5(v8)
		end,
		hasHadLiveCard = function(p2): boolean
			return idSet2[p2] == true
		end,
		markShown = function(p2): boolean
			if set3[p2] then
				return false
			end

			set3[p2] = true
			return true
		end,
		reset = function()
			v6 = {}
			v7 = {}
			set = {}
			set2 = {}
			idSet = {}
			idSet2 = {}
			set3 = {}
			v5({})
		end
	}
end

return createPostStatusCardStore
