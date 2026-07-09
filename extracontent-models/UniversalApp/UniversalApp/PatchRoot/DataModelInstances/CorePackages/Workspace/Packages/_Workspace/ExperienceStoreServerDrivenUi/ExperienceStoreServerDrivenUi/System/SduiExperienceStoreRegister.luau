local ExperienceStoreServerDrivenUi = script:FindFirstAncestor("ExperienceStoreServerDrivenUi")
local ExperienceStoreServerDrivenUiParent = ExperienceStoreServerDrivenUi.Parent
local React = require(ExperienceStoreServerDrivenUiParent.React)
local registerExperienceStoreActions = require(ExperienceStoreServerDrivenUi.Actions.registerExperienceStoreActions)

local function SduiExperienceStoreRegister() -- line: 8
	-- upvalues: React (copy), registerExperienceStoreActions (copy)
	React.useEffect(function() -- line: 9
		-- upvalues: registerExperienceStoreActions (copy)
		registerExperienceStoreActions()
	end, {})

	return nil
end

return React.memo(SduiExperienceStoreRegister)
