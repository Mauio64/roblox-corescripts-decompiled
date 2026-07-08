local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)

require(ParentParent.Types.ReducerTypes)

local t1 = {
	prefillDiscoverabilitySetting = false
}

return function(p1) -- line: 10
	-- upvalues: Rodux (copy), t1 (copy)
	local networkingUserSettings = p1.networkingUserSettings

	return Rodux.createReducer(t1, {
		[networkingUserSettings.GetUserSettingsMetadata.Succeeded.name] = function(_, p3) -- line: 14
			return {
				prefillDiscoverabilitySetting = p3.responseBody and p3.responseBody.prefillDiscoverabilitySetting
			}
		end
	})
end
