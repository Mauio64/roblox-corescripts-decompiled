local Parent = script:FindFirstAncestor("MomentsCommon").Parent
local IXPService = game:GetService("IXPService")
local useUserExperiment = require(Parent.RoactAppExperiment).useUserExperiment

game:DefineFastString("ArgusExperimentLayer", "Social.MomentsMigration")

local FastString = game:GetFastString("ArgusExperimentLayer")

game:DefineFastString("ArgusEntryTypeKey", "entryType")

local FastString2 = game:GetFastString("ArgusEntryTypeKey")

game:DefineFastString("ArgusPlatformIntegrationKey", "platformIntegration")

local FastString3 = game:GetFastString("ArgusPlatformIntegrationKey")

game:DefineFastString("ArgusInfluencerUploadsKey", "influencerUploads")

local FastString4 = game:GetFastString("ArgusInfluencerUploadsKey")
local t1 = {
	platformIntegration = false,
	influencerUploads = false
}

local function getExperimentConfig(p1) -- line: 39
	-- upvalues: FastString (copy), FastString2 (copy), t1 (copy), FastString3 (copy), FastString4 (copy)
	local v11 = (p1 or {})[FastString] or {}
	local v12 = v11[FastString2]

	if v12 ~= "flyout" and v12 ~= "tab" then
		return t1
	end

	return {
		entryType = v12,
		platformIntegration = v11[FastString3] == true,
		influencerUploads = v11[FastString4] == true
	}
end

return {
	ExperimentLayer = FastString,
	getExperimentConfig = getExperimentConfig,
	getCurrentExperimentConfig = function() -- line: 53
		-- upvalues: IXPService (copy), FastString (copy), t1 (copy), getExperimentConfig (copy)
		local ok, result = pcall(function() -- line: 54
			-- upvalues: IXPService (copy), FastString (copy)
			return IXPService:GetUserLayerVariables(FastString)
		end)

		if not ok then
			return t1
		end

		return (getExperimentConfig({
			[FastString] = result
		}))
	end,
	useExperimentConfig = function(t2: {[any]: any}?) -- line: 72
		-- upvalues: useUserExperiment (copy), FastString (copy), getExperimentConfig (copy)
		return useUserExperiment({ FastString }, getExperimentConfig, if not t2 then nil else t2.isExposureEnabled)
	end,
	logExposure = function() -- line: 80
		-- upvalues: IXPService (copy), FastString (copy)
		IXPService:LogUserLayerExposure(FastString)
	end
}
