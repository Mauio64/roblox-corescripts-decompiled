local parent = script:FindFirstAncestor("PioneerUtils").Parent

local SharedFlags = require(parent.SharedFlags)
local GetFStringPioneerLaunchPlaceId = SharedFlags.GetFStringPioneerLaunchPlaceId

local engineFeature = game:GetEngineFeature("PioneerDataModelApi")

local PioneerInfo = {}

function PioneerInfo.isPioneerApp(): boolean
	if engineFeature then
		return game:IsPioneerApp() == true
	end

	return false
end

function PioneerInfo.getPioneerSource()
	if engineFeature then
		return game:GetPioneerSource()
	end

	return nil
end

function PioneerInfo.isDaveyBazooka()
	local success, result = pcall(function(): boolean
		return PioneerInfo.getPioneerSource() == Enum.PioneerSource.DaveyBazooka
	end)

	return success and result
end

function PioneerInfo.getPioneerRootPlaceId()
	local fStringPioneerLaunchPlaceId = GetFStringPioneerLaunchPlaceId()

	if fStringPioneerLaunchPlaceId then
		return fStringPioneerLaunchPlaceId
	end

	if not engineFeature then
		return nil
	end

	local pioneerRootPlaceId = game:GetPioneerRootPlaceId()

	if type(pioneerRootPlaceId) == "number" and not (pioneerRootPlaceId <= 0) then
		return pioneerRootPlaceId
	end

	return nil
end

return PioneerInfo
