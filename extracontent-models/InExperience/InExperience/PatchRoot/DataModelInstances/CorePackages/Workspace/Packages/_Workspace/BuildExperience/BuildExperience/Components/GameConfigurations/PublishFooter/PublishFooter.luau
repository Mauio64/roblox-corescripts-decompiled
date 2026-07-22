local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local GameDetail = require(BuildExperienceParent.GameDetail)
local Navigation = require(BuildExperienceParent.Navigation)
local React = require(BuildExperienceParent.React)
local Signals = require(BuildExperienceParent.Signals)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local PlaceVersionHistory = require(BuildExperienceParent.DataHydration.PlaceVersionHistory)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FriendsOnlyShareDialog = require(BuildExperience.Components.ShareAudience.FriendsOnlyShareDialog)
local PrivateShareTooltip = require(BuildExperience.Components.ShareAudience.PrivateShareTooltip)
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local PublishConfirmationDialog = require(script.Parent.PublishConfirmationDialog)
local Button = Foundation.Button
local Snackbar = Foundation.Snackbar
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local PrivacyType = UniverseConfiguration.PrivacyType
local useStore = require(BuildExperienceParent.RoactUtils).Hooks.RoactRodux.useStore
local getRootNavigation = Navigation.getRootNavigation
local useNavigation = Navigation.useNavigation
local OpenGameDetails = GameDetail.OpenGameDetails
local debug = CreatorAgentChat.debug
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local sharePublishedExperience = require(BuildExperience.utils.sharePublishedExperience).sharePublishedExperience

local function getGameDetailsNavigation(p1) -- line: 52
	if typeof(p1.clearAppScreens) == "function" then
		return p1
	end

	local v36 = table.clone(p1)

	function v36.clearAppScreens(t1: {[any]: any}) -- line: 58
		-- upvalues: p1 (copy)
		p1.dispatch({
			type = "ClearAppScreensAction",
			routeNames = t1
		})
	end

	return v36
end
local function PreviewButton(t2: {[any]: any}) -- line: 76
	-- upvalues: useStore (copy), useNavigation (copy), React (copy), getRootNavigation (copy), OpenGameDetails (copy), Button (copy), LocalizationStrings (copy), InputSize (copy), ButtonVariant (copy), FillBehavior (copy)
	local v38 = useStore()
	local v39 = useNavigation()
	local v40 = React.useCallback(function() -- line: 83
		-- upvalues: getRootNavigation (copy), v39 (copy), OpenGameDetails (copy), t2 (copy), v38 (copy)
		local v67 = getRootNavigation(v39)
		local v68 = OpenGameDetails
		local str = tostring(t2.target.universeId)
		local v70

		if typeof(v67.clearAppScreens) == "function" then
			v70 = v67
		else
			v70 = table.clone(v67)

			function v70.clearAppScreens(t3: {[any]: any}) -- line: 58
				-- upvalues: v67 (copy)
				v67.dispatch({
					type = "ClearAppScreensAction",
					routeNames = t3
				})
			end
		end

		v68(str, v70, {
			source = "BuildExperiencePublish"
		})(v38)
	end, {
		v39,
		t2.target.universeId,
		v38
	})

	return React.createElement(Button, {
		LayoutOrder = 2,
		text = LocalizationStrings.GAME_CONFIGURATION_PREVIEW,
		size = InputSize.Medium,
		variant = ButtonVariant.Standard,
		fillBehavior = FillBehavior.Fill,
		onActivated = v40,
		width = UDim.new(1, 0),
		testId = `{ t2.actionsTestId }-preview`
	})
