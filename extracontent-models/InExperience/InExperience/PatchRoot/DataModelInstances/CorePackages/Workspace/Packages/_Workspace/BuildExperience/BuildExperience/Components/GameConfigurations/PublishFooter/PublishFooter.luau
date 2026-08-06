local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local GameDetail = require(BuildExperienceParent.GameDetail)
local Navigation = require(BuildExperienceParent.Navigation)
local React = require(BuildExperienceParent.React)
local SharedFlags = require(BuildExperienceParent.SharedFlags)
local Signals = require(BuildExperienceParent.Signals)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local useOpenWebView = require(BuildExperienceParent.WebViewUtils).useOpenWebView
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local ExperienceGuidelines = require(BuildExperienceParent.DataHydration.ExperienceGuidelines)
local PlaceVersionHistory = require(BuildExperienceParent.DataHydration.PlaceVersionHistory)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local UniverseActivation = require(BuildExperienceParent.DataHydration.UniverseActivation)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FriendsOnlyShareDialog = require(BuildExperience.Components.ShareAudience.FriendsOnlyShareDialog)
local PrivateShareTooltip = require(BuildExperience.Components.ShareAudience.PrivateShareTooltip)
local ContentMaturityUtils = require(BuildExperience.utils.ContentMaturityUtils)
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local refreshPublishEligibility = require(BuildExperience.utils.refreshPublishEligibility)
local GetVersionInformationStore = require(BuildExperience.Stores.GetVersionInformationStore)
local Button = Foundation.Button
local Snackbar = Foundation.Snackbar
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local PrivacyType = UniverseConfiguration.PrivacyType
local FFlagEnableShareSheet = SharedFlags.FFlagEnableShareSheet
local FFlagEnableProvisionalRating = require(BuildExperience.Flags.FFlagEnableProvisionalRating)
local FFlagBuildRehydrateOnPublish = require(BuildExperience.Flags.FFlagBuildRehydrateOnPublish)
local useStore = require(BuildExperienceParent.RoactUtils).Hooks.RoactRodux.useStore
local getRootNavigation = Navigation.getRootNavigation
local useNavigation = Navigation.useNavigation
local OpenGameDetails = GameDetail.OpenGameDetails
local debug = CreatorAgentChat.debug
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local sharePublishedExperience = require(BuildExperience.utils.sharePublishedExperience)
local sharePublishedExperience2 = sharePublishedExperience.sharePublishedExperience
local useSharePublishedExperience = sharePublishedExperience.useSharePublishedExperience
local t1 = {}

local function isPublishedVersion(p1) -- line: 66
	if typeof(p1) ~= "table" then
		return false
	end

	return p1.status == "success" and (typeof(p1.version) == "string" and p1.version ~= "")
end
local function buildPublicAudiences(t2: {[any]: any}?) -- line: 73
	-- upvalues: UniverseActivation (copy)
	local t3 = {}

	for _, v53 in t2 or {} do
		if v53 ~= UniverseActivation.Audience.Public and v53 ~= UniverseActivation.Audience.Friends then
			table.insert(t3, v53)
		end
	end

	table.insert(t3, UniverseActivation.Audience.Public)

	return t3
end
local function getGameDetailsNavigation(p2) -- line: 85
	if typeof(p2.clearAppScreens) == "function" then
		return p2
	end

	local v55 = table.clone(p2)

	function v55.clearAppScreens(t4: {[any]: any}) -- line: 91
		-- upvalues: p2 (copy)
		p2.dispatch({
			type = "ClearAppScreensAction",
			routeNames = t4
		})
	end

	return v55
end
local function PreviewButton(t5: {[any]: any}) -- line: 107
	-- upvalues: useStore (copy), useNavigation (copy), React (copy), getRootNavigation (copy), OpenGameDetails (copy), Button (copy), LocalizationStrings (copy), InputSize (copy), ButtonVariant (copy), FillBehavior (copy)
	local v57 = useStore()
	local v58 = useNavigation()
	local v59 = React.useCallback(function() -- line: 114
		-- upvalues: getRootNavigation (copy), v58 (copy), OpenGameDetails (copy), t5 (copy), v57 (copy)
		local v92 = getRootNavigation(v58)
		local v93 = OpenGameDetails
		local str = tostring(t5.target.universeId)
		local v95

		if typeof(v92.clearAppScreens) == "function" then
			v95 = v92
		else
			v95 = table.clone(v92)

			function v95.clearAppScreens(t6: {[any]: any}) -- line: 91
				-- upvalues: v92 (copy)
				v92.dispatch({
					type = "ClearAppScreensAction",
					routeNames = t6
				})
			end
		end

		v93(str, v95, {
			source = "BuildExperiencePublish"
		})(v57)
	end, {
		v58,
		t5.target.universeId,
		v57
	})

	return React.createElement(Button, {
		LayoutOrder = 2,
		text = LocalizationStrings.GAME_CONFIGURATION_PREVIEW,
		size = InputSize.Medium,
		variant = ButtonVariant.Standard,
		fillBehavior = FillBehavior.Fill,
		onActivated = v59,
		width = UDim.new(1, 0),
		testId = `{ t5.actionsTestId }-preview`
	})
