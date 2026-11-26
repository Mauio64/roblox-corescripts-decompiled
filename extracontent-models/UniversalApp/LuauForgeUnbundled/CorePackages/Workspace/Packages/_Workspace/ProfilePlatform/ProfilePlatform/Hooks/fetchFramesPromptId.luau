local HttpService = game:GetService("HttpService")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Promise")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UrlBuilder").UrlBase

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "modals-api/v1/prompts",
	query = { entryPoint = "SelfUserProfileOpen" }
})()

local function fetchFramesPromptId()
	return Promise.new(function(callback, callback2)
		HttpService:RequestInternal({ Url = v5, Method = "GET" }):Start(function(p2, p3)
			if not p2 or not p3 or p3.StatusCode ~= 200 then
				callback2()
				return
			end

			local v6 = p3.Body

			if typeof(v6) == "string" then
				local success, result = pcall(function()
					return HttpService:JSONDecode(v6)
				end)

				if success then
					v6 = result
				else
					callback2()
					return
				end
			end

			local pageEntries = v6 and (v6.pageEntries or v6.page_entries)

			if not pageEntries then
				callback2()
				return
			end

			for k, pageEntry in pageEntries do
				local pageEntry2 = pageEntry.pageEntry or pageEntry.page_entry

				if (pageEntry2 and (pageEntry2.robloxComponent or pageEntry2.roblox_component)) ~= "ProfileCompletionCardCarousel" then
					continue
				end

				local identifier = pageEntry2.identifier

				if identifier and identifier ~= "" then
					callback(identifier)
					return
				end
			end

			callback2()
		end)
	end)
end

return fetchFramesPromptId
