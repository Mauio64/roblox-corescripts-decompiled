local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local SocialServerDrivenUiParent = SocialServerDrivenUi.Parent
local React = require(SocialServerDrivenUiParent.React)
local registerSocialActions = require(SocialServerDrivenUi.Actions.registerSocialActions)
local registerSocialComponents = require(SocialServerDrivenUi.System.registerSocialComponents)

local function SduiSocialRegister() -- line: 9
	-- upvalues: React (copy), registerSocialComponents (copy), registerSocialActions (copy)
	React.useEffect(function() -- line: 10
		-- upvalues: registerSocialComponents (copy), registerSocialActions (copy)
		registerSocialComponents()
		registerSocialActions()
	end, {})

	return nil
end

return React.memo(SduiSocialRegister)
