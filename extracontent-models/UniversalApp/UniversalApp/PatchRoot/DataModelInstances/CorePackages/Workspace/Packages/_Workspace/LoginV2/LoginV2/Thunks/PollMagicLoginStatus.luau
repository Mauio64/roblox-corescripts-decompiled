local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local CrossDeviceLogin = require(LoginV2Parent.AuthCommon).Thunks.CrossDeviceLogin
local LoginByCode = require(LoginV2Parent.AuthCommon).Thunks.LoginByCode
local CloseCentralOverlay = require(LoginV2Parent.CentralOverlay).Thunks.CloseCentralOverlay
local Logger = require(LoginV2Parent.Loggers).Logger
local PollMagicLoginStatusType = require(LoginV2.Enums).PollMagicLoginStatusType

local function pollLoginStatus(t1: {[any]: any}) -- line: 25
	-- upvalues: CrossDeviceLogin (copy), PollMagicLoginStatusType (copy), LoginByCode (copy), CloseCentralOverlay (copy), Logger (copy), pollLoginStatus (copy)
	local networking = t1.networking
	local deviceCode = t1.deviceCode
	local privateKey = t1.privateKey
	local isMounted = t1.isMounted
	local launchApp = t1.launchApp
	local onError = t1.onError
	local retriesLeft = t1.retriesLeft
	local store = t1.store

	return CrossDeviceLogin.GetLoginStatus(networking, deviceCode, privateKey)():andThen(function(p1) -- line: 35
		-- upvalues: isMounted (copy), PollMagicLoginStatusType (copy), LoginByCode (copy), networking (copy), deviceCode (copy), privateKey (copy), store (copy), CloseCentralOverlay (copy), launchApp (copy), Logger (copy), onError (copy), retriesLeft (copy), pollLoginStatus (copy)
		if isMounted.current then
			if p1.Status == PollMagicLoginStatusType.VALIDATED then
				return LoginByCode(networking, deviceCode, privateKey, nil, nil, nil, nil)():andThen(function(_) -- line: 38
					-- upvalues: isMounted (copy), store (copy), CloseCentralOverlay (copy), launchApp (copy)
					if isMounted.current then
						store:dispatch(CloseCentralOverlay())

						if launchApp then
							launchApp()
						end
					end
				end, function(p3) -- line: 45
					-- upvalues: isMounted (copy), Logger (copy), onError (copy)
					if isMounted.current then
						Logger:warning("Login failed:" .. p3)
						onError()
					end
				end)
			end

			if p1.Status == PollMagicLoginStatusType.EXPIRED or p1.Status == PollMagicLoginStatusType.CANCELLED then
				if isMounted.current then
					onError()

					return
				end
			else
				spawn(function() -- line: 60
					-- upvalues: isMounted (copy), retriesLeft (copy), networking (copy), deviceCode (copy), privateKey (copy), launchApp (copy), onError (copy), store (copy), pollLoginStatus (copy)
					wait(2)

					if isMounted.current and retriesLeft > 0 then
						local t2 = {
							networking = networking,
							deviceCode = deviceCode,
							privateKey = privateKey,
							isMounted = isMounted,
							launchApp = launchApp,
							onError = onError,
							retriesLeft = retriesLeft - 1,
							store = store
						}

						pollLoginStatus(t2)

						return
					end

					if isMounted.current then
						onError()
					end
				end)
			end
		end
	end, function(p4) -- line: 80
		-- upvalues: isMounted (copy), PollMagicLoginStatusType (copy), onError (copy), retriesLeft (copy), networking (copy), deviceCode (copy), privateKey (copy), launchApp (copy), store (copy), pollLoginStatus (copy)
		if isMounted.current then
			if p4.Body == PollMagicLoginStatusType.CODE_INVALID then
				onError()

				return
			end

			spawn(function() -- line: 85
				-- upvalues: isMounted (copy), retriesLeft (copy), networking (copy), deviceCode (copy), privateKey (copy), launchApp (copy), onError (copy), store (copy), pollLoginStatus (copy)
				wait(2)

				if isMounted.current and retriesLeft > 0 then
					local t3 = {
						networking = networking,
						deviceCode = deviceCode,
						privateKey = privateKey,
						isMounted = isMounted,
						launchApp = launchApp,
						onError = onError,
						retriesLeft = retriesLeft - 1,
						store = store
					}

					pollLoginStatus(t3)

					return
				end

				if isMounted.current then
					onError()
				end
			end)
		end
	end)
end

return function(p5, s1: string, s2: string, t4: {[any]: any}, p6: ((...any) -> ...any)?, p7: ((...any) -> ...any)) -- line: 108
	-- upvalues: pollLoginStatus (copy)
	return function(p8) -- line: 116
		-- upvalues: p5 (copy), s1 (copy), s2 (copy), t4 (copy), p6 (copy), p7 (copy), pollLoginStatus (copy)
		local t5 = {
			retriesLeft = 50,
			networking = p5,
			deviceCode = s1,
			privateKey = s2,
			isMounted = t4,
			launchApp = p6,
			onError = p7,
			store = p8
		}

		return pollLoginStatus(t5)
	end
end
