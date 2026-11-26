local CorePackages = game:GetService("CorePackages")

local Players = game:GetService("Players")

local React = require(CorePackages.Packages.React)
local Promise = require(CorePackages.Packages.Promise)
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useStore = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useStore
local module = require("@luauforge/bundled/eie")
local module2 = require("@luauforge/bundled/egx")
local useDeviceInsets = require("@game/CorePackages/Workspace/Packages/Responsive").useDeviceInsets
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local module3 = require("@luauforge/deferred/gTM")
local fullView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Enums.FullView
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local module5 = require("@luauforge/deferred/hcO")
local backgroundGenerationPage = module5.BackgroundGenerationPage
local publishBackgroundSheet = module5.PublishBackgroundSheet
local publishConfirmDialog = module5.PublishConfirmDialog
local useBackgroundGenerationController = module5.useBackgroundGenerationController
local usePublishController = module5.usePublishController
local promptUtils = module5.promptUtils
local backgroundGenerationAnalytics = module5.BackgroundGenerationAnalytics
local publishStage = backgroundGenerationAnalytics.PublishStage
local fFlagAXBackgroundGenerationAnalytics = AvatarExperienceFlags.FFlagAXBackgroundGenerationAnalytics
local fFlagAXBackgroundGenerationOptimisticGrant = AvatarExperienceFlags.FFlagAXBackgroundGenerationOptimisticGrant

local fFlagAXBackgroundGenerationPollPublishedInventory = AvatarExperienceFlags.FFlagAXBackgroundGenerationPollPublishedInventory

local fIntAXBackgroundGenerationPostPublishRefetchIntervalMs = AvatarExperienceFlags.FIntAXBackgroundGenerationPostPublishRefetchIntervalMs

local fIntAXBackgroundGenerationPostPublishRefetchMaxAttempts = AvatarExperienceFlags.FIntAXBackgroundGenerationPostPublishRefetchMaxAttempts
local fFlagAXBackgroundUploadQuotaError = AvatarExperienceFlags.FFlagAXBackgroundUploadQuotaError
local fFlagAXPhotoboothMomentsBugFixes = AvatarExperienceFlags.FFlagAXPhotoboothMomentsBugFixes
local module6 = require("@luauforge/deferred/hkQ")

local module7 = require("@luauforge/deferred/gRz")

local module8 = require("@luauforge/deferred/gRB")

local module9 = require("@luauforge/bundled/fCn")
local useAvatarEditorStores = module9.Context.useAvatarEditorStores
local avatarEditorCategories = require("@luauforge/bundled/dPt").Enums.AvatarEditorCategories
local module10 = require("@luauforge/bundled/dRz")

local module11 = require("@luauforge/bundled/dRL")
local module12 = require("@luauforge/deferred/gJZ")
local module13 = require("@luauforge/bundled/hkR")
local module14 = require("@luauforge/bundled/dQm")
local module15 = require("@luauforge/bundled/dPN")
local module16 = require("@luauforge/bundled/gJz")

local v5 = {
	minute = "Feature.Avatar.BackgroundGeneration.Error.LimitReachedMinute",
	hour = "Feature.Avatar.BackgroundGeneration.Error.LimitReachedHour",
	day = "Feature.Avatar.BackgroundGeneration.Error.LimitReachedDay"
}

local v6 = {
	Hourly = "Feature.Avatar.BackgroundGeneration.Error.UploadQuotaHourly",
	Daily = "Feature.Avatar.BackgroundGeneration.Error.UploadQuotaDaily",
	Monthly = "Feature.Avatar.BackgroundGeneration.Error.UploadQuotaMonthly",
	AllTime = "Feature.Avatar.BackgroundGeneration.Error.UploadQuotaAllTime"
}

local count = 0
local v7 = {}

local function cancelActiveInventoryPoll()
	count += 1

	for k, connection in v7 do
		connection:Disconnect()
	end

	table.clear(v7)
end

local function isInventoryPollActive(p2): boolean
	return p2 == count
end

