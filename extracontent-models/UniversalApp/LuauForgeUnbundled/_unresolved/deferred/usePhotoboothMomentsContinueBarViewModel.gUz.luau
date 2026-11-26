local module = require("@luauforge/deferred/gTR")
local useLocalization = require("@luauforge/deferred/gUd").Hooks.useLocalization
local useSignalState = require("@luauforge/deferred/gUp").useSignalState
local fFlagAXPhotoboothMomentsLogging = require("@luauforge/deferred/gTV").FFlagAXPhotoboothMomentsLogging
local fFlagAXAvatarMomentsCreation = require("@luauforge/deferred/gTV").FFlagAXAvatarMomentsCreation

require("@luauforge/deferred/gUy")
local module2 = require("@luauforge/deferred/gUq")
local module3 = require("@luauforge/deferred/gUA")

local function noop() end

local function usePhotoboothMomentsContinueBarViewModel(data)
	local v5 = useLocalization({ continue = "Feature.Avatar.Label.Continue" })

	local v6 = module2(false)
	local v7 = useSignalState(v6.getActiveEmoteId)
	local v8 = useSignalState(v6.getActiveBackgroundId) ~= ""

	local isEmotesDisabled = data.isEmotesDisabled or v7 ~= ""

	local v9 = if fFlagAXAvatarMomentsCreation then data.onContinue or noop else noop
	local v10

	if fFlagAXPhotoboothMomentsLogging then
		local isEmotesDisabled2 = data.isEmotesDisabled
		v10 = module.useCallback(function()
			module3.sendContinueClick({
				outfitId = v6.getActiveOutfitId(false),
				emoteAssetId = v6.getActiveEmoteId(false),
				backgroundAssetId = v6.getActiveBackgroundId(false),
				isEmotesDisabled = isEmotesDisabled2
			})

			v9()
		end, { v6, isEmotesDisabled2, v9 })
	else
		v10 = v9
	end

	return {
		text = v5.continue,
		isDisabled = not (v8 and isEmotesDisabled),
		onActivated = v10,
		isLandscape = data.isLandscape,
		LayoutOrder = data.LayoutOrder
	}
end

return usePhotoboothMomentsContinueBarViewModel
