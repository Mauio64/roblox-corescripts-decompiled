local module = require("@luauforge/bundled/dzP")

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock
local module2 = require("@luauforge/deferred/fCS")
require("@luauforge/bundled/dKT")

return function(p2, p3, onOverlayClosed, p4, p5, p6, p7)
	module.isTypeOrNil(p6, "string", "OpenPremiumUpsellPrompt expects itemId")
	module.isTypeOrNil(p7, "string", "OpenPremiumUpsellPrompt expects itemType")
	return function(object)
		object:dispatch(navigateWithLock(function()
			p4.navigate(avatarScreen.PremiumUpsellPrompt, {
				onCancel = function() end,
				onOverlayClosed = onOverlayClosed,
				triggerContext = module2.UACatalog
			})
		end))
	end
end
