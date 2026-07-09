local AvatarExperienceServerDrivenUi = script:FindFirstAncestor("AvatarExperienceServerDrivenUi")
local AvatarExperienceServerDrivenUiParent = AvatarExperienceServerDrivenUi.Parent
local React = require(AvatarExperienceServerDrivenUiParent.React)
local registerAvatarExperienceActions = require(AvatarExperienceServerDrivenUi.Actions.registerAvatarExperienceActions)
local registerAvatarExperienceUiComponents = require(AvatarExperienceServerDrivenUi.UiComponents.registerAvatarExperienceUiComponents)

local function SduiAvatarExperienceRegister() -- line: 10
	-- upvalues: React (copy), registerAvatarExperienceActions (copy), registerAvatarExperienceUiComponents (copy)
	React.useEffect(function() -- line: 11
		-- upvalues: registerAvatarExperienceActions (copy), registerAvatarExperienceUiComponents (copy)
		registerAvatarExperienceActions()
		registerAvatarExperienceUiComponents()
	end, {})

	return nil
end

return React.memo(SduiAvatarExperienceRegister)
