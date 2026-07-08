local HttpService = game:GetService("HttpService")
local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local UrlBuilder = require(SquadsCoreParent.UrlBuilder)
local t = require(SquadsCoreParent.t)
local Logger = require(SquadsCore.Logger)
local serializeTable = require(SquadsCore.Utils.serializeTable)
local UrlBuilder2 = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase
local v10 = t.strictInterface({
	scheduledGroupUpId = t.number
})
local v11 = UrlBuilder2.new({
	path = "group-up/v1/subscribe-to-scheduled-group-up",
	base = UrlBase.APIS
})()

return function(t1: {[any]: any}, p1: ((...any) -> ...any)?, p2: ((...any) -> ...any)?) -- line: 28
	-- upvalues: v10 (copy), HttpService (copy), v11 (copy), Logger (copy), serializeTable (copy)
	assert(v10(t1))

	return HttpService:RequestInternal({
		Method = "POST",
		Body = HttpService:JSONEncode({
			scheduledGroupUpId = t1.scheduledGroupUpId
		}),
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		},
		Url = v11
	}):Start(function(_, p4) -- line: 47
		-- upvalues: p1 (copy), HttpService (copy), Logger (copy), serializeTable (copy), p2 (copy), t1 (copy)
		if p4.StatusCode == 200 then
			local Body = p4.Body

			if p1 then
				p1(HttpService:JSONDecode(Body))
			end

			Logger:debug("Response: {}", serializeTable(Body))

			return p4
		end

		if p2 then
			p2()
		end

		Logger:error("Error subscribing to scheduledSquadId: {}. Status: {}", t1.scheduledGroupUpId, p4.StatusMessage)

		return p4
	end)
end
