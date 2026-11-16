local DataHydration = script:FindFirstAncestor("DataHydration")

local HttpService = game:GetService("HttpService")

local DataHydrationTypes = require(DataHydration.DataHydrationTypes)
local DataStatus = DataHydrationTypes.DataStatus
local TestHelpers = {}

function TestHelpers.jsonOk(p)
	return { statusCode = 200, responseBody = HttpService:JSONEncode(p) }
end

function TestHelpers.awaitReady(p, value: number?)
	local v = os.clock() + (value or 3)

	while p.status(false) == DataStatus.NotReady and not (v < os.clock()) do
		task.wait()
	end
end

return TestHelpers
