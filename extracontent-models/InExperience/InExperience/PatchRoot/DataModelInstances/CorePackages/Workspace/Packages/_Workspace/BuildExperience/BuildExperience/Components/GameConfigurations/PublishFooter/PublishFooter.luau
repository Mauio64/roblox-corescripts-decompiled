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
local PlaceVersionHistory = require(BuildExperienceParent.DataHydration.PlaceVersionHistory)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local UniverseActivation = require(BuildExperienceParent.DataHydration.UniverseActivation)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FriendsOnlyShareDialog = require(BuildExperience.Components.ShareAudience.FriendsOnlyShareDialog)
local PrivateShareTooltip = require(BuildExperience.Components.ShareAudience.PrivateShareTooltip)
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
local useStore = require(BuildExperienceParent.RoactUtils).Hooks.RoactRodux.useStore
local getRootNavigation = Navigation.getRootNavigation
local useNavigation = Navigation.useNavigation
local OpenGameDetails = GameDetail.OpenGameDetails
local debug = CreatorAgentChat.debug
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local sharePublishedExperience = require(BuildExperience.utils.sharePublishedExperience)
local sharePublishedExperience2 = sharePublishedExperience.sharePublishedExperience
local useSharePublishedExperience = sharePublishedExperience.useSharePublishedExperience

local function buildPublicAudiences(t1: {[any]: any}?) -- line: 62
	-- upvalues: UniverseActivation (copy)
	local t2 = {}

	for _, v47 in t1 or {} do
		if v47 ~= UniverseActivation.Audience.Public and v47 ~= UniverseActivation.Audience.Friends then
			table.insert(t2, v47)
		end
	end

	table.insert(t2, UniverseActivation.Audience.Public)

	return t2
end
local function getGameDetailsNavigation(p1) -- line: 74
	if typeof(p1.clearAppScreens) == "function" then
		return p1
	end

	local v49 = table.clone(p1)

	function v49.clearAppScreens(t3: {[any]: any}) -- line: 80
		-- upvalues: p1 (copy)
		p1.dispatch({
			type = "ClearAppScreensAction",
			routeNames = t3
		})
	end

	return v49
end
local function PreviewButton(t4: {[any]: any}) -- line: 96
	-- upvalues: useStore (copy), useNavigation (copy), React (copy), getRootNavigation (copy), OpenGameDetails (copy), Button (copy), LocalizationStrings (copy), InputSize (copy), ButtonVariant (copy), FillBehavior (copy)
	local v51 = useStore()
	local v52 = useNavigation()
	local v53 = React.useCallback(function() -- line: 103
		-- upvalues: getRootNavigation (copy), v52 (copy), OpenGameDetails (copy), t4 (copy), v51 (copy)
		local v85 = getRootNavigation(v52)
		local v86 = OpenGameDetails
		local str = tostring(t4.target.universeId)
		local v88

		if typeof(v85.clearAppScreens) == "function" then
			v88 = v85
		else
			v88 = table.clone(v85)

			function v88.clearAppScreens(t5: {[any]: any}) -- line: 80
				-- upvalues: v85 (copy)
				v85.dispatch({
					type = "ClearAppScreensAction",
					routeNames = t5
				})
			end
		end

		v86(str, v88, {
			source = "BuildExperiencePublish"
		})(v51)
	end, {
		v52,
		t4.target.universeId,
		v51
	})

	return React.createElement(Button, {
		LayoutOrder = 2,
		text = LocalizationStrings.GAME_CONFIGURATION_PREVIEW,
		size = InputSize.Medium,
		variant = ButtonVariant.Standard,
		fillBehavior = FillBehavior.Fill,
		onActivated = v53,
		width = UDim.new(1, 0),
		testId = `{ t4.actionsTestId }-preview`
	})
