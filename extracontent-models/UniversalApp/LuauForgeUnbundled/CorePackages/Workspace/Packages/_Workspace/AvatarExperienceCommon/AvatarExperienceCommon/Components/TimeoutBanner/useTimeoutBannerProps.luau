local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/SignalsReact").useSignalState
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Navigation").useNavigation
local avatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceNavigation").Enums.AvatarScreen

local getTimeoutStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/TimeoutStatusStore/getTimeoutStatusStore")
local formatTimeoutEndTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/formatTimeoutEndTime")
local useIsAvatarChangeTimeoutActive = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useIsAvatarChangeTimeoutActive")
local showAvatarChangeFeatureRestriction = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/showAvatarChangeFeatureRestriction")

local fFlagAXUseUFRForTimeoutPromptInApp = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags").FFlagAXUseUFRForTimeoutPromptInApp
local fFlagAXTimeoutAcknowledgementGating = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags").FFlagAXTimeoutAcknowledgementGating

local function useTimeoutBannerProps(p2)
	local v5 = if p2 and p2.shouldFetch ~= nil then p2.shouldFetch else false
	local v6 = not p2 or p2.shouldNavigateOnClick == nil or p2.shouldNavigateOnClick

	local v7 = getTimeoutStatusStore()
	local v8 = useSignalState(v7.getStatus)
	local v9 = useSignalState(v7.getIsTimedOut)
	local v10 = useNavigation()

	React.useEffect(function()
		if v5 then
			v7.fetchStatus()
		end
	end, { v5, v7 })

	local endTime = v8.timeoutAction and v8.timeoutAction.endTime or v8.details and v8.details.endDate
	local v11 = formatTimeoutEndTime(endTime)

	local v12 = useLocalization({
		messageText = v11 and {
			"Feature.Timeout.WarningBanner.DisabledUntilMessage",
			time = v11
		} or "Feature.Timeout.WarningBanner.DisabledMessage"
	})

	local v13 = React.useCallback(function()
		v10.navigate(avatarScreen.TimeoutStatusPrompt)
	end, { v10 })

	if fFlagAXTimeoutAcknowledgementGating then
		local v14 = useIsAvatarChangeTimeoutActive()
		v9 = v9 and v14
	end

	if fFlagAXUseUFRForTimeoutPromptInApp then
		return {
			messageText = v12.messageText,
			onBannerActivated = if v6 then showAvatarChangeFeatureRestriction else nil,
			shouldShow = v9
		}
	else
		local v14 = {
			messageText = v12.messageText,
			onBannerActivated = 0,
			shouldShow = 0
		}

		if not v6 then
			v13 = nil
		end

		v14.onBannerActivated = v13
		v14.shouldShow = v9
		return v14
	end
end

return useTimeoutBannerProps
