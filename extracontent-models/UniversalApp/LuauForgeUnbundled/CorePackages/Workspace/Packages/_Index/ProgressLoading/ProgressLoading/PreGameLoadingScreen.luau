local colorMode = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Foundation").Enums.ColorMode

local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SignalsReact")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Rodux")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/RoactRodux")

local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/UIBlox").App.Style.Constants
local uiModeStyleProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Style").UiModeStyleProvider
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Responsive")
local CachedPolicyService = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/CachedPolicyService")

local LoadingScreenView = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenView")
local fFlagEnableTiltLoadingScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FFlagEnableTiltLoadingScreen
local GetDeferredAssetStore = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Stores/GetDeferredAssetStore")
local PregameOverride = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Stores/PregameOverride")
local getJoiningPlace = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/getJoiningPlace")
local createNetworking = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/createNetworking")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Http").Url

local EngineFeatureEnableDeferredAssetManagerService = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Flags/EngineFeatureEnableDeferredAssetManagerService")
local fFlagBuildExperienceLibrary = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FFlagBuildExperienceLibrary

local DeferredAssetManagerService = if EngineFeatureEnableDeferredAssetManagerService then game:GetService("DeferredAssetManagerService") else nil

local store = Rodux.Store.new(function(options)
	return options or {}
end, {})

local function getIsLoadingAssets(p2)
	local v5 = GetDeferredAssetStore(p2)

	if v5 then
		return v5.getDownloadStatus(p2) == Enum.PrefetchDownloadStatus.InProgress
			or v5.getPregameLoadingScreenOnly(p2)
	end

	return false
end

local function onCancel()
	if DeferredAssetManagerService then
		DeferredAssetManagerService:CancelPrefetch()
	end
end

local function PregameOverrideScreen(p2)
	React.useEffect(function()
		RunService:SetRobloxGuiFocused(true)
		return function()
			RunService:SetRobloxGuiFocused(false)
		end
	end, {})
	return p2.override.render({ displayOrder = 9999, onCancel = onCancel })
end

local function PreGameLoadingScreen(p2)
	local v5 = SignalsReact.useSignalState(getIsLoadingAssets)
	local v6 = not v5 and 0 or getJoiningPlace.getJoiningPlaceId()
	local v7 = not v5 and 0 or getJoiningPlace.getJoiningUniverseId()

	local ref = React.useRef(nil)
	local v8

	if fFlagBuildExperienceLibrary then
		v8 = SignalsReact.useSignalState(PregameOverride.getPregameOverride)

		if v5 then
			if ref.current == nil then
				ref.current = os.clock()
			end
		else
			ref.current = nil
		end

		local ref2 = React.useRef(v5)
		React.useEffect(function()
			if ref2.current and not v5 then
				PregameOverride.setPregameOverride(nil)
			end

			ref2.current = v5
		end, { v5 })
	end

	local ref2 = React.useRef(nil)
	ref2.current = Responsive.usePreferredInput()

	local state, setState = React.useState(nil)
	React.useEffect(function()
		if fFlagEnableTiltLoadingScreen then
			return
		end

		if v6 <= 0 then
			setState(nil)
			return
		end

		local v9 = false
		task.spawn(function()
			local success, result = pcall(function()
				return MarketplaceService:GetProductInfo(v6)
			end)

			if success and result and not v9 then
				setState(result)
			end
		end)
		return function()
			v9 = true
		end
	end, { v6 })

	local state2, setState2 = React.useState(0)
	React.useEffect(function()
		if fFlagEnableTiltLoadingScreen then
			return
		end

		if v6 <= 0 or v7 > 0 then
			setState2(0)
			return
		end

		local v9 = false
		createNetworking(string.format("%suniverses/v1/places/%d/universe", url.APIS_URL, v6), "GET"):andThen(
			function(p3)
				if not v9 and p3 and p3.responseBody and p3.responseBody.universeId then
					setState2(p3.responseBody.universeId)
				end
			end,
			function() end
		)
		return function()
			v9 = true
		end
	end, { v6, v7 })

	local state3, setState3 = React.useState(false)
	React.useEffect(function()
		if fFlagEnableTiltLoadingScreen then
			return
		end

		local v9 = false
		task.spawn(function()
			local isSubjectToChinaPolicies = CachedPolicyService:IsSubjectToChinaPolicies()

			if not v9 then
				setState3(isSubjectToChinaPolicies == true)
			end
		end)
		return function()
			v9 = true
		end
	end, {})

	if not v5 or v6 <= 0 then
		return nil
	end

	if
		fFlagBuildExperienceLibrary
		and v8 ~= nil
		and ref.current ~= nil
		and PregameOverride.claims(v8, v6, ref.current)
	then
		return React.createElement(PregameOverrideScreen, { override = v8 })
	end

	if fFlagEnableTiltLoadingScreen then
		local TiltLoadingScreenContainer = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/TiltLoadingScreenContainer")
		return React.createElement(TiltLoadingScreenContainer, {
			key = tostring(v6),
			placeId = v6,
			deferredJoin = {
				universeId = v7,
				assetService = DeferredAssetManagerService,
				displayOrder = 9999
			},
			onCancel = onCancel
		})
	end

	if v7 > 0 then
		state2 = v7
	end

	return React.createElement(RoactRodux.StoreProvider, { store = store }, {
		StyleProvider = React.createElement(uiModeStyleProvider, {
			style = { themeName = colorMode.Dark, fontName = constants.FontName.Gotham }
		}, {
			LoadingScreen = React.createElement(LoadingScreenView, {
				placeId = v6,
				universeId = state2,
				productInfo = state,
				isSubjectToChinaPolicies = state3,
				preferredInputRef = ref2,
				displayOrder = 9999,
				manageRobloxGuiFocus = true,
				onCloseButtonActivated = onCancel,
				onGamepadCancel = onCancel
			})
		})
	})
end

return React.memo(PreGameLoadingScreen)
