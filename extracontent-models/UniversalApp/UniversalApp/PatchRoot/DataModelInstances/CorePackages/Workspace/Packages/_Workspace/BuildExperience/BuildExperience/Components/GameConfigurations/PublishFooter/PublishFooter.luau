local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local GameDetail = require(BuildExperienceParent.GameDetail)
local Navigation = require(BuildExperienceParent.Navigation)
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local UniverseActivation = require(BuildExperienceParent.DataHydration.UniverseActivation)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local Button = Foundation.Button
local Snackbar = Foundation.Snackbar
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local useStore = require(BuildExperienceParent.RoactUtils).Hooks.RoactRodux.useStore
local getRootNavigation = Navigation.getRootNavigation
local useNavigation = Navigation.useNavigation
local OpenGameDetails = GameDetail.OpenGameDetails
local sharePublishedExperience = require(BuildExperience.utils.sharePublishedExperience).sharePublishedExperience

local function getGameDetailsNavigation(p1) -- line: 42
	if typeof(p1.clearAppScreens) == "function" then
		return p1
	end

	local v26 = table.clone(p1)

	function v26.clearAppScreens(t1: {[any]: any}) -- line: 48
		-- upvalues: p1 (copy)
		p1.dispatch({
			type = "ClearAppScreensAction",
			routeNames = t1
		})
	end

	return v26
end
local function PreviewButton(t2: {[any]: any}) -- line: 64
	-- upvalues: useStore (copy), useNavigation (copy), React (copy), getRootNavigation (copy), OpenGameDetails (copy), Button (copy), InputSize (copy), ButtonVariant (copy), FillBehavior (copy)
	local v28 = useStore()
	local v29 = useNavigation()
	local v30 = React.useCallback(function() -- line: 71
		-- upvalues: getRootNavigation (copy), v29 (copy), OpenGameDetails (copy), t2 (copy), v28 (copy)
		local v47 = getRootNavigation(v29)
		local v48 = OpenGameDetails
		local str = tostring(t2.target.universeId)
		local v50

		if typeof(v47.clearAppScreens) == "function" then
			v50 = v47
		else
			v50 = table.clone(v47)

			function v50.clearAppScreens(t3: {[any]: any}) -- line: 48
				-- upvalues: v47 (copy)
				v47.dispatch({
					type = "ClearAppScreensAction",
					routeNames = t3
				})
			end
		end

		v48(str, v50, {
			source = "BuildExperiencePublish"
		})(v28)
	end, {
		v29,
		t2.target.universeId,
		v28
	})

	return React.createElement(Button, {
		text = "Preview",
		LayoutOrder = 2,
		size = InputSize.Large,
		variant = ButtonVariant.Standard,
		fillBehavior = FillBehavior.Fill,
		onActivated = v30,
		width = UDim.new(1, 0),
		testId = `{ t2.actionsTestId }-preview`
	})
end
local function PublishFooter(t4: {[any]: any}) -- line: 90
	-- upvalues: React (copy), UniverseActivation (copy), SignalsReact (copy), UniverseConfiguration (copy), GameConfigurationLabels (copy), sharePublishedExperience (copy), View (copy), Snackbar (copy), Button (copy), InputSize (copy), ButtonVariant (copy), FillBehavior (copy), PreviewButton (copy)
	local v32 = React.useMemo(function() -- line: 91
		-- upvalues: UniverseActivation (copy)
		return UniverseActivation.getUniverseActivationStore()
	end, {})
	local v33 = SignalsReact.useSignalState(UniverseConfiguration.getUniverseConfigurationStore)
	local v34 = SignalsReact.useSignalState(v33.getAndFetchConfiguration(t4.target.universeId).data)
	local v35 = GameConfigurationLabels.isPrivateAudience(v34)
	local v36, v37 = React.useState(false)
	local v38, v39 = React.useState("")
	local v40, v41 = React.useState(false)
	local v42 = React.useCallback(function() -- line: 102
		-- upvalues: v39 (copy), v41 (copy)
		v39("")
		v41(false)
	end, {})
	local v43 = React.useCallback(function() -- line: 107
		-- upvalues: t4 (copy), v35 (copy), sharePublishedExperience (copy), v39 (copy), v41 (copy)
		if t4.target.placeId == nil or v35 then
			return
		end

		if sharePublishedExperience(t4.target.placeId).copiedToClipboard then
			v39("Link copied to clipboard.")
			v41(false)
		end
	end, {
		v35,
		t4.target.placeId
	})
	local v44 = React.useCallback(function() -- line: 120
		-- upvalues: v36 (copy), v37 (copy), v42 (copy), v32 (copy), t4 (copy), v39 (copy), v41 (copy), v35 (copy)
		if v36 then
			return
		end

		v37(true)
		v42()
		v32.activate(t4.target.universeId):andThen(function() -- line: 129
			-- upvalues: v39 (copy), v41 (copy), t4 (copy), v35 (copy)
			v39("Eligible players can now play this game in Roblox.")
			v41(t4.target.placeId ~= nil and not v35)
		end):catch(function() -- line: 133
			-- upvalues: v39 (copy), v41 (copy)
			v39("Couldn't publish game. Please check Audience settings.")
			v41(false)
		end):finally(function() -- line: 137
			-- upvalues: v37 (copy)
			v37(false)
		end)
	end, {
		v32,
		v42,
		v35,
		v36,
		t4.target.placeId,
		t4.target.universeId
	})
	local v45 = `{ t4.testId }.actions`

	return React.createElement(View, {
		LayoutOrder = 3,
		tag = "col gap-small size-full-0 auto-y bg-surface-0"
	}, {
		PublishSnackbarWrapper = if v38 == "" then nil else React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-x-center size-full-0 auto-y padding-x-large"
		}, {
			PublishSnackbar = React.createElement(Snackbar, {
				LayoutOrder = 1,
				title = v38,
				action = if not v40 then nil else {
					text = "Share",
					onActivated = v43
				},
				onClose = if not v40 then v42 else nil,
				testId = `{ t4.testId }.publish-snackbar`
			})
		}),
		Actions = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row gap-small size-full-0 auto-y padding-y-medium",
			testId = v45
		}, {
			Publish = React.createElement(Button, {
				text = "Publish",
				LayoutOrder = 1,
				size = InputSize.Large,
				variant = ButtonVariant.Emphasis,
				fillBehavior = FillBehavior.Fill,
				isLoading = v36,
				onActivated = v44,
				width = UDim.new(1, 0),
				testId = `{ v45 }-publish`
			}),
			Preview = if t4.showPreviewButton ~= false then React.createElement(PreviewButton, {
				target = t4.target,
				actionsTestId = v45
			}) else nil
		})
	})
end

return PublishFooter
