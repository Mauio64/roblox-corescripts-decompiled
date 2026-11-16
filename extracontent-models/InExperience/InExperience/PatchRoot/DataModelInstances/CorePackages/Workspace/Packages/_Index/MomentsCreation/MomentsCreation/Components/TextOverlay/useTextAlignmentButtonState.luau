local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Dash = require(parent.Dash)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local useCallback = React.useCallback
local useMemo = React.useMemo
local useSignalState = SignalsReact.useSignalState

local EventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local FFlagMomentsTextOverlayV2Redesign = MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign

require(MomentsCreation.Types.CreationFlowTypes)
require(parent.MomentsTypes)

local v = { Enum.TextXAlignment.Center, Enum.TextXAlignment.Left, Enum.TextXAlignment.Right }

local v2 = {
	[Enum.TextXAlignment.Left.Name] = BuilderIcons.Icon.FourBarsHorizontalRightAligned,
	[Enum.TextXAlignment.Center.Name] = BuilderIcons.Icon.FourBarsHorizontalCenterAligned,
	[Enum.TextXAlignment.Right.Name] = BuilderIcons.Icon.FourBarsHorizontalLeftAligned
}

local function nextAlignment(textXAlignment) -- 1 equivalent call inferred from this helper
	for k, v3 in v do
		if v3 == textXAlignment then
			return v[k % #v + 1]
		end
	end

	return Enum.TextXAlignment.Center
end

local function useTextAlignmentButtonState(p)
	local v3 = useSignalState((useMemo(function()
		return Signals.createComputed(function(p2)
			local activeSession = p.getActiveSession(p2)
			local v3

			if activeSession ~= nil then
				v3 = activeSession.getDraft(p2)
			end

			local v4 = v3 and v3[1]

			if v4 == nil then
				return Enum.TextXAlignment.Center
			end

			return v4.textOverlayStyle.textXAlignment
		end)
	end, { p })))

	local onActivated = useCallback(function()
		local activeSession = p.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)
		local v4 = draft and draft[1]

		if v4 == nil then
			return
		end

		local textXAlignment = nextAlignment(v4.textOverlayStyle.textXAlignment) -- inferred equivalent call
		activeSession.update({ Dash.joinDeep(v4, {
				textOverlayStyle = { textXAlignment = textXAlignment }
			}) })

		if FFlagMomentsTextOverlayV2Redesign then
			fireAnalyticsEvent(
				EventNames.EditingFlowTextOverlayAlignmentSelected,
				makeCreationEventFields.makeTextOverlayEventFields({
					alignment = textXAlignment.Name
				})
			)
		end
	end, { p })

	return {
		icon = v2[v3.Name] or BuilderIcons.Icon.FourBarsHorizontalCenterAligned,
		onActivated = onActivated
	}
end

return useTextAlignmentButtonState
