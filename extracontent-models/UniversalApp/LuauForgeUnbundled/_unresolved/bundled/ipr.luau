local module = require("@luauforge/bundled/dSm")
local module2 = require("@luauforge/bundled/dSo")
local module3 = require("@luauforge/bundled/dRg")

local fFlagAXUseSignalsForAvatarSettings = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseSignalsForAvatarSettings
local getAvatarSettingsStore

if fFlagAXUseSignalsForAvatarSettings then
	getAvatarSettingsStore = require("@luauforge/bundled/dPt").Stores.getAvatarSettingsStore
else
	getAvatarSettingsStore = nil
end

return function(data)
	return function(object)
		local minimumDeltaEBodyColorDifference = data.minimumDeltaEBodyColorDifference
		local scales = data.scales
		local accessoryRefinementTypes = data.accessoryRefinementTypes
		local accessoryRefinementLowerBounds = data.accessoryRefinementLowerBounds
		local accessoryRefinementUpperBounds = data.accessoryRefinementUpperBounds

		if fFlagAXUseSignalsForAvatarSettings then
			getAvatarSettingsStore(false).setAvatarSettings(
				minimumDeltaEBodyColorDifference,
				scales,
				accessoryRefinementTypes,
				accessoryRefinementLowerBounds,
				accessoryRefinementUpperBounds
			)
		else
			object:dispatch(module(
				minimumDeltaEBodyColorDifference,
				scales,
				accessoryRefinementTypes,
				accessoryRefinementLowerBounds,
				accessoryRefinementUpperBounds
			))
		end

		object:dispatch(module2(module3.DefaultBodyColorRanges))
	end
end
