local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local MomentsCommon = require(MomentsParent.MomentsCommon)
local React = require(MomentsParent.React)
local useSignalState = require(MomentsParent.SignalsReact).useSignalState
local FFlagLuaAppIedpControlledJoin = require(MomentsParent.SharedFlags).FFlagLuaAppIedpControlledJoin
local InExperienceDetailsPromptContainer = require(MomentsParent.InExperienceDetailsPrompt.InExperienceDetailsPromptContainer)
local useMomentsSession = require(Moments.Stores.GetMomentsStore.MomentsSessionContext).useMomentsSession
local getExperienceDetailsSheetStore = require(script.Parent.getExperienceDetailsSheetStore)
local useHideTabBarWhileOpen = require(script.Parent.useHideTabBarWhileOpen)
local useJoinExperience = require(Moments.ExperienceDetailsSheet.Join.useJoinExperience)
local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent

local function ExperienceDetailsSheet() -- line: 39
	-- upvalues: getExperienceDetailsSheetStore (copy), useSignalState (copy), FFlagLuaAppIedpControlledJoin (copy), useJoinExperience (copy), useMomentsSession (copy), useHideTabBarWhileOpen (copy), React (copy), fireAnalyticsEvent (copy), EventNames (copy), InExperienceDetailsPromptContainer (copy)
	local v16 = getExperienceDetailsSheetStore(false)
	local v17 = useSignalState(v16.getIsOpen) and FFlagLuaAppIedpControlledJoin
	local v18 = useSignalState(v16.getContext)
	local v19 = useJoinExperience()
	local v20 = useMomentsSession()

	useHideTabBarWhileOpen(v17)
	React.useEffect(function() -- line: 49
		-- upvalues: v17 (copy), v18 (copy), fireAnalyticsEvent (copy), EventNames (copy), v20 (copy)
		if v17 and v18 then
			fireAnalyticsEvent(EventNames.ExperienceDetailsOpened, {
				moments_session_id = v20.getMomentsSessionId(false),
				item_id = v18.itemId or "",
				tracing_id = v18.tracingId or "",
				universe_id = tostring(v18.universeId),
				place_id = tostring(v18.placeId)
			})
		end
	end, {
		v17,
		v18,
		v20.getMomentsSessionId
	})

	local v21 = React.useCallback(function(n1: number?) -- line: 63
		-- upvalues: v18 (copy), v19 (copy), v16 (copy)
		if v18 then
			v19(v18, n1)
		end

		v16.close()
	end, {
		v19,
		v18,
		v16.close
	})

	if not v17 or v18 == nil then
		return nil
	end

	return React.createElement(InExperienceDetailsPromptContainer, {
		universeId = tostring(v18.universeId),
		onClose = v16.close,
		onJoin = v21
	})
end

return React.memo(ExperienceDetailsSheet)
