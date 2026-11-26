local engineFeature = game:GetEngineFeature("CloudClientSessionApi")

local function getCloudClientService(p2)
	if not engineFeature then
		return nil
	end

	local CloudClientService = (p2 or game):GetService("CloudClientService")
	return CloudClientService
end

return getCloudClientService
