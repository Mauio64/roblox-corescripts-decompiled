local HttpService = game:GetService("HttpService")
local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local UrlBuilder = require(SquadsCoreParent.UrlBuilder)
local t = require(SquadsCoreParent.t)
local Logger = require(SquadsCore.Logger)
local ScheduledSquadModel = require(SquadsCore.Models.ScheduledSquadModel)
local serializeTable = require(SquadsCore.Utils.serializeTable)

require(SquadsCore.Types)

local UrlBuilder2 = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase
local v11 = t.strictInterface({
	scheduledGroupUpId = t.number,
	title = t.string,
	startTime = t.string
})
local v12 = UrlBuilder2.new({
	path = "group-up/v1/update-scheduled-group-up",
	base = UrlBase.APIS
})()

return function(t1: {[any]: any}, p1: ((...any) -> ...any), p2) -- line: 36
	-- upvalues: v11 (copy), HttpService (copy), v12 (copy), ScheduledSquadModel (copy), Logger (copy), serializeTable (copy)
	assert(v11(t1))

	return HttpService:RequestInternal({
		Method = "POST",
		Body = HttpService:JSONEncode({
			scheduledGroupUpId = t1.scheduledGroupUpId,
			title = t1.title,
			startTime = t1.startTime
		}),
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		},
		Url = v12
	}):Start(function(_, p4) -- line: 57
		-- upvalues: p1 (copy), ScheduledSquadModel (copy), HttpService (copy), Logger (copy), serializeTable (copy), p2 (copy)
		if p4.StatusCode == 200 then
			local Body = p4.Body

			if p1 then
				p1(ScheduledSquadModel.format(HttpService:JSONDecode(Body)))
			end

			Logger:debug("Response: {}", serializeTable(Body))

			return p4
		end

		if p2 then
			p2()
		end

		Logger:error("Error updating scheduled squad: {}", p4.StatusMessage)

		return p4
	end)
end
