local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Dash")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SignalsReact")

local useCallback = React.useCallback
local useMemo = React.useMemo
local useSignalState = SignalsReact.useSignalState

local eventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")
local fFlagMomentsTextOverlayV2Redesign = MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local v5 = { Enum.TextXAlignment.Center, Enum.TextXAlignment.Left, Enum.TextXAlignment.Right }

local v6 = {
	[Enum.TextXAlignment.Left.Name] = BuilderIcons.Icon.FourBarsHorizontalRightAligned,
	[Enum.TextXAlignment.Center.Name] = BuilderIcons.Icon.FourBarsHorizontalCenterAligned,
	[Enum.TextXAlignment.Right.Name] = BuilderIcons.Icon.FourBarsHorizontalLeftAligned
}

local function nextAlignment(p2)
	for k, v7 in v5 do
		if v7 == p2 then
			return v5[k % #v5 + 1]
		end
	end

	return Enum.TextXAlignment.Center
end

local function useTextAlignmentButtonState(p2)
	local v8 = useSignalState((useMemo(function()
		return Signals.createComputed(function(p3)
			local activeSession = p2.getActiveSession(p3)
			local v8 = if activeSession ~= nil then activeSession.getDraft(p3) else nil
			local v9 = v8 and v8[1]

			if v9 == nil then
				return Enum.TextXAlignment.Center
			end

			return v9.textOverlayStyle.textXAlignment
		end)
	end, { p2 })))

	local v9 = useCallback(function()
		local activeSession = p2.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)
		local v10 = draft and draft[1]

		if v10 == nil then
			return
		end

		local textXAlignment = v10.textOverlayStyle.textXAlignment
		local flag = true
		local v11

		for k, v12 in v5 do
			if v12 == textXAlignment then
				v11 = v5[k % #v5 + 1]
				flag = false
				break
			end
		end

		if flag then
			v11 = Enum.TextXAlignment.Center
		end

		activeSession.update({ Dash.joinDeep(v10, {
				textOverlayStyle = { textXAlignment = v11 }
			}) })

		if fFlagMomentsTextOverlayV2Redesign then
			fireAnalyticsEvent(
				eventNames.EditingFlowTextOverlayAlignmentSelected,
				makeCreationEventFields.makeTextOverlayEventFields({ alignment = v11.Name })
			)
		end
	end, { p2 })

	return {
		icon = v6[v8.Name] or BuilderIcons.Icon.FourBarsHorizontalCenterAligned,
		onActivated = v9
	}
end

return useTextAlignmentButtonState
