local Parent = script:FindFirstAncestor("SocialBlockingModal").Parent
local React = require(Parent.React)
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local SetCurrentToastMessage = require(Parent.ToastRodux).Actions.SetCurrentToastMessage
local _ = {
	BLOCK_TARGET_ALREADY_BLOCKED_ERROR = 1,
	USER_BLOCKING_LIMIT_REACHED_API_ERROR = 2,
	UNBLOCK_TARGET_NOT_BLOCKED_ERROR = 4,
	PARENT_BLOCKED_TARGET_USER_ERROR = 14
}

local function useShowToastOnError() -- line: 17
	-- upvalues: useDispatch (copy), useLocalization (copy), React (copy), SetCurrentToastMessage (copy)
	local v8 = useDispatch()
	local v9 = useLocalization({
		somethingIsWrongToast = "Feature.Toast.NetworkingError.SomethingIsWrong",
		blockLimitReachedToast = "Feature.Profile.Message.BlockError",
		blocktargetAlreadyBlockedToast = "Feature.Friends.Error.TargetAlreadyBlockedError"
	})

	return React.useCallback(function(t1: {[any]: any}?) -- line: 25
		-- upvalues: v8 (copy), SetCurrentToastMessage (copy), v9 (copy)
		local v11 = t1 and (not not t1.Body and tonumber(t1.Body)) or nil

		if v11 == 1 then
			v8(SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v9.blocktargetAlreadyBlockedToast
			}))

			return
		end

		if v11 == 2 then
			v8(SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v9.blockLimitReachedToast
			}))

			return
		end

		v8(SetCurrentToastMessage({
			isLocalized = true,
			toastMessage = v9.somethingIsWrongToast
		}))
	end, {
		v8,
		v9
	})
end

return useShowToastOnError
