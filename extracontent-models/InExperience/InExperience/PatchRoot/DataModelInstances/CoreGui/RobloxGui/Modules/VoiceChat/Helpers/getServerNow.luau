local CorePackages = game:GetService("CorePackages")

local MockableProxyServices = require(CorePackages.Workspace.Packages.MockableProxyServices)

local function getServerNow()
	local success, result = pcall(function()
		return MockableProxyServices.Workspace:GetServerTimeNow()
	end)

	if success then
		return result
	end

	return DateTime.now().UnixTimestamp
end

return getServerNow
