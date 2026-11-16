local HttpService = game:GetService("HttpService")
local parent = script.Parent.Parent
local parent2 = parent.Parent
local dependencies = require(parent.dependencies)
local promise = dependencies.Promise
local urlBuilder = dependencies.UrlBuilder
local urlBase = dependencies.UrlBase
local fetch = dependencies.Fetch
local fetch2 = fetch.fetch
local response = fetch.Response
local UserSetting = require(parent.Enums.UserSetting)

local SharedFlags = require(parent2.SharedFlags)
local FFlagLuaAppSduiUpdateUserSettingsAction = SharedFlags.FFlagLuaAppSduiUpdateUserSettingsAction

local v = urlBuilder.new({ base = urlBase.APIS, path = "user-settings-api/v1/user-settings" })

local v2 = urlBuilder.new({ base = urlBase.APIS, path = "user-settings-api/v2/user-settings" })

local function updateUserSettings(items, rbxauditdata: string?)
	for k, _ in items do
		if not UserSetting[k] then
			return promise.reject(`Invalid setting name: {k}`)
		end
	end

	local v3 = v()
	return promise.new(function(callback, callback2)
		local success, result = pcall(function()
			return fetch2(v3, {
				method = "POST",
				body = HttpService:JSONEncode(items),
				headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json",
					["rbx-audit-data"] = rbxauditdata
				}
			}):catch(function(_)
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

local UserSettingsService = {
	updateUserSetting = function(p: string, p2, rbxauditdata: string)
		local v3 = v()
		return promise.new(function(callback, callback2)
			local success, result = pcall(function()
				return fetch2(v3, {
					method = "POST",
					body = HttpService:JSONEncode({ [p] = p2 }),
					headers = {
						["Content-Type"] = "application/json",
						Accept = "application/json",
						["rbx-audit-data"] = rbxauditdata
					}
				}):catch(function(_)
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

if not FFlagLuaAppSduiUpdateUserSettingsAction then
	updateUserSettings = nil
end

UserSettingsService.updateUserSettings = updateUserSettings

function UserSettingsService.updateUserSettingV2(p: string, p2, rbxauditdata: string)
	if UserSetting[p] then
		local v3 = v2()
		return promise.new(function(callback, callback2)
			local success, result = pcall(function()
				return fetch2(v3, {
					method = "POST",
					body = HttpService:JSONEncode({ [p] = p2 }),
					headers = {
						["Content-Type"] = "application/json",
						Accept = "application/json",
						["rbx-audit-data"] = rbxauditdata
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

	local v3 = { message = `Invalid setting name: {p}` }
	return promise.reject(v3)
end
return UserSettingsService
