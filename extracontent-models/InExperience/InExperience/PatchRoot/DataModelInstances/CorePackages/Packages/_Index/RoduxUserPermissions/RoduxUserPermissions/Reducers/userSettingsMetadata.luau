local parent = script.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)
require(parent.Types.ReducerTypes)

local v = { prefillDiscoverabilitySetting = false }

return function(p)
	local networkingUserSettings = p.networkingUserSettings

	return Rodux.createReducer(v, {
		[networkingUserSettings.GetUserSettingsMetadata.Succeeded.name] = function(_, p2)
			return {
				prefillDiscoverabilitySetting = p2.responseBody and p2.responseBody.prefillDiscoverabilitySetting
			}
		end
	})
end
