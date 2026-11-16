local CorePackages = game:GetService("CorePackages")

local success, result = pcall(function()
	return require(CorePackages.Workspace.Packages.DataModelStreaming)
end)

if not success or type(result) ~= "table" then
	return
end

local initDataModelStreamWsClient = result.initDataModelStreamWsClient

if type(initDataModelStreamWsClient) ~= "function" then
	return
end

initDataModelStreamWsClient("experience")
