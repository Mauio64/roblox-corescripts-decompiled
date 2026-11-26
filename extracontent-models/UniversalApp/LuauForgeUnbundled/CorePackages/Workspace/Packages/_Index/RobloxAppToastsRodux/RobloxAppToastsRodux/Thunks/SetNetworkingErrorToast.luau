local HttpService = game:GetService("HttpService")
local getLocalizedToastStringFromHttpError = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux/Thunks/getLocalizedToastStringFromHttpError")

local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/Loggers").mutedError
local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/ToastRodux")
local toastType = ToastRodux.Enums.ToastType
local setCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/tutils")

local defineFastFlag = game:DefineFastFlag("LuaAppMutedSetNetworkingErrorToast", false)

local function getUserFacingMessage(p2)
	local success, result = pcall(HttpService.JSONDecode, HttpService, p2.Body)

	if not success then
		return nil
	end

	local errors = result.errors

	if errors then
		for i, err in ipairs(errors) do
			local userFacingMessage = err.userFacingMessage

			if userFacingMessage ~= nil then
				return userFacingMessage
			end
		end
	elseif defineFastFlag then
		mutedError("No errors given in err.Body, err = " .. tutils.toString(p2))
	end

	return nil
end

return function(options)
	local v5 = options or {}
	assert(v5, "not nil")

	return function(object)
		local userFacingMessage = getUserFacingMessage(v5)

		if userFacingMessage then
			object:dispatch(setCurrentToastMessage({
				toastType = toastType.InformationMessage,
				toastMessage = userFacingMessage,
				isLocalized = true
			}))

			return
		end

		local v6 = getLocalizedToastStringFromHttpError(v5.HttpError, v5.StatusCode)

		if v6 ~= nil then
			object:dispatch(setCurrentToastMessage({
				toastType = toastType.NetworkingError,
				toastMessage = v6
			}))
		end
	end
end
