local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local SetEmoteAssetId = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.SetEmoteAssetId)
local SetFieldOfViewDeg = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.SetFieldOfViewDeg)
local SetLastSuccessfulPoseEmoteAssetId = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.SetLastSuccessfulPoseEmoteAssetId)
local CompletePPEEmoteLoading = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.CompletePPEEmoteLoading)
local StartPPEEmoteLoading = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.StartPPEEmoteLoading)
local IncrementPPEVersion = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.IncrementPPEVersion)
local PPEThumbnailType = require(Modules.AvatarExperience.ProfilePictureEditor.PPEThumbnailType)
local mutedError = require(Modules.LuaApp.mutedError)

return Rodux.createReducer({
	lastSuccessfulPoseEmoteAssetId = nil,
	emoteAssetId = nil,
	fieldOfViewDeg = nil,
	ppeEmoteLoadingCount = 0,
	ppeVersion = {
		[PPEThumbnailType.Closeup] = 0,
		[PPEThumbnailType.FullBody] = 0
	}
}, {
	[StartPPEEmoteLoading.name] = function(t1: {[any]: any}, _) -- line: 47
		-- upvalues: Cryo (copy)
		local v15 = t1.ppeEmoteLoadingCount + 1

		return Cryo.Dictionary.join(t1, {
			ppeEmoteLoadingCount = v15
		})
	end,
	[CompletePPEEmoteLoading.name] = function(t2: {[any]: any}, _) -- line: 54
		-- upvalues: mutedError (copy), Cryo (copy)
		local v18 = t2.ppeEmoteLoadingCount - 1

		if v18 < 0 then
			mutedError("newPPEEmoteLoadingCount is less than 0")
		end

		return Cryo.Dictionary.join(t2, {
			ppeEmoteLoadingCount = v18
		})
	end,
	[SetLastSuccessfulPoseEmoteAssetId.name] = function(t3: {[any]: any}, p3) -- line: 64
		-- upvalues: Cryo (copy)
		local v21 = p3.lastSuccessfulPoseEmoteAssetId or Cryo.None

		return Cryo.Dictionary.join(t3, {
			lastSuccessfulPoseEmoteAssetId = v21
		})
	end,
	[SetEmoteAssetId.name] = function(t4: {[any]: any}, p4) -- line: 73
		-- upvalues: Cryo (copy)
		local v24 = p4.emoteAssetId or Cryo.None

		return Cryo.Dictionary.join(t4, {
			emoteAssetId = v24
		})
	end,
	[SetFieldOfViewDeg.name] = function(t5: {[any]: any}, p5) -- line: 79
		-- upvalues: Cryo (copy)
		local v27 = p5.fieldOfViewDeg or Cryo.None

		return Cryo.Dictionary.join(t5, {
			fieldOfViewDeg = v27
		})
	end,
	[IncrementPPEVersion.name] = function(t6: {[any]: any}, p6) -- line: 85
		-- upvalues: Cryo (copy)
		local v30 = Cryo.Dictionary.join(t6.ppeVersion, {
			[p6.thumbnailType] = t6.ppeVersion[p6.thumbnailType] + 1
		})

		return Cryo.Dictionary.join(t6, {
			ppeVersion = v30
		})
	end
})
