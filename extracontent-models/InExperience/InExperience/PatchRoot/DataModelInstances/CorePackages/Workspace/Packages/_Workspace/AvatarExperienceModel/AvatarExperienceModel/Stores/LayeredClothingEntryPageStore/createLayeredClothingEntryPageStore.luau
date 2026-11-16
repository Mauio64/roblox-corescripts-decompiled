local parent = script:FindFirstAncestor("AvatarExperienceModel").Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local function createLayeredClothingEntryPageStore()
	local sessionScopedSignal, v = createSessionScopedSignal(AvatarScreen.None)

	return {
		getEntryPage = sessionScopedSignal,
		setEntryPage = function(p: string)
			v(p)
		end,
		reset = function()
			v(AvatarScreen.None)
		end
	}
end

return createLayeredClothingEntryPageStore
