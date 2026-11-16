local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/React")

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/Localization").Hooks.useLocalization
local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Index/SocialBlockingModal/ToastRodux").Actions.SetCurrentToastMessage

local v5 = {
	BLOCK_TARGET_ALREADY_BLOCKED_ERROR = 1,
	USER_BLOCKING_LIMIT_REACHED_API_ERROR = 2,
	UNBLOCK_TARGET_NOT_BLOCKED_ERROR = 4,
	PARENT_BLOCKED_TARGET_USER_ERROR = 14
}

local function useShowToastOnError()
	local v6 = useDispatch()
	local v7 = useLocalization({
		somethingIsWrongToast = "Feature.Toast.NetworkingError.SomethingIsWrong",
		blockLimitReachedToast = "Feature.Profile.Message.BlockError",
		blocktargetAlreadyBlockedToast = "Feature.Friends.Error.TargetAlreadyBlockedError"
	})

	return React.useCallback(function(p2)
		local body = p2 and p2.Body and tonumber(p2.Body) or nil

		if body == 1 then
			v6(setCurrentToastMessage({
				toastMessage = v7.blocktargetAlreadyBlockedToast,
				isLocalized = true
			}))
		elseif body == 2 then
			v6(setCurrentToastMessage({
				toastMessage = v7.blockLimitReachedToast,
				isLocalized = true
			}))
		else
			v6(setCurrentToastMessage({
				toastMessage = v7.somethingIsWrongToast,
				isLocalized = true
			}))
		end
	end, { v6, v7 })
end

return useShowToastOnError
