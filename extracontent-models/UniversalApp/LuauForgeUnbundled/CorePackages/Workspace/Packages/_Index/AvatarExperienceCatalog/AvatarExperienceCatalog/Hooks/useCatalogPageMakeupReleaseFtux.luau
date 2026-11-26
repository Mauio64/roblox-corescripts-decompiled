local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceNavigation")
local useMakeupFtux = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useMakeupFtux")

local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local defineFastInt = game:DefineFastInt("AXMakeupReleaseFtuxPromptDelayMS", 500)

local function useCatalogPageMakeupReleaseFtuxHook(p2, p3, callback)
	local v5 = useMakeupFtux()
	local name = p2 and p2.opaque and p2.opaque.name
	local routeName = p3.state.routeName

	React.useEffect(function()
		local thread

		if v5.shouldShowMakeupReleasePrompt() and name == avatarScreen.Catalog and routeName == name then
			thread = task.delay(defineFastInt / 1000, function()
				p3.navigate(avatarScreen.MakeupReleaseFtuxPrompt, {
					onView = function()
						v5.setShownMakeupReleasePrompt()
						callback()
					end,
					onDismiss = function()
						v5.setShownMakeupReleasePrompt()
					end
				})
			end)
		else
			thread = nil
		end

		return function()
			if thread then
				task.cancel(thread)
			end
		end
	end, { v5, p3, name, routeName, callback })
end

return useCatalogPageMakeupReleaseFtuxHook
