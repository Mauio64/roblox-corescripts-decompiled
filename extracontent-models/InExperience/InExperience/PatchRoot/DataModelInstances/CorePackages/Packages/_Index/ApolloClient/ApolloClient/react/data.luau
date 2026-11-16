local OperationData = require(script.OperationData)
local Data = {}

Data.OperationData = OperationData.OperationData
local MutationData = require(script.MutationData)
Data.MutationData = MutationData.MutationData

local QueryData = require(script.QueryData)
Data.QueryData = QueryData.QueryData

return Data
