local parent = script:FindFirstAncestor("SocialBlockingModal").Parent

local React = require(parent.React)

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local _ = {
	BLOCK_TARGET_ALREADY_BLOCKED_ERROR = 1,
	USER_BLOCKING_LIMIT_REACHED_API_ERROR = 2,
	UNBLOCK_TARGET_NOT_BLOCKED_ERROR = 4,
	PARENT_BLOCKED_TARGET_USER_ERROR = 14
}

local function useShowToastOnError()
	local v = useDispatch()
	local v2 = useLocalization({
		somethingIsWrongToast = "Feature.Toast.NetworkingError.SomethingIsWrong",
		blockLimitReachedToast = "Feature.Profile.Message.BlockError",
		blocktargetAlreadyBlockedToast = "Feature.Friends.Error.TargetAlreadyBlockedError"
	})

	return React.useCallback(function(p)
		local body = p and p.Body and tonumber(p.Body) or nil

		if body == 1 then
			v(SetCurrentToastMessage({
				toastMessage = v2.blocktargetAlreadyBlockedToast,
				isLocalized = true
			}))
		elseif body == 2 then
			v(SetCurrentToastMessage({
				toastMessage = v2.blockLimitReachedToast,
				isLocalized = true
			}))
		else
			v(SetCurrentToastMessage({ toastMessage = v2.somethingIsWrongToast, isLocalized = true }))
		end
	end, { v, v2 })
end

return useShowToastOnError
