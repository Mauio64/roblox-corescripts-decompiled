local crossDeviceLogin = require("@luauforge/bundled/fCs").Thunks.CrossDeviceLogin
local loginByCode = require("@luauforge/bundled/fCs").Thunks.LoginByCode
local closeCentralOverlay = require("@luauforge/bundled/fCt").Thunks.CloseCentralOverlay
local logger = require("@luauforge/bundled/fCu").Logger
local pollMagicLoginStatusType = require("@luauforge/bundled/fCv").PollMagicLoginStatusType
local function pollLoginStatus(data)
	local networking = data.networking
	local deviceCode = data.deviceCode
	local privateKey = data.privateKey
	local isMounted = data.isMounted
	local launchApp = data.launchApp
	local onError = data.onError
	local retriesLeft = data.retriesLeft
	local store = data.store

	return crossDeviceLogin.GetLoginStatus(networking, deviceCode, privateKey)():andThen(function(p2)
		if isMounted.current then
			if p2.Status == pollMagicLoginStatusType.VALIDATED then
				return loginByCode(networking, deviceCode, privateKey, nil, nil, nil, nil)():andThen(
					function(p3)
						if isMounted.current then
							store:dispatch(closeCentralOverlay())

							if launchApp then
								launchApp()
							end
						end
					end,
					function(p3)
						if isMounted.current then
							logger:warning("Login failed:" .. p3)
							onError()
						end
					end
				)
			end

			if
				p2.Status == pollMagicLoginStatusType.EXPIRED
				or p2.Status == pollMagicLoginStatusType.CANCELLED
			then
				if isMounted.current then
					onError()
				end
			else
				spawn(function()
					wait(2)

					if isMounted.current and retriesLeft > 0 then
						pollLoginStatus({
							networking = networking,
							deviceCode = deviceCode,
							privateKey = privateKey,
							isMounted = isMounted,
							launchApp = launchApp,
							onError = onError,
							retriesLeft = retriesLeft - 1,
							store = store
						})
					elseif isMounted.current then
						onError()
					end
				end)
			end
		end
	end, function(p2)
		if isMounted.current then
			if p2.Body == pollMagicLoginStatusType.CODE_INVALID then
				onError()
			else
				spawn(function()
					wait(2)

					if isMounted.current and retriesLeft > 0 then
						pollLoginStatus({
							networking = networking,
							deviceCode = deviceCode,
							privateKey = privateKey,
							isMounted = isMounted,
							launchApp = launchApp,
							onError = onError,
							retriesLeft = retriesLeft - 1,
							store = store
						})
					elseif isMounted.current then
						onError()
					end
				end)
			end
		end
	end)
end

return function(p2, p3, p4, p5, p6, onError)
	return function(p7)
		return pollLoginStatus({
			networking = p2,
			deviceCode = p3,
			privateKey = p4,
			isMounted = p5,
			launchApp = p6,
			onError = onError,
			retriesLeft = 50,
			store = p7
		})
	end
end
