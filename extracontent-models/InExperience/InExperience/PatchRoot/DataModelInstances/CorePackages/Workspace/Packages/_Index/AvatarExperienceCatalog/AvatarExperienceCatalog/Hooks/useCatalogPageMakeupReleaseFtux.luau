local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local useMakeupFtux = require(script.Parent.useMakeupFtux)

local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local defineFastInt = game:DefineFastInt("AXMakeupReleaseFtuxPromptDelayMS", 500)

local function useCatalogPageMakeupReleaseFtuxHook(p, p2, callback)
	local v = useMakeupFtux()
	local name = p and p.opaque and p.opaque.name
	local routeName = p2.state.routeName

	React.useEffect(function()
		local thread

		if v.shouldShowMakeupReleasePrompt() and name == AvatarScreen.Catalog and routeName == name then
			thread = task.delay(defineFastInt / 1000, function()
				p2.navigate(AvatarScreen.MakeupReleaseFtuxPrompt, {
					onView = function()
						v.setShownMakeupReleasePrompt()
						callback()
					end,
					onDismiss = function()
						v.setShownMakeupReleasePrompt()
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
	end, { v, p2, name, routeName, callback })
end

return useCatalogPageMakeupReleaseFtuxHook
