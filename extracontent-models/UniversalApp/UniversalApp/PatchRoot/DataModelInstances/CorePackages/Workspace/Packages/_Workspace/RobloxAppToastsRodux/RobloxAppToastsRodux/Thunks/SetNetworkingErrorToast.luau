local HttpService = game:GetService("HttpService")
local getLocalizedToastStringFromHttpError = require(script.Parent.getLocalizedToastStringFromHttpError)
local Parent = script:FindFirstAncestor("RobloxAppToastsRodux").Parent
local mutedError = require(Parent.Loggers).mutedError
local ToastRodux = require(Parent.ToastRodux)
local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local tutils = require(Parent.tutils)
local v9 = game:DefineFastFlag("LuaAppMutedSetNetworkingErrorToast", false)

local function getUserFacingMessage(p1) -- line: 13
	-- upvalues: HttpService (copy), v9 (copy), mutedError (copy), tutils (copy)
	local ok, result = pcall(HttpService.JSONDecode, HttpService, p1.Body)

	if not ok then
		return nil
	end

	local errors = result.errors

	if errors then
		for _, v in ipairs(errors) do
			local userFacingMessage = v.userFacingMessage

			if userFacingMessage ~= nil then
				return userFacingMessage
			end
		end
	elseif v9 then
		mutedError("No errors given in err.Body, err = " .. tutils.toString(p1))
	end

	return nil
end

return function(p2) -- line: 37
	-- upvalues: getUserFacingMessage (copy), SetCurrentToastMessage (copy), ToastType (copy), getLocalizedToastStringFromHttpError (copy)
	local u19 = p2 or {}

	assert(u19, "not nil")

	return function(p3) -- line: 41
		-- upvalues: getUserFacingMessage (copy), u19 (ref), SetCurrentToastMessage (copy), ToastType (copy), getLocalizedToastStringFromHttpError (copy)
		local v21 = getUserFacingMessage(u19)

		if v21 then
			p3:dispatch(SetCurrentToastMessage({
				isLocalized = true,
				toastType = ToastType.InformationMessage,
				toastMessage = v21
			}))

			return
		end

		local v22 = getLocalizedToastStringFromHttpError(u19.HttpError, u19.StatusCode)

		if v22 ~= nil then
			p3:dispatch(SetCurrentToastMessage({
				toastType = ToastType.NetworkingError,
				toastMessage = v22
			}))
		end
	end
end