end
local function PublishFooter(t6: {[any]: any}) -- line: 122
	-- upvalues: useSharePublishedExperience (copy), SignalsReact (copy), PlaceVersionHistory (copy), React (copy), Signals (copy), UniverseConfiguration (copy), FFlagEnableProvisionalRating (copy), GameConfigurationLabels (copy), UniverseActivation (copy), useOpenWebView (copy), LocalizationStrings (copy), FFlagEnableShareSheet (copy), sharePublishedExperience2 (copy), PrivacyType (copy), GameConfigurationActions (copy), refreshPublishEligibility (copy), GetVersionInformationStore (copy), sendBuildExperienceEvent (copy), buildPublicAudiences (copy), debug (copy), View (copy), PrivateShareTooltip (copy), Snackbar (copy), Button (copy), InputSize (copy), ButtonVariant (copy), FillBehavior (copy), PreviewButton (copy), FriendsOnlyShareDialog (copy)
	local v55 = useSharePublishedExperience(t6.target.universeId)
	local v56 = SignalsReact.useSignalState(PlaceVersionHistory.getPlaceVersionHistoryStore)
	local v57 = React.useMemo(function() -- line: 125
		-- upvalues: t6 (copy), Signals (copy), v56 (copy)
		if t6.target.placeId == nil then
			return (Signals.createSignal(nil))
		end

		return v56.getAndFetchHistory(t6.target.placeId).data
	end, {
		v56,
		t6.target.placeId
	})
	local v58 = SignalsReact.useSignalState(v57)
	local v59 = if not v58 then nil else v58.placeVersions[1]
	local v60 = SignalsReact.useSignalState(UniverseConfiguration.getUniverseConfigurationStore)
	local v61 = SignalsReact.useSignalState(v60.getAndFetchConfiguration(t6.target.universeId).data)
	local v62 = React.useMemo(function() -- line: 138
		-- upvalues: FFlagEnableProvisionalRating (copy), Signals (copy), v60 (copy), t6 (copy)
		if not FFlagEnableProvisionalRating then
			return (Signals.createSignal(nil))
		end

		return v60.getAndFetchSummary(t6.target.universeId).data
	end, {
		v60,
		t6.target.universeId
	})
	local v63 = SignalsReact.useSignalState(v62)
	local v64 = GameConfigurationLabels.getAudience(v61)
	local v65 = false

	if FFlagEnableProvisionalRating then
		local v66 = SignalsReact.useSignalState(UniverseActivation.getUniverseActivationStore)
		local v67 = React.useMemo(function() -- line: 150
			-- upvalues: v66 (copy), t6 (copy)
			return v66.getAndFetchEligibility(t6.target.universeId)
		end, {
			v66,
			t6.target.universeId
		})
		local v68 = SignalsReact.useSignalState(v67.data)

		v65 = v68 ~= nil and (v68.maturityRated ~= true and v68.provisionalRatingAllowed ~= true)
	end

	local v69 = useOpenWebView()
	local v70, v71 = React.useState(false)
	local v72, v73 = React.useState("")
	local v74, v75 = React.useState(nil)
	local v76 = v72 == LocalizationStrings.GAME_CONFIGURATION_PUBLISH_SUCCESS and (t6.target.placeId ~= nil and v64 ~= nil)
	local v77 = React.useCallback(function() -- line: 166
		-- upvalues: v73 (copy), v75 (copy)
		v73("")
		v75(nil)
	end, {})
	local v78 = React.useCallback(function() -- line: 171
		-- upvalues: t6 (copy), v75 (copy), FFlagEnableShareSheet (copy), v55 (copy), sharePublishedExperience2 (copy), v73 (copy), LocalizationStrings (copy)
		if t6.target.placeId == nil then
			return
		end

		v75(nil)

		if FFlagEnableShareSheet then
			v55(t6.target.placeId)

			return
		end

		if sharePublishedExperience2(t6.target.placeId).copiedToClipboard then
			v73(LocalizationStrings.GAME_CONFIGURATION_LINK_COPIED)
		end
	end, {
		t6.target.placeId,
		v55
	})
	local v79 = React.useCallback(function() -- line: 188
		-- upvalues: v64 (copy), PrivacyType (copy), v75 (copy), v74 (copy), v78 (copy)
		if v64 == PrivacyType.Private then
			v75(v74 ~= "private" and "private" or nil)

			return
		end

		if v64 == PrivacyType.FriendsOnly then
			v75("friends")

			return
		end

		if v64 == PrivacyType.Public then
			v78()
		end
	end, {
		v64,
		v74,
		v78
	})
	local v80 = React.useCallback(function() -- line: 206
		-- upvalues: v75 (copy)
		v75(nil)
	end, {})
	local v81 = React.useCallback(function() -- line: 210
		-- upvalues: v69 (copy), GameConfigurationActions (copy), t6 (copy), LocalizationStrings (copy), refreshPublishEligibility (copy)
		v69(GameConfigurationActions.getExperienceQuestionnaireUrl(t6.target.universeId), LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB, function() -- line: 214
			-- upvalues: refreshPublishEligibility (copy), t6 (copy)
			refreshPublishEligibility(t6.target.universeId)
		end)
	end, {
		v69,
		t6.target.universeId
	})
	local v82 = React.useCallback(function() -- line: 221
		-- upvalues: v70 (copy), t6 (copy), GetVersionInformationStore (copy), v59 (copy), sendBuildExperienceEvent (copy), v71 (copy), v77 (copy), v63 (copy), FFlagEnableProvisionalRating (copy), GameConfigurationActions (copy), buildPublicAudiences (copy), v56 (copy), v73 (copy), LocalizationStrings (copy), debug (copy)
		if v70 then
			return
		end

		local placeId = t6.target.placeId

		if placeId == nil then
			return
		end

		local v90 = GetVersionInformationStore().getDraft()
		local v91 = nil
		local v92 = nil

		if v90 ~= nil and placeId == v90.placeId then
			v91 = if v90.title ~= "" then v90.title else nil
			v92 = if v90.description ~= "" then v90.description else nil
		elseif v59 ~= nil then
			v91 = v59.title
			v92 = v59.description
		end

		sendBuildExperienceEvent("PUBLISH_CLICK", {
			universeId = t6.target.universeId,
			placeId = placeId,
			conversationId = t6.target.sessionId
		})
		v71(true)
		v77()

		local v93 = v63 ~= nil and v63.isActive == true;

		((if not FFlagEnableProvisionalRating then GameConfigurationActions.saveAndPublishPlace({
			placeId = placeId,
			title = v91,
			description = v92
		}) else GameConfigurationActions.publishExperience({
			universeId = t6.target.universeId,
			placeId = placeId,
			title = v91,
			description = v92,
			isActive = v93,
			audiences = buildPublicAudiences(if not v63 then nil else v63.audiences)
		}))):andThen(function(p2) -- line: 265
			-- upvalues: GetVersionInformationStore (copy), placeId (copy), v56 (copy), v73 (copy), LocalizationStrings (copy)
			local status = p2.status
			local version = p2.version

			if status ~= "success" or (typeof(version) ~= "string" or version == "") then
				error({
					errorMessage = "save_and_publish expected status=success and a non-empty version; " .. `got status={ tostring(status) }, version={ tostring(version) }`
				})
			end

			GetVersionInformationStore().clearDraft(placeId)
			v56.fetchHistory(placeId)
			v73(LocalizationStrings.GAME_CONFIGURATION_PUBLISH_SUCCESS)
		end):catch(function(p3) -- line: 278
			-- upvalues: debug (copy), placeId (copy), t6 (copy), v73 (copy), LocalizationStrings (copy)
			local v99 = typeof(p3) == "table"

			debug.log("warn", "build_experience publish failed", {
				stage = "save_and_publish",
				errorMessage = if not v99 or p3.errorMessage == nil then tostring(p3) else tostring(p3.errorMessage),
				placeId = placeId,
				responseCode = if not v99 then nil else p3.responseCode,
				universeId = t6.target.universeId
			})
			v73(LocalizationStrings.GAME_CONFIGURATION_PUBLISH_ERROR)
		end):finally(function() -- line: 291
			-- upvalues: v71 (copy)
			v71(false)
		end)
	end, {
		v77,
		v70,
		v56,
		t6.target.placeId,
		t6.target.sessionId,
		t6.target.universeId,
		v59,
		v63
	})
	local v83 = `{ t6.testId }.actions`

	return React.createElement(View, {
		LayoutOrder = 3,
		tag = "col gap-small size-full-0 auto-y bg-surface-0"
	}, {
		PublishSnackbarWrapper = if v72 == "" then nil else React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-x-center size-full-0 auto-y padding-x-large"
		}, {
			PublishSnackbar = React.createElement(PrivateShareTooltip, {
				LayoutOrder = 1,
				isOpen = v74 == "private" and v64 == PrivacyType.Private
			}, {
				Snackbar = React.createElement(Snackbar, {
					LayoutOrder = 1,
					title = v72,
					action = if not v76 then nil else {
						text = LocalizationStrings.GAME_CONFIGURATION_SHARE,
						onActivated = v79
					},
					onClose = if not v76 then v77 else nil,
					testId = `{ t6.testId }.publish-snackbar`
				})
			})
		}),
		Actions = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row gap-small size-full-0 auto-y padding-y-medium",
			testId = v83
		}, {
			Publish = FFlagEnableProvisionalRating and React.createElement(Button, {
				LayoutOrder = 1,
				text = if not v65 then LocalizationStrings.GAME_CONFIGURATION_PUBLISH else LocalizationStrings.GAME_CONFIGURATION_UPDATE_RATING,
				size = InputSize.Medium,
				variant = ButtonVariant.Emphasis,
				fillBehavior = FillBehavior.Fill,
				isDisabled = t6.target.placeId == nil,
				isLoading = v70,
				onActivated = if not v65 then v82 else v81,
				width = UDim.new(1, 0),
				testId = `{ v83 }-publish`
			}),
			Preview = if t6.showPreviewButton ~= false then React.createElement(PreviewButton, {
				target = t6.target,
				actionsTestId = v83
			}) else nil
		}),
		FriendsOnlyShareDialog = if v74 ~= "friends" or v64 ~= PrivacyType.FriendsOnly then nil else React.createElement(FriendsOnlyShareDialog, {
			onCancel = v80,
			onShare = v78
		})
	})
end

return PublishFooter
