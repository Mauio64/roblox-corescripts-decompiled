local HttpService = game:GetService("HttpService")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/dependencies")
local promise = dependencies.Promise
local urlBuilder = dependencies.UrlBuilder
local urlBase = dependencies.UrlBase
local fetch = dependencies.Fetch
local fetch2 = fetch.fetch
local response = fetch.Response
local UserSetting = require("@game/CorePackages/Workspace/Packages/_Index/LegallySensitiveContent/LegallySensitiveContent/Enums/UserSetting")

local fFlagLuaAppSduiUpdateUserSettingsAction = require("@game/CorePackages/Workspace/Packages/_Workspace/LegallySensitiveContent/SharedFlags").FFlagLuaAppSduiUpdateUserSettingsAction

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "user-settings-api/v1/user-settings"
})

local v6 = urlBuilder.new({
	base = urlBase.APIS,
	path = "user-settings-api/v2/user-settings"
})

local function updateUserSettings(items, p2)
	for k, item in items do
		if not UserSetting[k] then
			return promise.reject(`Invalid setting name: {k}`)
		end
	end

	local v7 = v5()
	return promise.new(function(callback, callback2)
		local success, result = pcall(function()
			return fetch2(v7, {
				method = "POST",
				body = HttpService:JSONEncode(items),
				headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json",
					["rbx-audit-data"] = p2
				}
			}):catch(function(p3)
				return response.error()
			end):expect()
		end)

		if not (success and result) then
			callback2(`Failed to make request: {result}`)
		elseif result.ok then
			callback(result)
		else
			callback2(`Got update user setting HTTP Response: {result.status} - {result.statusText}`)
		end
	end)
end

local v7 = {
	updateUserSetting = function(p2, p3, p4)
		local v8 = v5()
		return promise.new(function(callback, callback2)
			local success, result = pcall(function()
				return fetch2(v8, {
					method = "POST",
					body = HttpService:JSONEncode({ [p2] = p3 }),
					headers = {
						["Content-Type"] = "application/json",
						Accept = "application/json",
						["rbx-audit-data"] = p4
					}
				}):catch(function(p5)
					return response.error()
				end):expect()
			end)

			if not success then
				callback2("Failed to make request: " .. tostring(result))
			elseif result.ok then
				callback()
			else
				callback2((string.format(
					"Got update user setting HTTP Response: %d - %s",
					result.status,
					result.statusText
				)))
			end
		end)
	end,
	updateUserSettings = 0,
	updateUserSettingV2 = 0
}

if not fFlagLuaAppSduiUpdateUserSettingsAction then
	updateUserSettings = nil
end

v7.updateUserSettings = updateUserSettings

function v7.updateUserSettingV2(p2, p3, p4)
	if UserSetting[p2] then
		local v7 = v6()
		return promise.new(function(callback, callback2)
			local success, result = pcall(function()
				return fetch2(v7, {
					method = "POST",
					body = HttpService:JSONEncode({ [p2] = p3 }),
					headers = {
						["Content-Type"] = "application/json",
						Accept = "application/json",
						["rbx-audit-data"] = p4
					}
				}):catch(function()
					return response.error()
				end):expect()
			end)

			if not (success and result) then
				callback2({
					message = `Failed to make request: {result}`
				})
			elseif result.ok then
				callback()
			else
				callback2({
					statusCode = result.status,
					message = `Got update user setting HTTP Response: {result.status} - {result.statusText}`
				})
			end
		end)
	end

	local v7 = { message = `Invalid setting name: {p2}` }
	return promise.reject(v7)
end
return v7
