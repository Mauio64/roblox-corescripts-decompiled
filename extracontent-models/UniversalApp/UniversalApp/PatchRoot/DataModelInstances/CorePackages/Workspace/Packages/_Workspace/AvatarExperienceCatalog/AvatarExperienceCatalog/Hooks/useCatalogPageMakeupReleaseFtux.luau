local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local AvatarExperienceNavigation = require(Parent.AvatarExperienceNavigation)
local useMakeupFtux = require(script.Parent.useMakeupFtux)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local v6 = game:DefineFastInt("AXMakeupReleaseFtuxPromptDelayMS", 500)

local function useCatalogPageMakeupReleaseFtuxHook(p1, p2, p3: ((...any) -> ...any)) -- line: 15
	-- upvalues: useMakeupFtux (copy), React (copy), AvatarScreen (copy), v6 (copy)
	local v11 = useMakeupFtux()
	local v12 = p1 and (p1.opaque and p1.opaque.name)
	local routeName = p2.state.routeName

	React.useEffect(function() -- line: 24
		-- upvalues: v11 (copy), v12 (copy), AvatarScreen (copy), routeName (copy), v6 (copy), p2 (copy), p3 (copy)
		local thread = nil

		if v11.shouldShowMakeupReleasePrompt() and (v12 == AvatarScreen.Catalog and routeName == v12) then
			thread = task.delay(v6 / 1000, function() -- line: 32
				-- upvalues: p2 (copy), AvatarScreen (copy), v11 (copy), p3 (copy)
				p2.navigate(AvatarScreen.MakeupReleaseFtuxPrompt, {
					onView = function() -- line: 34
						-- upvalues: v11 (copy), p3 (copy)
						v11.setShownMakeupReleasePrompt()
						p3()
					end,
					onDismiss = function() -- line: 38
						-- upvalues: v11 (copy)
						v11.setShownMakeupReleasePrompt()
					end
				})
			end)
		end

		return function() -- line: 45
			-- upvalues: thread (ref)
			if thread then
				task.cancel(thread)
			end
		end
	end, {
		v11,
		p2,
		v12,
		routeName,
		p3
	})
end

return useCatalogPageMakeupReleaseFtuxHook
