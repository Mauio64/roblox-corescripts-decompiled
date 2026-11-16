local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local HttpService = game:GetService("HttpService")
local Promise = require(parent.Promise)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase

local url = urlBuilder.new({
	base = UrlBase.APIS,
	path = "modals-api/v1/prompts",
	query = { entryPoint = "SelfUserProfileOpen" }
})()

local function fetchFramesPromptId()
	return Promise.new(function(callback, callback2)
		HttpService:RequestInternal({ Url = url, Method = "GET" }):Start(function(p, p2)
			if not p or not p2 or p2.StatusCode ~= 200 then
				callback2()
				return
			end

			local v = p2.Body

			if typeof(v) == "string" then
				local success, result = pcall(function()
					return HttpService:JSONDecode(v)
				end)

				if success then
					v = result
				else
					callback2()
					return
				end
			end

			local pageEntries = v and (v.pageEntries or v.page_entries)

			if not pageEntries then
				callback2()
				return
			end

			for _, pageEntry in pageEntries do
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
