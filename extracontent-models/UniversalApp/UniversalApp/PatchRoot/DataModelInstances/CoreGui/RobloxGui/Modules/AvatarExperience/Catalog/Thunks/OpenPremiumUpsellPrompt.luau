local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Modules = CoreGui.RobloxGui.Modules
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local PremiumUpsellTriggerContext = require(Modules.LuaApp.Components.PremiumUpsell.Enum.PremiumUpsellTriggerContext)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

return function(_, _, p3, p4, _: {[any]: any}?, p5, p6) -- line: 33
	-- upvalues: ArgCheck (copy), AvatarScreen (copy), PremiumUpsellTriggerContext (copy), NavigateWithLock (copy)
	ArgCheck.isTypeOrNil(p5, "string", "OpenPremiumUpsellPrompt expects itemId")
	ArgCheck.isTypeOrNil(p6, "string", "OpenPremiumUpsellPrompt expects itemType")

	return function(p7) -- line: 36
		-- upvalues: p4 (copy), AvatarScreen (copy), p3 (copy), PremiumUpsellTriggerContext (copy), NavigateWithLock (copy)
		p7:dispatch(NavigateWithLock(function() -- line: 37
			-- upvalues: p4 (copy), AvatarScreen (copy), p3 (copy), PremiumUpsellTriggerContext (copy)
			p4.navigate(AvatarScreen.PremiumUpsellPrompt, {
				onCancel = function() -- line: 39
				end,
				onOverlayClosed = p3,
				triggerContext = PremiumUpsellTriggerContext.UACatalog
			})
		end))
	end
end
