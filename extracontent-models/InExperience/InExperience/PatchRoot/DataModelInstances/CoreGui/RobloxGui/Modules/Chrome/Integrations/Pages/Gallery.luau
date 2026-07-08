local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local Service = require(Chrome.Service)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local CapturesPolicy = require(CorePackages.Workspace.Packages.CapturesInExperience).CapturesPolicy
local SideSheetPlacement = require(CorePackages.Workspace.Packages.Chrome).Enums.SideSheetPlacement
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagFixSpatialUICaptures = SharedFlags.FFlagFixSpatialUICaptures
local FFlagChromeActivatedMappedSignal = SharedFlags.FFlagChromeActivatedMappedSignal
local InGameMenuIntegrationUtils = require(script.Parent.InGameMenuIntegrationUtils)
local v13 = CapturesPolicy.PolicyImplementation.read()
local v14 = not not v13 and CapturesPolicy.Mapper(v13).eligibleForCapturesFeature()
local v15 = isInExperienceUIVREnabled and FFlagFixSpatialUICaptures
local v16 = v14 and (not v15 or not isSpatial())

if not v16 then
	return nil
end

local v17 = InGameMenuIntegrationUtils.createPageOpenSignal("CapturesPage")

return Service:register({
	id = "gallery",
	label = "Feature.Captures.Title.Gallery",
	initialAvailability = if not v16 then Service.AvailabilitySignal.Unavailable else Service.AvailabilitySignal.Available,
	sideSheetPlacement = SideSheetPlacement.Page,
	activated = function(_) -- line: 37
		-- upvalues: InGameMenuIntegrationUtils (copy), v17 (copy)
		InGameMenuIntegrationUtils.toggleIGMPage("CapturesPage", v17:get())
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 42
		-- upvalues: v17 (copy)
		return v17:get()
	end or v17,
	components = {
		Icon = function(_) -- line: 46
			-- upvalues: CommonIcon (copy), v17 (copy)
			return CommonIcon("icons/controls/cameraOff", "icons/controls/cameraOn", v17)
		end
	}
})
