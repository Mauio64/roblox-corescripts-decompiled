local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local Constants = require(Modules.AvatarExperience.ProfilePictureEditor.Constants)
local PPEThumbnailType = require(Modules.AvatarExperience.ProfilePictureEditor.PPEThumbnailType)
local IncrementPPEVersion = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.IncrementPPEVersion)
local Utils = require(Modules.AvatarExperience.ProfilePictureEditor.Utils)
local mutedError = require(Modules.LuaApp.mutedError)
local reportAvatarEventCounterNoAnalyticsArgument = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).reportAvatarEventCounterNoAnalyticsArgument
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local GetFFlagEnableAvatarEditorServiceAPIErrorLogging = require(Modules.AvatarExperience.Flags.GetFFlagEnableAvatarEditorServiceAPIErrorLogging)

require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local t1 = {
	toastMessage = "Feature.Avatar.Message.FailedWritePPE",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local t2 = {
	toastMessage = "Feature.Avatar.Label.PPEFinishedToast",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

return function(p1, p2, p3, p4, p5, p6) -- line: 40
	-- upvalues: ArgCheck (copy), Constants (copy), PerformFetch (copy), PPEThumbnailType (copy), Promise (copy), Utils (copy), SetCurrentToastMessage (copy), t2 (copy), IncrementPPEVersion (copy), mutedError (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), t1 (copy), Logging (copy)
	ArgCheck.isType(p2, "userdata", "WritePPEConfig thunk expects thumbnailType to be a userdata")
	ArgCheck.isTypeOrNil(p3, "string", "WritePPEConfig thunk expects emoteAssetId to be a string or nil")
	ArgCheck.isType(p4, "number", "WritePPEConfig thunk expects cameraDistanceScale to be a number")
	ArgCheck.isType(p5, "number", "WritePPEConfig thunk expects cameraYRotDeg to be a number")
	ArgCheck.isType(p6, "number", "WritePPEConfig thunk expects fieldOfViewDeg to be a number")

	local v25 = Constants.PPEConfigWriteStatusKeys[p2]

	return function(p7, p8) -- line: 48
		-- upvalues: PerformFetch (copy), v25 (copy), p2 (copy), PPEThumbnailType (copy), p1 (copy), p4 (copy), p5 (copy), p3 (copy), Promise (copy), Utils (copy), p6 (copy), SetCurrentToastMessage (copy), t2 (copy), IncrementPPEVersion (copy), mutedError (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), t1 (copy), Logging (copy)
		local avatarEditorService = p8.avatarEditorService

		return PerformFetch.Single(v25, function(p9) -- line: 50
			-- upvalues: p2 (copy), PPEThumbnailType (copy), p1 (copy), p4 (copy), p5 (copy), p3 (copy), Promise (copy), Utils (copy), avatarEditorService (copy), p6 (copy), SetCurrentToastMessage (copy), t2 (copy), IncrementPPEVersion (copy), mutedError (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), t1 (copy), Logging (copy)
			if p2 == PPEThumbnailType.Closeup then
				p1.clickFinalSave(p2, p4 == 1 and p5 == 0, p3)
			end

			return Promise.new(function(resolve, _) -- line: 55
				-- upvalues: p3 (copy), Utils (copy), p2 (copy), avatarEditorService (copy), p4 (copy), p5 (copy), p6 (copy), PPEThumbnailType (copy), p9 (copy), SetCurrentToastMessage (copy), t2 (copy), IncrementPPEVersion (copy), mutedError (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), t1 (copy), Logging (copy)
				local v32 = p3 and tonumber(p3) or 0
				local v33 = Utils.ConvertThumbnailTypeToEnum(p2)
				local v34 = avatarEditorService:NoPromptSaveAvatarThumbnailCustomization(v33, v32, p4, p5, p6)

				while not v34 do
					avatarEditorService.PromptSaveAvatarThumbnailCustomizationCompleted:Wait()
					v34 = avatarEditorService:NoPromptSaveAvatarThumbnailCustomization(v33, v32, p4, p5, p6)
				end

				local v35, v36 = avatarEditorService.PromptSaveAvatarThumbnailCustomizationCompleted:Wait()

				if v35 == Enum.AvatarPromptResult.Success then
					if p2 == PPEThumbnailType.Closeup then
						p9:dispatch(SetCurrentToastMessage(t2))
					end

					p9:dispatch(IncrementPPEVersion(p2))
					resolve()

					return
				end

				if tostring(v36) ~= tostring(Enum.SaveAvatarThumbnailCustomizationFailure.Other) then
					mutedError(string.format("Call to AvatarEditorService:NoPromptSaveAvatarThumbnailCustomization failed with error code \"%s\"", (tostring(v36))))
				end

				if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
					reportAvatarEventCounterNoAnalyticsArgument(Constants2.Counter.AvatarEditorServiceErrors.NoPromptSaveAvatarThumbnailCustomization)
				end

				p9:dispatch(SetCurrentToastMessage(t1))
				Logging.warn("WebApi failure in WritePPEConfig")
			end)
		end)(p7)
	end
end