end
local function PublishFooter(t4: {[any]: any}) -- line: 102
	-- upvalues: SignalsReact (copy), PlaceVersionHistory (copy), React (copy), Signals (copy), UniverseConfiguration (copy), GameConfigurationLabels (copy), LocalizationStrings (copy), sharePublishedExperience (copy), PrivacyType (copy), sendBuildExperienceEvent (copy), GameConfigurationActions (copy), debug (copy), View (copy), PublishConfirmationDialog (copy), PrivateShareTooltip (copy), Snackbar (copy), Button (copy), InputSize (copy), ButtonVariant (copy), FillBehavior (copy), PreviewButton (copy), FriendsOnlyShareDialog (copy)
	local v42 = SignalsReact.useSignalState(PlaceVersionHistory.getPlaceVersionHistoryStore)
	local v43 = React.useMemo(function() -- line: 104
		-- upvalues: t4 (copy), Signals (copy), v42 (copy)
		if t4.target.placeId == nil then
			return (Signals.createSignal(nil))
		end

		return v42.getAndFetchHistory(t4.target.placeId).data
	end, {
		v42,
		t4.target.placeId
	})
	local v44 = SignalsReact.useSignalState(v43)
	local v45 = if not v44 then nil else v44.placeVersions[1]
	local v46 = SignalsReact.useSignalState(UniverseConfiguration.getUniverseConfigurationStore)
	local v47 = SignalsReact.useSignalState(v46.getAndFetchConfiguration(t4.target.universeId).data)
	local v48 = GameConfigurationLabels.getAudience(v47)
	local v49, v50 = React.useState(false)
	local v51, v52 = React.useState(false)
	local v53, v54 = React.useState("")
	local v55, v56 = React.useState(nil)
	local v57 = v53 == LocalizationStrings.GAME_CONFIGURATION_PUBLISH_SUCCESS and (t4.target.placeId ~= nil and v48 ~= nil)
	local v58 = React.useCallback(function() -- line: 126
		-- upvalues: v54 (copy), v56 (copy)
		v54("")
		v56(nil)
	end, {})
	local v59 = React.useCallback(function() -- line: 131
		-- upvalues: t4 (copy), v56 (copy), sharePublishedExperience (copy), v54 (copy), LocalizationStrings (copy)
		if t4.target.placeId == nil then
			return
		end

		v56(nil)

		if sharePublishedExperience(t4.target.placeId).copiedToClipboard then
			v54(LocalizationStrings.GAME_CONFIGURATION_LINK_COPIED)
		end
	end, { t4.target.placeId })
	local v60 = React.useCallback(function() -- line: 144
		-- upvalues: v48 (copy), PrivacyType (copy), v56 (copy), v55 (copy), v59 (copy)
		if v48 == PrivacyType.Private then
			v56(v55 ~= "private" and "private" or nil)

			return
		end

		if v48 == PrivacyType.FriendsOnly then
			v56("friends")

			return
		end

		if v48 == PrivacyType.Public then
			v59()
		end
	end, {
		v48,
		v55,
		v59
	})
	local v61 = React.useCallback(function() -- line: 162
		-- upvalues: v56 (copy)
		v56(nil)
	end, {})
	local v62 = React.useCallback(function() -- line: 166
		-- upvalues: v52 (copy)
		v52(false)
	end, {})
	local v63 = React.useCallback(function() -- line: 170
		-- upvalues: v49 (copy), t4 (copy), v52 (copy)
		if not v49 and t4.target.placeId ~= nil then
			v52(true)
		end
	end, {
		v49,
		t4.target.placeId
	})
	local v64 = React.useCallback(function(s1: string?, s2: string?) -- line: 177
		-- upvalues: v52 (copy), v49 (copy), t4 (copy), sendBuildExperienceEvent (copy), v50 (copy), v58 (copy), GameConfigurationActions (copy), v42 (copy), v54 (copy), LocalizationStrings (copy), debug (copy)
		v52(false)

		if v49 then
			return
		end

		local placeId = t4.target.placeId

		if placeId == nil then
			return
		end

		sendBuildExperienceEvent("PUBLISH_CLICK", {
			universeId = t4.target.universeId,
			placeId = placeId,
			conversationId = t4.target.sessionId
		})
		v50(true)
		v58()
		GameConfigurationActions.saveAndPublishPlace({
			placeId = placeId,
			title = s1,
			description = s2
		}):andThen(function(p2) -- line: 200
			-- upvalues: v42 (copy), placeId (copy), v54 (copy), LocalizationStrings (copy)
			local status = p2.status
			local version = p2.version

			if status ~= "success" or (typeof(version) ~= "string" or version == "") then
				error({
					errorMessage = "save_and_publish expected status=success and a non-empty version; " .. `got status={ tostring(status) }, version={ tostring(version) }`
				})
			end

			v42.fetchHistory(placeId)
			v54(LocalizationStrings.GAME_CONFIGURATION_PUBLISH_SUCCESS)
		end):catch(function(p3) -- line: 212
			-- upvalues: debug (copy), placeId (copy), t4 (copy), v54 (copy), LocalizationStrings (copy)
			local v79 = typeof(p3) == "table"

			debug.log("warn", "build_experience publish failed", {
				stage = "save_and_publish",
				errorMessage = if not v79 or p3.errorMessage == nil then tostring(p3) else tostring(p3.errorMessage),
				placeId = placeId,
				responseCode = if not v79 then nil else p3.responseCode,
				universeId = t4.target.universeId
			})
			v54(LocalizationStrings.GAME_CONFIGURATION_PUBLISH_ERROR)
		end):finally(function() -- line: 225
			-- upvalues: v50 (copy)
			v50(false)
		end)
	end, {
		v58,
		v49,
		v42,
		t4.target.placeId,
		t4.target.sessionId,
		t4.target.universeId
	})
	local v65 = `{ t4.testId }.actions`

	return React.createElement(View, {
		LayoutOrder = 3,
		tag = "col gap-small size-full-0 auto-y bg-surface-0"
	}, {
		PublishConfirmation = if not v51 then nil else React.createElement(PublishConfirmationDialog, {
			onConfirm = v64,
			onCancel = v62,
			defaultTitle = if not v45 then nil else v45.title,
			defaultDescription = if not v45 then nil else v45.description,
			disablePortal = t4.disablePublishDialogPortal,
			hasBackdrop = t4.hasPublishDialogBackdrop,
			testId = `{ t4.testId }.publish-confirmation-dialog`
		}),
		PublishSnackbarWrapper = if v53 == "" then nil else React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-x-center size-full-0 auto-y padding-x-large"
		}, {
			PublishSnackbar = React.createElement(PrivateShareTooltip, {
				LayoutOrder = 1,
				isOpen = v55 == "private" and v48 == PrivacyType.Private
			}, {
				Snackbar = React.createElement(Snackbar, {
					LayoutOrder = 1,
					title = v53,
					action = if not v57 then nil else {
						text = LocalizationStrings.GAME_CONFIGURATION_SHARE,
						onActivated = v60
					},
					onClose = if not v57 then v58 else nil,
					testId = `{ t4.testId }.publish-snackbar`
				})
			})
		}),
		Actions = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row gap-small size-full-0 auto-y padding-y-medium",
			testId = v65
		}, {
			Publish = React.createElement(Button, {
				LayoutOrder = 1,
				text = LocalizationStrings.GAME_CONFIGURATION_PUBLISH,
				size = InputSize.Medium,
				variant = ButtonVariant.Emphasis,
				fillBehavior = FillBehavior.Fill,
				isDisabled = t4.target.placeId == nil,
				isLoading = v49,
				onActivated = v63,
				width = UDim.new(1, 0),
				testId = `{ v65 }-publish`
			}),
			Preview = if t4.showPreviewButton ~= false then React.createElement(PreviewButton, {
				target = t4.target,
				actionsTestId = v65
			}) else nil
		}),
		FriendsOnlyShareDialog = if v55 ~= "friends" or v48 ~= PrivacyType.FriendsOnly then nil else React.createElement(FriendsOnlyShareDialog, {
			onCancel = v61,
			onShare = v59
		})
	})
end

return PublishFooter
