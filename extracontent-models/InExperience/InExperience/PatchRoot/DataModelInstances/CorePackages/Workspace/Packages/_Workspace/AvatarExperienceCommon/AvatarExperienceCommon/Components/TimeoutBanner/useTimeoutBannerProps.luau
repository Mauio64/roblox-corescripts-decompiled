local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local React = require(AvatarExperienceCommonParent.React)
local useSignalState = require(AvatarExperienceCommonParent.SignalsReact).useSignalState
local useLocalization = require(AvatarExperienceCommonParent.Localization).Hooks.useLocalization
local useNavigation = require(AvatarExperienceCommonParent.Navigation).useNavigation
local AvatarScreen = require(AvatarExperienceCommonParent.AvatarExperienceNavigation).Enums.AvatarScreen
local getTimeoutStatusStore = require(AvatarExperienceCommon.Stores.TimeoutStatusStore.getTimeoutStatusStore)
local formatTimeoutEndTime = require(AvatarExperienceCommon.Utils.formatTimeoutEndTime)

local function useTimeoutBannerProps(t1: {[any]: any}?) -- line: 28
	-- upvalues: getTimeoutStatusStore (copy), useSignalState (copy), useNavigation (copy), React (copy), formatTimeoutEndTime (copy), useLocalization (copy), AvatarScreen (copy)
	local v12 = not not t1 and (t1.shouldFetch ~= nil and t1.shouldFetch)
	local v13 = not t1 or (t1.shouldNavigateOnClick == nil or t1.shouldNavigateOnClick)
	local v14 = getTimeoutStatusStore()
	local v15 = useSignalState(v14.getStatus)
	local v16 = useSignalState(v14.getIsTimedOut)
	local v17 = useNavigation()

	React.useEffect(function() -- line: 39
		-- upvalues: v12 (copy), v14 (copy)
		if v12 then
			v14.fetchStatus()
		end
	end, {
		v12,
		v14
	})

	local v18 = v15.timeoutAction and v15.timeoutAction.endTime or v15.details and v15.details.endDate
	local v19 = formatTimeoutEndTime(v18)
	local v20 = useLocalization({
		messageText = not v19 and "Feature.Timeout.WarningBanner.DisabledMessage" or {
			"Feature.Timeout.WarningBanner.DisabledUntilMessage",
			time = v19
		}
	})
	local v21 = React.useCallback(function() -- line: 54
		-- upvalues: v17 (copy), AvatarScreen (copy)
		v17.navigate(AvatarScreen.TimeoutStatusPrompt)
	end, { v17 })

	return {
		messageText = v20.messageText,
		onBannerActivated = if not v13 then nil else v21,
		shouldShow = v16
	}
end

return useTimeoutBannerProps
