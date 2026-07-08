local HttpService = game:GetService("HttpService")
local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local UrlBuilder = require(SquadsCoreParent.UrlBuilder)
local Logger = require(SquadsCore.Logger)
local serializeTable = require(SquadsCore.Utils.serializeTable)

require(SquadsCore.Types)

local UrlBuilder2 = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

return function(n1: number, p1: ((...any) -> ...any)?, p2: ((...any) -> ...any)?) -- line: 17
	-- upvalues: UrlBuilder2 (copy), UrlBase (copy), HttpService (copy), Logger (copy), serializeTable (copy)
	local v12 = UrlBuilder2.new({
		path = "group-up/v1/get-scheduled-group-up-status",
		base = UrlBase.APIS,
		query = {
			scheduledGroupUpId = n1
		}
	})()

	return HttpService:RequestInternal({
		Method = "GET",
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		},
		Url = v12
	}):Start(function(_, p4) -- line: 38
		-- upvalues: p1 (copy), HttpService (copy), Logger (copy), serializeTable (copy), p2 (copy)
		if p4.StatusCode == 200 then
			local Body = p4.Body

			if p1 then
				p1(HttpService:JSONDecode(Body).scheduledGroupUp)
			end

			Logger:debug("Response: {}", serializeTable(Body))

			return p4
		end

		if p2 then
			p2()
		end

		Logger:error("Error getting scheduled squad status: {}", p4.StatusMessage)

		return p4
	end)
end
