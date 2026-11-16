local HttpService = game:GetService("HttpService")
local getLocalizedToastStringFromHttpError = require(script.Parent.getLocalizedToastStringFromHttpError)

local parent = script:FindFirstAncestor("RobloxAppToastsRodux").Parent
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
local ToastRodux = require(parent.ToastRodux)
local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local tutils = require(parent.tutils)

local defineFastFlag = game:DefineFastFlag("LuaAppMutedSetNetworkingErrorToast", false)

local function getUserFacingMessage(p)
	local success, result = pcall(HttpService.JSONDecode, HttpService, p.Body)

	if not success then
		return nil
	end

	local errors = result.errors

	if errors then
		for _, err in ipairs(errors) do
			local userFacingMessage = err.userFacingMessage

			if userFacingMessage ~= nil then
				return userFacingMessage
			end
		end
	elseif defineFastFlag then
		mutedError("No errors given in err.Body, err = " .. tutils.toString(p))
	end

	return nil
end

return function(options)
	local v = options or {}
	assert(v, "not nil")

	return function(object)
		local userFacingMessage = getUserFacingMessage(v)

		if userFacingMessage then
			object:dispatch(SetCurrentToastMessage({
				toastType = ToastType.InformationMessage,
				toastMessage = userFacingMessage,
				isLocalized = true
			}))

			return
		end

		local localizedToastStringFromHttpError = getLocalizedToastStringFromHttpError(v.HttpError, v.StatusCode)

		if localizedToastStringFromHttpError ~= nil then
			object:dispatch(SetCurrentToastMessage({
				toastType = ToastType.NetworkingError,
				toastMessage = localizedToastStringFromHttpError
			}))
		end
	end
end
