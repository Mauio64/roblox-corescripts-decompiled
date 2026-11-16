local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)

local getTimeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore
local showAvatarChangeFeatureRestriction = AvatarExperienceCommon.Utils.showAvatarChangeFeatureRestriction
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXUseUFRForTimeoutPromptInApp = AvatarExperienceFlags.FFlagAXUseUFRForTimeoutPromptInApp

local function useCatalogPageTimeoutPrompt(current, callback)
	local timeoutStatusStore = getTimeoutStatusStore()
	local v = useSignalState(timeoutStatusStore.getStatus)
	local v2 = useSignalState(timeoutStatusStore.getIsTimedOut)
	local ref = React.useRef(false)
	local ref2 = React.useRef(false)
	local ref3 = React.useRef(current)
	ref3.current = current

	React.useEffect(function()
		if not ref2.current then
			ref2.current = true
			timeoutStatusStore.fetchStatus()
		end
	end, {})

	React.useEffect(function()
		if v and not ref.current and ref2.current and v.details then
			ref.current = true

			if FFlagAXUseUFRForTimeoutPromptInApp then
				showAvatarChangeFeatureRestriction()
			else
				ref3.current.navigate(AvatarScreen.TimeoutStatusPrompt)
			end
		end
	end, { v })

	React.useEffect(function()
		if callback and v2 then
			callback()
		end
	end, { v2, callback })
end

return useCatalogPageTimeoutPrompt
