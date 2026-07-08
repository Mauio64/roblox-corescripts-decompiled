local DataHydration = script:FindFirstAncestor("DataHydration")
local HttpService = game:GetService("HttpService")
local DataStatus = require(DataHydration.DataHydrationTypes).DataStatus

return {
	jsonOk = function(p1) -- line: 11
		-- upvalues: HttpService (copy)
		return {
			statusCode = 200,
			responseBody = HttpService:JSONEncode(p1)
		}
	end,
	awaitReady = function(p2, n1: number?) -- line: 15
		-- upvalues: DataStatus (copy)
		local v7 = os.clock() + (n1 or 3)

		while p2.status(false) == DataStatus.NotReady and not (v7 < os.clock()) do
			task.wait()
		end
	end
}