end
local function PublishFooter(t7: {[any]: any}) -- line: 133
	-- upvalues: useSharePublishedExperience (copy), SignalsReact (copy), PlaceVersionHistory (copy), React (copy), Signals (copy), UniverseConfiguration (copy), FFlagEnableProvisionalRating (copy), GameConfigurationLabels (copy), UniverseActivation (copy), ContentMaturityUtils (copy), useOpenWebView (copy), LocalizationStrings (copy), FFlagEnableShareSheet (copy), sharePublishedExperience2 (copy), PrivacyType (copy), GameConfigurationActions (copy), refreshPublishEligibility (copy), GetVersionInformationStore (copy), sendBuildExperienceEvent (copy), buildPublicAudiences (copy), FFlagBuildRehydrateOnPublish (copy), ExperienceGuidelines (copy), t1 (copy), debug (copy), View (copy), PrivateShareTooltip (copy), Snackbar (copy), Button (copy), InputSize (copy), ButtonVariant (copy), FillBehavior (copy), PreviewButton (copy), FriendsOnlyShareDialog (copy)
	local v61 = useSharePublishedExperience(t7.target.universeId)
	local v62 = SignalsReact.useSignalState(PlaceVersionHistory.getPlaceVersionHistoryStore)
	local v63 = React.useMemo(function() -- line: 136
		-- upvalues: t7 (copy), Signals (copy), v62 (copy)
		if t7.target.placeId == nil then
			return (Signals.createSignal(nil))
		end

		return v62.getAndFetchHistory(t7.target.placeId).data
	end, {
		v62,
		t7.target.placeId
	})
	local v64 = SignalsReact.useSignalState(v63)
	local v65 = if not v64 then nil else v64.placeVersions[1]
	local v66 = SignalsReact.useSignalState(UniverseConfiguration.getUniverseConfigurationStore)
	local v67 = SignalsReact.useSignalState(v66.getAndFetchConfiguration(t7.target.universeId).data)
	local v68 = React.useMemo(function() -- line: 149
		-- upvalues: FFlagEnableProvisionalRating (copy), Signals (copy), v66 (copy), t7 (copy)
		if not FFlagEnableProvisionalRating then
			return (Signals.createSignal(nil))
		end

		return v66.getAndFetchSummary(t7.target.universeId).data
	end, {
		v66,
		t7.target.universeId
	})
	local v69 = SignalsReact.useSignalState(v68)
	local v70 = GameConfigurationLabels.getAudience(v67)
	local v71 = false
	local u72 = nil

	if FFlagEnableProvisionalRating then
		local v73 = SignalsReact.useSignalState(UniverseActivation.getUniverseActivationStore)

		u72 = v73

		local v74 = React.useMemo(function() -- line: 163
			-- upvalues: v73 (copy), t7 (copy)
			return v73.getAndFetchEligibility(t7.target.universeId)
		end, {
			v73,
			t7.target.universeId
		})
		local v75 = SignalsReact.useSignalState(v74.data)

		v71 = React.useMemo(function() -- line: 167
			-- upvalues: ContentMaturityUtils (copy), t7 (copy)
			return ContentMaturityUtils.isSealBroken(t7.target.universeId) and ContentMaturityUtils.isContentUnrated(t7.target.universeId)
		end, {
			v75,
			t7.target.universeId
		})
	end

	local v76 = useOpenWebView()
	local v77, v78 = React.useState(false)
	local v79, v80 = React.useState("")
	local v81, v82 = React.useState(nil)
	local v83 = v79 == LocalizationStrings.GAME_CONFIGURATION_PUBLISH_SUCCESS and (t7.target.placeId ~= nil and v70 ~= nil)
	local v84 = React.useCallback(function() -- line: 180
		-- upvalues: v80 (copy), v82 (copy)
		v80("")
		v82(nil)
	end, {})
	local v85 = React.useCallback(function() -- line: 185
		-- upvalues: t7 (copy), v82 (copy), FFlagEnableShareSheet (copy), v61 (copy), sharePublishedExperience2 (copy), v80 (copy), LocalizationStrings (copy)
		if t7.target.placeId == nil then
			return
		end

		v82(nil)

		if FFlagEnableShareSheet then
			v61(t7.target.placeId)

			return
		end

		if sharePublishedExperience2(t7.target.placeId).copiedToClipboard then
			v80(LocalizationStrings.GAME_CONFIGURATION_LINK_COPIED)
		end
	end, {
		t7.target.placeId,
		v61
	})
	local v86 = React.useCallback(function() -- line: 202
		-- upvalues: v70 (copy), PrivacyType (copy), v82 (copy), v81 (copy), v85 (copy)
		if v70 == PrivacyType.Private then
			v82(v81 ~= "private" and "private" or nil)

			return
		end

		if v70 == PrivacyType.FriendsOnly then
			v82("friends")

			return
		end

		if v70 == PrivacyType.Public then
			v85()
		end
	end, {
		v70,
		v81,
		v85
	})
	local v87 = React.useCallback(function() -- line: 220
		-- upvalues: v82 (copy)
		v82(nil)
	end, {})
	local v88 = React.useCallback(function() -- line: 224
		-- upvalues: v76 (copy), GameConfigurationActions (copy), t7 (copy), LocalizationStrings (copy), refreshPublishEligibility (copy)
		v76(GameConfigurationActions.getExperienceQuestionnaireUrl(t7.target.universeId), LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB, function() -- line: 228
			-- upvalues: refreshPublishEligibility (copy), t7 (copy)
			refreshPublishEligibility(t7.target.universeId)
		end)
	end, {
		v76,
		t7.target.universeId
	})
	local v89 = React.useCallback(function() -- line: 235
		-- upvalues: v77 (copy), t7 (copy), GetVersionInformationStore (copy), v65 (copy), sendBuildExperienceEvent (copy), v78 (copy), v84 (copy), v69 (copy), FFlagEnableProvisionalRating (copy), GameConfigurationActions (copy), buildPublicAudiences (copy), FFlagBuildRehydrateOnPublish (copy), u72 (ref), ContentMaturityUtils (copy), ExperienceGuidelines (copy), t1 (copy), debug (copy), v66 (copy), v62 (copy), v80 (copy), LocalizationStrings (copy)
		if v77 then
			return
		end

		local placeId = t7.target.placeId

		if placeId == nil then
			return
		end

		local v97 = GetVersionInformationStore().getDraft()
		local u98 = nil
		local u99 = nil

		if v97 ~= nil and placeId == v97.placeId then
			u98 = if v97.title ~= "" then v97.title else nil
			u99 = if v97.description ~= "" then v97.description else nil
		elseif v65 ~= nil then
			u98 = v65.title
			u99 = v65.description
		end

		sendBuildExperienceEvent("PUBLISH_CLICK", {
			universeId = t7.target.universeId,
			placeId = placeId,
			conversationId = t7.target.sessionId
		})
		v78(true)
		v84()

		local s1 = "save_and_publish"

		local function publish(p3) -- line: 264
			-- upvalues: s1 (ref), v69 (copy), FFlagEnableProvisionalRating (copy), GameConfigurationActions (copy), t7 (copy), placeId (copy), u98 (ref), u99 (ref), buildPublicAudiences (copy)
			s1 = "save_and_publish"

			local v105 = p3 or v69

			if FFlagEnableProvisionalRating then
				return (GameConfigurationActions.publishExperience({
					universeId = t7.target.universeId,
					placeId = placeId,
					title = u98,
					description = u99,
					isActive = v105 ~= nil and v105.isActive == true,
					audiences = buildPublicAudiences(if not v105 then nil else v105.audiences)
				}))
			end

			return (GameConfigurationActions.saveAndPublishPlace({
				placeId = placeId,
				title = u98,
				description = u99
			}))
		end

		local v102

		if FFlagEnableProvisionalRating and FFlagBuildRehydrateOnPublish and u72 ~= nil then
			s1 = "refresh_eligibility"
			v102 = u72.refreshEligibility(t7.target.universeId):andThen(function() -- line: 285
				-- upvalues: ContentMaturityUtils (copy), t7 (copy), ExperienceGuidelines (copy), t1 (copy), debug (copy), s1 (ref), v66 (copy), publish (copy)
				if ContentMaturityUtils.isSealBroken(t7.target.universeId) and ContentMaturityUtils.isContentUnrated(t7.target.universeId) then
					return ExperienceGuidelines.getExperienceGuidelinesStore().refreshDetailedGuidelines(t7.target.universeId):andThen(function() -- line: 292
						-- upvalues: t1 (copy)
						return t1
					end, function(p4) -- line: 294
						-- upvalues: debug (copy), t7 (copy), t1 (copy)
						debug.log("warn", "build_experience content maturity refresh failed", {
							errorMessage = tostring(p4),
							universeId = t7.target.universeId
						})

						return t1
					end)
				end

				s1 = "refresh_summary"

				return v66.refreshSummary(t7.target.universeId):andThen(function(p5) -- line: 309
					-- upvalues: publish (copy)
					return (publish(p5))
				end)
			end)
		else
			v102 = publish()
		end

		v102:andThen(function(p6) -- line: 317
			-- upvalues: t1 (copy), GetVersionInformationStore (copy), placeId (copy), v62 (copy), v80 (copy), LocalizationStrings (copy)
			if p6 == t1 then
				return
			end

			if typeof(p6) ~= "table" or (p6.status ~= "success" or (typeof(p6.version) ~= "string" or p6.version == "")) then
				error({
					errorMessage = "save_and_publish expected status=success and a non-empty version; " .. `got status={ tostring(p6.status) }, version={ tostring(p6.version) }`
				})
			end

			GetVersionInformationStore().clearDraft(placeId)
			v62.fetchHistory(placeId)
			v80(LocalizationStrings.GAME_CONFIGURATION_PUBLISH_SUCCESS)
		end):catch(function(p7) -- line: 331
			-- upvalues: FFlagBuildRehydrateOnPublish (copy), GameConfigurationActions (copy), GetVersionInformationStore (copy), placeId (copy), v62 (copy), debug (copy), s1 (ref), t7 (copy), v80 (copy), LocalizationStrings (copy)
			local v108 = typeof(p7) == "table"
			local v109 = FFlagBuildRehydrateOnPublish and (v108 and p7.stage == GameConfigurationActions.PublishFailureStage.SetAudience)
			local v110 = v109

			if v110 then
				local publishResult = p7.publishResult

				v110 = typeof(publishResult) == "table" and (publishResult.status == "success" and (typeof(publishResult.version) == "string" and publishResult.version ~= ""))
			end

			if v110 then
				GetVersionInformationStore().clearDraft(placeId)
				v62.fetchHistory(placeId)
			end

			debug.log("warn", "build_experience publish failed", {
				errorMessage = if not v108 or p7.errorMessage == nil then tostring(p7) else tostring(p7.errorMessage),
				placeId = placeId,
				responseCode = if not v108 then nil else p7.responseCode,
				stage = if not v109 then s1 else GameConfigurationActions.PublishFailureStage.SetAudience,
				universeId = t7.target.universeId
			})
			v80(if not v110 then LocalizationStrings.GAME_CONFIGURATION_PUBLISH_ERROR else LocalizationStrings.GAME_CONFIGURATION_PUBLISH_AUDIENCE_ERROR)
		end):finally(function() -- line: 360
			-- upvalues: v78 (copy)
			v78(false)
		end)
	end, {
		v84,
		v77,
		v62,
		t7.target.placeId,
		t7.target.sessionId,
		t7.target.universeId,
		v65,
		u72,
		v66,
		v69
	})
	local v90 = `{ t7.testId }.actions`

	return React.createElement(View, {
		LayoutOrder = 3,
		tag = "col gap-small size-full-0 auto-y bg-surface-0"
	}, {
		PublishSnackbarWrapper = if v79 == "" then nil else React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-x-center size-full-0 auto-y padding-x-large"
		}, {
			PublishSnackbar = React.createElement(PrivateShareTooltip, {
				LayoutOrder = 1,
				isOpen = v81 == "private" and v70 == PrivacyType.Private
			}, {
				Snackbar = React.createElement(Snackbar, {
					LayoutOrder = 1,
					title = v79,
					action = if not v83 then nil else {
						text = LocalizationStrings.GAME_CONFIGURATION_SHARE,
						onActivated = v86
					},
					onClose = if not v83 then v84 else nil,
					testId = `{ t7.testId }.publish-snackbar`
				})
			})
		}),
		Actions = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row gap-small size-full-0 auto-y padding-y-medium",
			testId = v90
		}, {
			Publish = FFlagEnableProvisionalRating and React.createElement(Button, {
				LayoutOrder = 1,
				text = if not v71 then LocalizationStrings.GAME_CONFIGURATION_PUBLISH else LocalizationStrings.GAME_CONFIGURATION_UPDATE_RATING,
				size = InputSize.Medium,
				variant = ButtonVariant.Emphasis,
				fillBehavior = FillBehavior.Fill,
				isDisabled = t7.target.placeId == nil,
				isLoading = v77,
				onActivated = if not v71 then v89 else v88,
				width = UDim.new(1, 0),
				testId = `{ v90 }-publish`
			}),
			Preview = if t7.showPreviewButton ~= false then React.createElement(PreviewButton, {
				target = t7.target,
				actionsTestId = v90
			}) else nil
		}),
		FriendsOnlyShareDialog = if v81 ~= "friends" or v70 ~= PrivacyType.FriendsOnly then nil else React.createElement(FriendsOnlyShareDialog, {
			onCancel = v87,
			onShare = v85
		})
	})
end

return PublishFooter
