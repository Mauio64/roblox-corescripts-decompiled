local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SignalsReact").useSignalState
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceNavigation")

local getTimeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore
local showAvatarChangeFeatureRestriction = AvatarExperienceCommon.Utils.showAvatarChangeFeatureRestriction
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local fFlagAXUseUFRForTimeoutPromptInApp = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXUseUFRForTimeoutPromptInApp

local function useCatalogPageTimeoutPrompt(current, callback)
	local timeoutStatusStore = getTimeoutStatusStore()
	local v5 = useSignalState(timeoutStatusStore.getStatus)
	local v6 = useSignalState(timeoutStatusStore.getIsTimedOut)
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
		if v5 and not ref.current and ref2.current and v5.details then
			ref.current = true

			if fFlagAXUseUFRForTimeoutPromptInApp then
				showAvatarChangeFeatureRestriction()
			else
				ref3.current.navigate(avatarScreen.TimeoutStatusPrompt)
			end
		end
	end, { v5 })

	React.useEffect(function()
		if callback and v6 then
			callback()
		end
	end, { v6, callback })
end

return useCatalogPageTimeoutPrompt
