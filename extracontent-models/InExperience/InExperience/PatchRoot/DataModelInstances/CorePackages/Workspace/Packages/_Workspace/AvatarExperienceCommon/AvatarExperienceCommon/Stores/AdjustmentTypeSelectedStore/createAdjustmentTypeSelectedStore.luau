local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal
local AdjustmentType = require(AvatarExperienceCommon.Enums.AdjustmentType)

local Position = AdjustmentType.Position

local function createAdjustmentTypeSelectedStore()
	local sessionScopedSignal, v = createSessionScopedSignal(Position)

	return {
		getAdjustmentTypeSelected = sessionScopedSignal,
		setAdjustmentType = function(p)
			v(p)
		end,
		reset = function()
			v(Position)
		end
	}
end

return createAdjustmentTypeSelectedStore
