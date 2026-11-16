local module = require("@luauforge/bundled/fHp")

local module2 = require("@luauforge/bundled/fHq")

local module3 = require("@luauforge/bundled/fHr")
local module4 = require("@luauforge/bundled/fHs")

local v5 = { cancelled = true, unavailable = true, failed = true, busy = true }

local v6 = {
	cancelled = true,
	GetCredentialCancellationException = true,
	["androidx.credentials.exceptions.GetCredentialCancellationException"] = true
}

local v7 = {}

local function sanitizeNativeErrorClass(value)
	if typeof(value) == "string" and not (#value > 64) and string.match(value, "^%a[%w_%.]*$") ~= nil then
		return value
	end

	return nil
end

local function findEngineService()
	local success, service = pcall(game.GetService, game, "ExternalIdentityService")

	if success then
		return service
	end

	return nil
end

return {
	create = function(data)
		local service = data.service

		if not service then
			local success
			success, service = pcall(game.GetService, game, "ExternalIdentityService")

			if not success then
				service = nil
			end
		end

		local requests = data.requests or module4.default
		local flag = false

		return {
			getCapabilitiesAsync = function()
				local success, result = pcall(function()
					return service:GetCapabilitiesAsync()
				end)

				local v8 = success and typeof(result) == "table"
				return {
					google = v8 and result.google == true,
					apple = v8 and result.apple == true
				}
			end,
			authenticate = function(p2)
				if flag then
					return {
						promise = module.resolve({ provider = p2, status = "busy" }),
						cancel = function() end
					}
				end

				flag = true

				local flag2 = false
				local flag3 = false
				local v8 = false
				local v9 = false
				local fn = nil
				local v10 = nil
				local v11 = module.new(function(p3)
					v10 = p3
				end)

				local function finish(p3, p4)
					if flag2 then
						return
					end

					flag2 = true
					flag = false
					v10({ provider = p2, status = p3, errorClass = p4 })
				end

				local function track(object, p3)
					fn = function()
						object:cancel()
					end
					return object:andThen(function(p4)
						fn = nil

						if flag3 then
							return (module.reject(v7))
						end

						return p4
					end, function()
						fn = nil
						return module.reject(if flag3 then v7 else { errorClass = p3 })
					end)
				end

				local function completeSession()
					return module.try(data.completeSession):andThen(function(p3)
						if p3 == nil then
							return (module.reject({ errorClass = "session" }))
						end

						return nil
					end, function()
						return module.reject({ errorClass = "session" })
					end)
				end

				local function redeemTicket(p3)
					v8 = true
					return module.try(data.redeemTicket, p3):andThen(completeSession, function()
						return module.reject({ errorClass = "ticket" })
					end)
				end

				local function acquireProof(p3, p4)
					fn = function()
						pcall(function()
							service:CancelActiveOperation()
						end)
					end
					v9 = true
					local success, result, v12 = pcall(function()
						if p4 then
							return service:AcquireProofAsync(p2, nil, p4)
						end

						return service:AcquireProofAsync(p2, p3)
					end)

					v9 = false
					fn = nil

					if success then
						success = typeof(result) == "table" and result.provider == p2
					end

					if
						success
						and result.status == "success"
						and result.proofType == "sessionEstablished"
					then
						v8 = true
						return completeSession()
					end

					if flag3 then
						return module.reject(v7)
					end

					if success and v5[result.status] then
						if module2 and result.status == "failed" and v6[result.errorClass] then
							return module.reject({ status = "cancelled" })
						end

						if not module3 or result.status ~= "failed" then
							return module.reject({ status = result.status })
						end

						local reject = module.reject
						local v13 = { status = result.status, errorClass = 0 }
						local errorClass = result.errorClass

						if
							typeof(errorClass) ~= "string"
							or #errorClass > 64
							or string.match(errorClass, "^%a[%w_%.]*$") == nil
						then
							errorClass = nil
						end

						v13.errorClass = errorClass
						return reject(v13)
					elseif
						success
						and result.status == "success"
						and result.proofType == "idToken"
						and v12
					then
						return track(requests.exchangeIdToken(v12), "access"):andThen(redeemTicket)
					else
						return module.reject({ errorClass = "proof" })
					end
				end

				local v12 = if requests.browserStartUrl then requests.browserStartUrl(p2) else nil
				module.try(function()
					if v12 then
						return module.defer(function(callback)
							callback(nil)
						end):andThen(function()
							if flag3 then
								return (module.reject(v7))
							end

							return (acquireProof(nil, v12))
						end)
					end

					return track(requests.requestNonce(p2), "nonce"):andThen(acquireProof)
				end):andThen(function()
					if flag2 then
						return
					end

					flag2 = true
					flag = false
					v10({ provider = p2, status = "success", errorClass = nil })
				end, function(p3)
					if p3 == v7 then
						if flag2 then
							return
						end

						flag2 = true
						flag = false
						v10({ provider = p2, status = "cancelled", errorClass = nil })
					elseif typeof(p3) == "table" and p3.status then
						local status = p3.status
						local errorClass = p3.errorClass

						if flag2 then
							return
						end

						flag2 = true
						flag = false
						v10({ provider = p2, status = status, errorClass = errorClass })
					else
						local v13 = typeof(p3) ~= "table" and "unknown" or p3.errorClass

						if flag2 then
							return
						end

						flag2 = true
						flag = false
						v10({ provider = p2, status = "failed", errorClass = v13 })
					end
				end)

				return {
					promise = v11,
					cancel = function()
						if flag2 or v8 then
							return
						end

						flag3 = true

						if fn then
							fn()
						end

						if not v9 then
							if flag2 then
								return
							end

							flag2 = true
							flag = false
							v10({
								provider = p2,
								status = "cancelled",
								errorClass = nil
							})
						end
					end
				}
			end
		}
	end
}
