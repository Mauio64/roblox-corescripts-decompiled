local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local useSignalState = require(Parent.SignalsReact).useSignalState
local AvatarExperienceCommon = require(Parent.AvatarExperienceCommon)
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local AvatarExperienceNavigation = require(Parent.AvatarExperienceNavigation)
local getTimeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local FFlagAXRefetchAvatarOnTimeout = AvatarExperienceFlags.FFlagAXRefetchAvatarOnTimeout

local function useCatalogPageTimeoutPrompt(p1, p2: ((...any) -> ...any)?) -- line: 19
	-- upvalues: getTimeoutStatusStore (copy), useSignalState (copy), React (copy), AvatarScreen (copy), FFlagAXRefetchAvatarOnTimeout (copy)
	local v13 = getTimeoutStatusStore()
	local v14 = useSignalState(v13.getStatus)
	local v15 = useSignalState(v13.getIsTimedOut)
	local v16 = React.useRef(false)
	local v17 = React.useRef(false)
	local v18 = React.useRef(p1)

	v18.current = p1
	React.useEffect(function() -- line: 28
		-- upvalues: v17 (copy), v13 (copy)
		if not v17.current then
			v17.current = true
			v13.fetchStatus()
		end
	end, {})
	React.useEffect(function() -- line: 35
		-- upvalues: v14 (copy), v16 (copy), v17 (copy), v18 (copy), AvatarScreen (copy)
		if v14 and (not v16.current and v17.current and v14.details) then
			v16.current = true
			v18.current.navigate(AvatarScreen.TimeoutStatusPrompt)
		end
	end, { v14 })

	if FFlagAXRefetchAvatarOnTimeout then
		React.useEffect(function() -- line: 45
			-- upvalues: p2 (copy), v15 (copy)
			if p2 and v15 then
				p2()
			end
		end, {
			v15,
			p2
		})
	end
end

return useCatalogPageTimeoutPrompt
