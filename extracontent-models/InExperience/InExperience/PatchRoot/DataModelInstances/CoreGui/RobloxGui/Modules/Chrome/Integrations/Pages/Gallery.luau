local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")

local Service = require(Chrome.Service)
local CommonIcon = require(Chrome.Integrations.CommonIcon)

local CapturesInExperience = require(CorePackages.Workspace.Packages.CapturesInExperience)
local CapturesPolicy = CapturesInExperience.CapturesPolicy
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagFixSpatialUICaptures = SharedFlags.FFlagFixSpatialUICaptures

local defineFastFlag = game:DefineFastFlag("UpdateGalleryIcon", false)

local InGameMenuIntegrationUtils = require(script.Parent.InGameMenuIntegrationUtils)

local v = CapturesPolicy.PolicyImplementation.read()
local v2

if v then
	v2 = CapturesPolicy.Mapper(v).eligibleForCapturesFeature()
else
	v2 = false
end

local v3 = v2 and (not (isInExperienceUIVREnabled and FFlagFixSpatialUICaptures) or not isSpatial())

if not v3 then
	return nil
end

local pageOpenSignal = InGameMenuIntegrationUtils.createPageOpenSignal("CapturesPage")
local initialAvailability

if v3 then
	initialAvailability = Service.AvailabilitySignal.Available
else
	initialAvailability = Service.AvailabilitySignal.Unavailable
end

return Service:register({
	initialAvailability = initialAvailability,
	id = "gallery",
	label = "Feature.Captures.Title.Gallery",
	sideSheetPlacement = SideSheetPlacement.BelowFold,
	activated = function(_)
		InGameMenuIntegrationUtils.toggleIGMPage("CapturesPage", pageOpenSignal:get())
	end,
	isActivated = pageOpenSignal,
	components = {
		Icon = function(_)
			if defineFastFlag then
				return CommonIcon("Image", nil, pageOpenSignal)
			end

			return CommonIcon("icons/controls/cameraOff", "icons/controls/cameraOn", pageOpenSignal)
		end
	}
})
