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
local v12 = game:DefineFastFlag("UpdateGalleryIcon", false)
local InGameMenuIntegrationUtils = require(script.Parent.InGameMenuIntegrationUtils)
local v14 = CapturesPolicy.PolicyImplementation.read()
local v15 = not not v14 and CapturesPolicy.Mapper(v14).eligibleForCapturesFeature()
local v16 = isInExperienceUIVREnabled and FFlagFixSpatialUICaptures
local v17 = v15 and (not v16 or not isSpatial())

if not v17 then
	return nil
end

local v18 = InGameMenuIntegrationUtils.createPageOpenSignal("CapturesPage")

return Service:register({
	id = "gallery",
	label = "Feature.Captures.Title.Gallery",
	initialAvailability = if not v17 then Service.AvailabilitySignal.Unavailable else Service.AvailabilitySignal.Available,
	sideSheetPlacement = SideSheetPlacement.Page,
	activated = function(_) -- line: 39
		-- upvalues: InGameMenuIntegrationUtils (copy), v18 (copy)
		InGameMenuIntegrationUtils.toggleIGMPage("CapturesPage", v18:get())
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 44
		-- upvalues: v18 (copy)
		return v18:get()
	end or v18,
	components = {
		Icon = function(_) -- line: 48
			-- upvalues: v12 (copy), CommonIcon (copy), v18 (copy)
			if v12 then
				return CommonIcon("Image", nil, v18)
			end

			return CommonIcon("icons/controls/cameraOff", "icons/controls/cameraOn", v18)
		end
	}
})
