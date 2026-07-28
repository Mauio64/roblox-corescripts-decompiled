local CorePackages = game:GetService("CorePackages")
local ok, result = pcall(function() -- line: 3
	-- upvalues: CorePackages (copy)
	return require(CorePackages.Workspace.Packages.DataModelStreaming)
end)

if not ok or type(result) ~= "table" then
	return
end

local initDataModelStreamWsClient = result.initDataModelStreamWsClient

if type(initDataModelStreamWsClient) ~= "function" then
	return
end

initDataModelStreamWsClient("experience")
