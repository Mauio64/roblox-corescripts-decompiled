local HttpService = game:GetService("HttpService")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local dependencies = require(ParentParent.dependencies)
local Promise = dependencies.Promise
local UrlBuilder = dependencies.UrlBuilder
local UrlBase = dependencies.UrlBase
local Fetch = dependencies.Fetch
local fetch = Fetch.fetch
local Response = Fetch.Response
local UserSetting = require(ParentParent.Enums.UserSetting)
local FFlagLuaAppSduiUpdateUserSettingsAction = require(ParentParentParent.SharedFlags).FFlagLuaAppSduiUpdateUserSettingsAction
local v13 = UrlBuilder.new({
	path = "user-settings-api/v1/user-settings",
	base = UrlBase.APIS
})

local function updateUserSettings(t1: {[any]: any}, s1: string?) -- line: 72
	-- upvalues: UserSetting (copy), Promise (copy), v13 (copy), fetch (copy), HttpService (copy), Response (copy)
	for v21, _ in t1 do
		if not UserSetting[v21] then
			return Promise.reject(`Invalid setting name: { v21 }`)
		end
	end

	local v23 = v13()

	return Promise.new(function(resolve, reject) -- line: 80
		-- upvalues: fetch (copy), v23 (copy), HttpService (copy), t1 (copy), s1 (copy), Response (copy)
		local ok, result = pcall(function() -- line: 81
			-- upvalues: fetch (copy), v23 (copy), HttpService (copy), t1 (copy), s1 (copy), Response (copy)
			return fetch(v23, {
				method = "POST",
				body = HttpService:JSONEncode(t1),
				headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json",
					["rbx-audit-data"] = s1
				}
			}):catch(function(_) -- line: 91
				-- upvalues: Response (copy)
				return Response.error()
			end):expect()
		end)

		if not ok or not result then
			reject(`Failed to make request: { result }`)

			return
		end

		if not result.ok then
			reject(`Got update user setting HTTP Response: { result.status } - { result.statusText }`)

			return
		end

		resolve(result)
	end)
end

return {
	updateUserSetting = function(s2: string, p2, s3: string) -- line: 28
		-- upvalues: v13 (copy), Promise (copy), fetch (copy), HttpService (copy), Response (copy)
		local v18 = v13()

		return Promise.new(function(resolve, reject) -- line: 30
			-- upvalues: fetch (copy), v18 (copy), HttpService (copy), s2 (copy), p2 (copy), s3 (copy), Response (copy)
			local ok, result = pcall(function() -- line: 31
				-- upvalues: fetch (copy), v18 (copy), HttpService (copy), s2 (copy), p2 (copy), s3 (copy), Response (copy)
				return fetch(v18, {
					method = "POST",
					body = HttpService:JSONEncode({
						[s2] = p2
					}),
					headers = {
						["Content-Type"] = "application/json",
						Accept = "application/json",
						["rbx-audit-data"] = s3
					}
				}):catch(function(_) -- line: 43
					-- upvalues: Response (copy)
					return Response.error()
				end):expect()
			end)

			if not ok then
				reject("Failed to make request: " .. tostring(result))

				return
			end

			if not result.ok then
				reject((string.format("Got update user setting HTTP Response: %d - %s", result.status, result.statusText)))

				return
			end

			resolve()
		end)
	end,
	updateUserSettings = if not FFlagLuaAppSduiUpdateUserSettingsAction then nil else updateUserSettings
}
