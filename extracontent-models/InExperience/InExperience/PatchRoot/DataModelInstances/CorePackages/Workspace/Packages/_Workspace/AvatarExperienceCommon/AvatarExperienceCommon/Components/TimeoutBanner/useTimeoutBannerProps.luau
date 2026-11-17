local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local getTimeoutStatusStore = require(AvatarExperienceCommon.Stores.TimeoutStatusStore.getTimeoutStatusStore)
local formatTimeoutEndTime = require(AvatarExperienceCommon.Utils.formatTimeoutEndTime)
local useIsAvatarChangeTimeoutActive = require(AvatarExperienceCommon.Hooks.useIsAvatarChangeTimeoutActive)
local showAvatarChangeFeatureRestriction = require(AvatarExperienceCommon.Utils.showAvatarChangeFeatureRestriction)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXUseUFRForTimeoutPromptInApp = AvatarExperienceFlags.FFlagAXUseUFRForTimeoutPromptInApp
local AvatarExperienceFlags2 = require(parent.AvatarExperienceFlags)
local FFlagAXTimeoutAcknowledgementGating = AvatarExperienceFlags2.FFlagAXTimeoutAcknowledgementGating

local function useTimeoutBannerProps(p)
	local v

	if p and p.shouldFetch ~= nil then
		v = p.shouldFetch
	else
		v = false
	end

	local v2 = not p or p.shouldNavigateOnClick == nil or p.shouldNavigateOnClick

	local timeoutStatusStore = getTimeoutStatusStore()
	local v3 = useSignalState(timeoutStatusStore.getStatus)
	local shouldShow = useSignalState(timeoutStatusStore.getIsTimedOut)
	local v4 = useNavigation()

	React.useEffect(function()
		if v then
			timeoutStatusStore.fetchStatus()
		end
	end, { v, timeoutStatusStore })

	local endTime = v3.timeoutAction and v3.timeoutAction.endTime or v3.details and v3.details.endDate
	local time = formatTimeoutEndTime(endTime)

	local v5 = useLocalization({
		messageText = time and {
			"Feature.Timeout.WarningBanner.DisabledUntilMessage",
			time = time
		} or "Feature.Timeout.WarningBanner.DisabledMessage"
	})

	local onBannerActivated = React.useCallback(function()
		v4.navigate(AvatarScreen.TimeoutStatusPrompt)
	end, { v4 })

	if FFlagAXTimeoutAcknowledgementGating then
		local v6 = useIsAvatarChangeTimeoutActive()
		shouldShow = shouldShow and v6
	end

	if FFlagAXUseUFRForTimeoutPromptInApp then
		local v6 = { messageText = v5.messageText, onBannerActivated = 0, shouldShow = 0 }
		local onBannerActivated2

		if v2 then
			onBannerActivated2 = showAvatarChangeFeatureRestriction
		end

		v6.onBannerActivated = onBannerActivated2
		v6.shouldShow = shouldShow
		return v6
	else
		local v6 = { messageText = v5.messageText, onBannerActivated = 0, shouldShow = 0 }

		if not v2 then
			onBannerActivated = nil
		end

		v6.onBannerActivated = onBannerActivated
		v6.shouldShow = shouldShow
		return v6
	end
end

return useTimeoutBannerProps
