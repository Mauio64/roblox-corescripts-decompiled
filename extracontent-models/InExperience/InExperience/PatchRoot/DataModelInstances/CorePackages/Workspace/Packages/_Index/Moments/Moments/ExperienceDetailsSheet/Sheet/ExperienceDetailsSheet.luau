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
local GetFFlagMomentsAnalyticsSchemaIdentity = MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity

local function ExperienceDetailsSheet() -- line: 40
	-- upvalues: getExperienceDetailsSheetStore (copy), useSignalState (copy), FFlagLuaAppIedpControlledJoin (copy), useJoinExperience (copy), useMomentsSession (copy), useHideTabBarWhileOpen (copy), React (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), fireAnalyticsEvent (copy), EventNames (copy), Analytics (copy), InExperienceDetailsPromptContainer (copy)
	local v17 = getExperienceDetailsSheetStore(false)
	local v18 = useSignalState(v17.getIsOpen) and FFlagLuaAppIedpControlledJoin
	local v19 = useSignalState(v17.getContext)
	local v20 = useJoinExperience()
	local v21 = useMomentsSession()

	useHideTabBarWhileOpen(v18)
	React.useEffect(function() -- line: 50
		-- upvalues: v18 (copy), v19 (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), fireAnalyticsEvent (copy), EventNames (copy), Analytics (copy), v21 (copy)
		if v18 and v19 then
			if GetFFlagMomentsAnalyticsSchemaIdentity() then
				if v19.feedItemId ~= nil and v19.feedItemId ~= "" then
					fireAnalyticsEvent(EventNames.ExperienceDetailsOpened, {
						feedItemId = v19.feedItemId,
						feedSessionId = v19.tracingId or "",
						placeId = tostring(v19.placeId),
						universeId = tostring(v19.universeId)
					})

					return
				end

				local v23 = v19.feedItemId ~= nil and "empty" or "nil"

				Analytics.reportMomentSkip("feed_action", v23, {
					action = "edp"
				})

				return
			end

			fireAnalyticsEvent(EventNames.ExperienceDetailsOpened, {
				moments_session_id = v21.getMomentsSessionId(false),
				item_id = v19.itemId or "",
				tracing_id = v19.tracingId or "",
				universe_id = tostring(v19.universeId),
				place_id = tostring(v19.placeId)
			})
		end
	end, {
		v18,
		v19,
		v21.getMomentsSessionId
	})

	local v22 = React.useCallback(function(n1: number?) -- line: 85
		-- upvalues: v19 (copy), v20 (copy), v17 (copy)
		if v19 then
			v20(v19, n1)
		end

		v17.close()
	end, {
		v20,
		v19,
		v17.close
	})

	if not v18 or v19 == nil then
		return nil
	end

	return React.createElement(InExperienceDetailsPromptContainer, {
		universeId = tostring(v19.universeId),
		onClose = v17.close,
		onJoin = v22
	})
end

return React.memo(ExperienceDetailsSheet)
