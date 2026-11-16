local getFStringPioneerLaunchPlaceId = require("@game/CorePackages/Workspace/Packages/_Workspace/PioneerUtils/SharedFlags").GetFStringPioneerLaunchPlaceId

local engineFeature = game:GetEngineFeature("PioneerDataModelApi")

local v5 = {}

function v5.isPioneerApp(): boolean
	if engineFeature then
		return game:IsPioneerApp() == true
	end

	return false
end

function v5.getPioneerSource()
	if engineFeature then
		return game:GetPioneerSource()
	end

	return nil
end

function v5.isDaveyBazooka()
	local success, result = pcall(function(): boolean
		return v5.getPioneerSource() == Enum.PioneerSource.DaveyBazooka
	end)

	return success and result
end

function v5.getPioneerRootPlaceId()
	local fStringPioneerLaunchPlaceId = getFStringPioneerLaunchPlaceId()

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

return v5
