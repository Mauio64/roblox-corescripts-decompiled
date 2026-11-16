local module = require("@luauforge/deferred/gpO")

local function createPhotoboothMomentsStore()
	local signal, v5 = module.createSignal("")
	local signal2, v6 = module.createSignal("")
	local signal3, v7 = module.createSignal("")

	return {
		getActiveOutfitId = signal,
		getActiveEmoteId = signal2,
		getActiveBackgroundId = signal3,
		setActiveOutfit = function(p2)
			v5(p2)
		end,
		setActiveEmote = function(p2)
			v6(p2)
		end,
		setActiveBackground = function(p2)
			v7(p2)
		end,
		reset = function()
			v5("")
			v6("")
			v7("")
		end
	}
end

return createPhotoboothMomentsStore