local function watchForLocalUserChange(p2)
	local localPlayer = Players.LocalPlayer
	local userId = if localPlayer then localPlayer.UserId else nil
	local connection = nil

	local function cancelIfLocalUserChanged()
		if p2 ~= count then
			return
		end

		local localPlayer2 = Players.LocalPlayer
		local v8 = if localPlayer2 then localPlayer2.UserId else nil

		if localPlayer2 ~= localPlayer or v8 ~= userId then
			count += 1

			for k, connection2 in v7 do
				connection2:Disconnect()
			end

			table.clear(v7)
		end
	end

	local function bindUserIdConnection()
		if connection then
			connection:Disconnect()
			connection = nil
		end

		local localPlayer2 = Players.LocalPlayer

		if localPlayer2 then
			local userIdChangedConnection = localPlayer2:GetPropertyChangedSignal("UserId"):Connect(cancelIfLocalUserChanged)
			connection = userIdChangedConnection
			table.insert(v7, userIdChangedConnection)
		end
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	local localPlayer2 = Players.LocalPlayer

	if localPlayer2 then
		local userIdChangedConnection = localPlayer2:GetPropertyChangedSignal("UserId"):Connect(cancelIfLocalUserChanged)
		connection = userIdChangedConnection
		table.insert(v7, userIdChangedConnection)
	end

	table.insert(v7, Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
		if p2 ~= count then
			return
		end

		if connection then
			connection:Disconnect()
			connection = nil
		end

		local localPlayer3 = Players.LocalPlayer

		if localPlayer3 then
			local userIdChangedConnection = localPlayer3:GetPropertyChangedSignal("UserId"):Connect(cancelIfLocalUserChanged)
			connection = userIdChangedConnection
			table.insert(v7, userIdChangedConnection)
		end

		if p2 ~= count then
			return
		end

		local localPlayer4 = Players.LocalPlayer
		local v8 = if localPlayer4 then localPlayer4.UserId else nil

		if localPlayer4 ~= localPlayer or v8 ~= userId then
			count += 1

			for k, connection2 in v7 do
				connection2:Disconnect()
			end

			table.clear(v7)
		end
	end))
end

