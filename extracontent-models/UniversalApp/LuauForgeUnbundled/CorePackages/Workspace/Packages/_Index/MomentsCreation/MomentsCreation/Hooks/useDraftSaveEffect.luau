local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")

local GetCreationFlowStore = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/GetCreationFlowStore")
local MomentsDraftStorage = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Storage/MomentsDraftStorage")
local isAvatarMoment = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/isAvatarMoment")
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local FFlagMomentsCommentsCreatorControl = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCommentsCreatorControl")
local fFlagMomentsCreateAvatarPosts = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SharedFlags").FFlagMomentsCreateAvatarPosts

local eventNames = MomentsCommon.Analytics.EventNames

local function useDraftSaveEffect(p2)
	local v5 = GetCreationFlowStore(false)

	React.useEffect(function()
		if p2 then
			return nil
		end

		return Signals.createEffect(function(p3)
			local selectedCapture = v5.getSelectedCapture(p3)
			local description = v5.getDescription(p3)
			local v6 = if FFlagMomentsCommentsCreatorControl then v5.getCommentsEnabled(p3) else nil
			local editsMap = v5.getEditsMap(p3)

			if selectedCapture == nil or fFlagMomentsCreateAvatarPosts and isAvatarMoment(selectedCapture) then
				return
			end

			if not MomentsDraftStorage.save({
				captureRef = {
					localId = selectedCapture.LocalId,
					captureType = selectedCapture.CaptureType
				},
				description = description,
				commentsEnabled = v6,
				edits = editsMap
			}) then
				fireAnalyticsEvent(eventNames.DraftSaveFailedEvent, {})
			end
		end)
	end, { v5, p2 })
end

return useDraftSaveEffect
