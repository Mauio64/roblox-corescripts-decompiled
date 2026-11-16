local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local MomentsCommon = require(parent.MomentsCommon)

local GetCreationFlowStore = require(MomentsCreation.Stores.GetCreationFlowStore)
local MomentsDraftStorage = require(MomentsCreation.Storage.MomentsDraftStorage)
local isAvatarMoment = require(MomentsCreation.Utils.isAvatarMoment)
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local FFlagMomentsCommentsCreatorControl = require(MomentsCreation.Flags.FFlagMomentsCommentsCreatorControl)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsCreateAvatarPosts = SharedFlags.FFlagMomentsCreateAvatarPosts

local EventNames = MomentsCommon.Analytics.EventNames

local function useDraftSaveEffect(flag: boolean?)
	local creationFlowStore = GetCreationFlowStore(false)

	React.useEffect(function()
		if flag then
			return nil
		end

		return Signals.createEffect(function(p)
			local selectedCapture = creationFlowStore.getSelectedCapture(p)
			local description = creationFlowStore.getDescription(p)
			local commentsEnabled

			if FFlagMomentsCommentsCreatorControl then
				commentsEnabled = creationFlowStore.getCommentsEnabled(p)
			end

			local editsMap = creationFlowStore.getEditsMap(p)

			if selectedCapture == nil or FFlagMomentsCreateAvatarPosts and isAvatarMoment(selectedCapture) then
				return
			end

			if not MomentsDraftStorage.save({
				captureRef = {
					localId = selectedCapture.LocalId,
					captureType = selectedCapture.CaptureType
				},
				description = description,
				commentsEnabled = commentsEnabled,
				edits = editsMap
			}) then
				fireAnalyticsEvent(EventNames.DraftSaveFailedEvent, {})
			end
		end)
	end, { creationFlowStore, flag })
end

return useDraftSaveEffect