local function BackgroundGenerationPageContainer(p2)
	local v8 = useNavigation()
	local v9 = module(module2)
	local v10 = useDispatch()
	local v11, v12

	if fFlagAXBackgroundGenerationPollPublishedInventory then
		v11 = useStore()
		v12 = useAvatarEditorStores()
	else
		v12 = nil
		v11 = nil
	end

	local v13 = module(module16)
	local staleInventoryGrantStore = module9.Stores.getStaleInventoryGrantStore()
	local v14 = if AvatarExperienceFlags.FFlagAXFixBackgroundGenerationResultMenuNavigation then module8(p2) else nil

	local state, setState = React.useState("")
	local top = useDeviceInsets().top
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)

	local v15 = useBackgroundGenerationController(v9)
	local v16 = usePublishController(v9, v15.generationId)

	local v17 = module6(v15.presignedUrl)

	local v18 = React.useCallback(function(p3)
		setState(promptUtils.clampPrompt(p3))
	end, {})

	local v19, v20 = module3()
	React.useEffect(function()
		v20(fullView.SceneFullView)
		return function()
			v20(fullView.None)
		end
	end, { v20 })

	local useCallback = React.useCallback
	local function fn()
		if fFlagAXBackgroundGenerationAnalytics then
			backgroundGenerationAnalytics.sendBackClick(v15.state)
		end

		v8.pop()
	end
	local v22 = if fFlagAXBackgroundGenerationAnalytics then v15.state else nil
	local v23 = useCallback(fn, { v8, v22 })

	local useCallback2 = React.useCallback
	local function fn2()
		if fFlagAXBackgroundGenerationAnalytics then
			backgroundGenerationAnalytics.sendGenerateClick(v15.state)
		end

		v15.submit(state)
	end

	local submit = v15.submit

	local v25 = if fFlagAXBackgroundGenerationAnalytics then v15.state else nil
	local v26 = useCallback2(fn2, { submit, state, v25 })

	local v27 = v15.state == "generating"
	local v28 = v15.state == "completed" and v17 ~= "rendered" and v17 ~= "failed"

	local v29 = v27 or v28

	local v30 = v15.state == "error"
	local v31 = v15.state == "completed" and v17 == "failed"
	local v32 = v30 or v31

	local v33 = {
		title = "Feature.Avatar.BackgroundGeneration.Title",
		promptPlaceholder = "Feature.Avatar.BackgroundGeneration.PromptPlaceholder",
		statusGenerating = "Feature.Avatar.BackgroundGeneration.Status.Generating",
		statusPreparing = "Feature.Avatar.BackgroundGeneration.Status.Preparing",
		errorModeration = "Feature.Avatar.BackgroundGeneration.Error.Moderation",
		errorSystem = "Feature.Avatar.BackgroundGeneration.Error.System",
		errorLimitReached = v5[v15.limitPeriod or ""] or "Feature.Avatar.BackgroundGeneration.Error.LimitReached",
		publishAction = "Feature.Avatar.BackgroundGeneration.Action.Publish",
		menuReset = "Feature.Avatar.Action.Reset",
		publishTitle = "Feature.Avatar.BackgroundGeneration.Title.PublishBackground",
		publishNameLabel = "Feature.Avatar.BackgroundGeneration.Label.Name",
		publishDescriptionLabel = "Feature.Avatar.BackgroundGeneration.Label.Description",
		publishConfirmTitle = "Feature.Avatar.BackgroundGeneration.Title.PublishToInventory",
		publishConfirmBody = "Feature.Avatar.BackgroundGeneration.Description.ReviewBeforePublish",
		publishCancel = "Feature.Avatar.BackgroundGeneration.Action.Cancel",
		publishDisplayNameCount = {
			"Feature.Avatar.BackgroundGeneration.Label.CharacterCount",
			count = utf8.len(v16.displayName) or 0,
			max = AvatarExperienceFlags.FIntAXBackgroundPublishNameMaxLength
		},
		publishDescriptionCount = {
			"Feature.Avatar.BackgroundGeneration.Label.CharacterCount",
			count = utf8.len(v16.description) or 0,
			max = AvatarExperienceFlags.FIntAXBackgroundPublishDescriptionMaxLength
		}
	}

	if fFlagAXBackgroundUploadQuotaError then
		v33.errorUploadQuota = v6[v16.quotaPeriod or ""]
			or "Feature.Avatar.BackgroundGeneration.Error.System"
	end

	local v34 = useLocalization(v33)

	local v35 = if v27 then v34.statusGenerating elseif v28 then v34.statusPreparing else nil
	local v36

	if v32 then
		if v30 and v15.errorType == "moderation" then
			v36 = v34.errorModeration
		else
			v36 = if v30 and v15.errorType == "rateLimited" then v34.errorLimitReached else v34.errorSystem
		end
	end

	local v37 = v15.state == "completed"
	local v38 = v16.state == "uploading" or v16.state == "polling"
	local v39 = v16.state == "error"

	local function onPublishPressed()
		if fFlagAXBackgroundGenerationAnalytics then
			backgroundGenerationAnalytics.sendPublishClick(publishStage.ResultMenu)
		end

		setState2(true)
	end
	local function onDeletePressed()
		if fFlagAXBackgroundGenerationAnalytics then
			backgroundGenerationAnalytics.sendDiscardClick()
		end

		v15.reset()
		v16.clear()
		setState("")
	end

	local v40 = React.useCallback(function()
		setState2(false)
	end, {})

	local function fn3()
		if fFlagAXBackgroundGenerationAnalytics then
			backgroundGenerationAnalytics.sendPublishClick(publishStage.DetailsSheet)
		end

		if v39 then
			v16.reset()
		end

		setState3(true)
	end

	local function v41()
		if fFlagAXBackgroundGenerationAnalytics then
			backgroundGenerationAnalytics.sendPublishClick(publishStage.ConfirmationDialog)
		end

		v16.submit()
	end

	local function fn4()
		if not v38 then
			setState3(false)
		end
	end

	local useCallback3 = React.useCallback
	local function fn5(p3)
		setState3(false)
		local v42 = tostring(p3)

		if v42 ~= "" then
			v10(module14(v42, true))

			if fFlagAXBackgroundGenerationOptimisticGrant then
				v10(module13(module15.AssetTypeIdStrings.AvatarBackground, v42, v9, v13))
			end
		end

		for k, v43 in module10() do
			if v43.Id == avatarEditorCategories.Backgrounds and v43.SearchUuid then
				local searchUuid = v43.SearchUuid
				local v44 = if v12 and v43.NavigationKey then v12.categoryInventoryStores[v43.NavigationKey] else nil

				local function markBackgroundInventoryStale()
					if not (v44 and v44.isRefreshPending()) then
						staleInventoryGrantStore.markSearchUuidStale(searchUuid)
					end
				end

				if not (v44 and v44.isRefreshPending()) then
					staleInventoryGrantStore.markSearchUuidStale(searchUuid)
				end

				local v46 = v11

				if
					fFlagAXBackgroundGenerationPollPublishedInventory
					and v42 ~= ""
					and fIntAXBackgroundGenerationPostPublishRefetchMaxAttempts > 0
					and v46
				then
					count += 1

					for k2, connection in v7 do
						connection:Disconnect()
					end

					table.clear(v7)

					local v47 = count
					watchForLocalUserChange(v47)
					local scheduleRefetch
					local v48 = v44

					scheduleRefetch = function(p4)
						Promise.delay(fIntAXBackgroundGenerationPostPublishRefetchIntervalMs / 1000):andThen(function()
							if v47 ~= count then
								return
							end

							local assetInfo = v46:getState().AvatarExperience.Common.AssetInfos[v42]

							if
								not assetInfo
								or not assetInfo.receivedFromInventoryFetch
								or assetInfo.moderationStatus ~= Enum.ModerationStatus.ReviewedApproved
							then
								if not (v48 and v48.isRefreshPending()) then
									staleInventoryGrantStore.markSearchUuidStale(searchUuid)
								end

								if p4 < fIntAXBackgroundGenerationPostPublishRefetchMaxAttempts then
									scheduleRefetch(p4 + 1)
									return
								end
							end

							count += 1

							for k2, connection in v7 do
								connection:Disconnect()
							end

							table.clear(v7)
						end):catch(function(p5)
							if v47 ~= count then
								return
							end

							warn(`Background inventory polling failed: {p5}`)

							if p4 < fIntAXBackgroundGenerationPostPublishRefetchMaxAttempts then
								scheduleRefetch(p4 + 1)
								return
							end

							count += 1

							for k2, connection in v7 do
								connection:Disconnect()
							end

							table.clear(v7)
						end)
					end

					scheduleRefetch(1)
				end

				v10(module12(v43.Category, nil, v13))
				break
			end
		end

		if fFlagAXPhotoboothMomentsBugFixes then
			local v43 = module11()

			if v43 and v43.SearchUuid then
				staleInventoryGrantStore.markSearchUuidStale(v43.SearchUuid)
			end
		end

		setState2(false)
		v8.pop()
	end

	local v43 = if fFlagAXBackgroundGenerationPollPublishedInventory then v11 else nil
	local v45 = useCallback3(fn5, {
		v13,
		v10,
		v8,
		v9,
		staleInventoryGrantStore,
		v43,
		if fFlagAXBackgroundGenerationPollPublishedInventory then v12 else nil
	})

	local v46 = React.useCallback(function()
		setState3(false)
	end, {})

	React.useEffect(function()
		if v16.state == "completed" and v16.assetId then
			v45(v16.assetId)
		elseif v39 then
			v46()
		end
	end, { v39, v45, v46, v16.assetId, v16.state })

	local createElement = React.createElement
	local fragment = React.Fragment
	local children = {
		Page = React.createElement(backgroundGenerationPage, {
			onBackButtonPressed = v23,
			prompt = state,
			onPromptChanged = v18,
			onSubmit = v26,
			topInset = top,
			title = v34.title,
			placeholder = v34.promptPlaceholder,
			isSubmitEnabled = promptUtils.isPromptSubmittable(state) and not v29,
			isInputDisabled = v29,
			hasError = v32,
			errorMessage = v36,
			isLoading = v29,
			loadingText = v35,
			onPublishPressed = onPublishPressed,
			onDeletePressed = onDeletePressed,
			menuPublishLabel = v34.publishAction,
			menuDeleteLabel = v34.menuReset,
			isResultReady = v37,
			isVisible = v14
		}),
		PublishSheet = 0,
		PublishConfirm = 0
	}

	local createElement2 = React.createElement
	local v49 = {
		isOpen = state2,
		title = v34.publishTitle,
		nameLabel = v34.publishNameLabel,
		descriptionLabel = v34.publishDescriptionLabel,
		publishLabel = v34.publishAction,
		displayName = v16.displayName,
		onDisplayNameChanged = v16.setDisplayName,
		displayNameCountText = v34.publishDisplayNameCount,
		description = v16.description,
		onDescriptionChanged = v16.setDescription,
		descriptionCountText = v34.publishDescriptionCount,
		isPublishEnabled = v16.canSubmit,
		isPublishing = v38,
		isFocusNavigationEnabled = 0,
		hasError = 0,
		errorMessage = 0,
		onPublish = 0,
		onClose = 0
	}

	local v50 = if AvatarExperienceFlags.FFlagAXFixBackgroundGenerationResultMenuNavigation then not state3 else nil
	v49.isFocusNavigationEnabled = v50

	v49.hasError = v39
	local v51

	if v39 then
		if fFlagAXBackgroundUploadQuotaError and v16.errorKind == "QuotaReached" then
			v51 = v34.errorUploadQuota
		else
			v51 = v34.errorSystem
		end
	end

	v49.errorMessage = v51

	v49.onPublish = fn3
	v49.onClose = v40
	children.PublishSheet = createElement2(publishBackgroundSheet, v49)

	local createElement3 = React.createElement
	local v53 = {
		isOpen = state3,
		isLoading = v38,
		title = v34.publishConfirmTitle,
		body = v34.publishConfirmBody,
		cancelLabel = v34.publishCancel,
		publishLabel = v34.publishAction,
		onConfirm = 0,
		onCancel = 0
	}

	if not fFlagAXBackgroundGenerationAnalytics then
		v41 = v16.submit
	end

	v53.onConfirm = v41
	v53.onCancel = fn4
	children.PublishConfirm = createElement3(publishConfirmDialog, v53)
	return createElement(fragment, nil, children)
end

return (module7(BackgroundGenerationPageContainer))
