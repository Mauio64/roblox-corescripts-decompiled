local engineFeature = game:GetEngineFeature("CloudClientSessionApi")

local function getCloudClientService(p)
	if not engineFeature then
		return nil
	end

	local CloudClientService = (p or game):GetService("CloudClientService")
	return CloudClientService
end

return getCloudClientService
