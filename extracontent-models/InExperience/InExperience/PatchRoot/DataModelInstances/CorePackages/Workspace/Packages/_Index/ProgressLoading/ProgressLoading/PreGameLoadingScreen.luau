local ProgressLoading = script:FindFirstAncestor("ProgressLoading")
local parent = ProgressLoading.Parent

local Foundation = require(parent.Foundation)
local ColorMode = Foundation.Enums.ColorMode

local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Rodux = require(parent.Rodux)
local RoactRodux = require(parent.RoactRodux)

local UIBlox = require(parent.UIBlox)
local Constants = UIBlox.App.Style.Constants
local Style = require(parent.Style)
local UiModeStyleProvider = Style.UiModeStyleProvider
local Responsive = require(parent.Responsive)
local CachedPolicyService = require(parent.CachedPolicyService)

local LoadingScreenView = require(script.Parent.LoadingScreenView)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableTiltLoadingScreen = SharedFlags.FFlagEnableTiltLoadingScreen
local GetDeferredAssetStore = require(script.Parent.Stores.GetDeferredAssetStore)
local PregameOverride = require(script.Parent.Stores.PregameOverride)
local getJoiningPlace = require(script.Parent.getJoiningPlace)
local createNetworking = require(script.Parent.createNetworking)
local Http = require(parent.Http)
local Url = Http.Url

local EngineFeatureEnableDeferredAssetManagerService = require(ProgressLoading.Flags.EngineFeatureEnableDeferredAssetManagerService)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagBuildExperienceLibrary = SharedFlags2.FFlagBuildExperienceLibrary
local DeferredAssetManagerService

if EngineFeatureEnableDeferredAssetManagerService then
	DeferredAssetManagerService = game:GetService("DeferredAssetManagerService")
else
	DeferredAssetManagerService = nil
end

local store = Rodux.Store.new(function(options)
	return options or {}
end, {})

local function getIsLoadingAssets(p)
	local deferredAssetStore = GetDeferredAssetStore(p)

	if deferredAssetStore then
		return deferredAssetStore.getDownloadStatus(p) == Enum.PrefetchDownloadStatus.InProgress
			or deferredAssetStore.getPregameLoadingScreenOnly(p)
	end

	return false
end

local function onCancel()
	if DeferredAssetManagerService then
		DeferredAssetManagerService:CancelPrefetch()
	end
end

local function PregameOverrideScreen(p)
	React.useEffect(function()
		RunService:SetRobloxGuiFocused(true)
		return function()
			RunService:SetRobloxGuiFocused(false)
		end
	end, {})
	return p.override.render({ displayOrder = 9999, onCancel = onCancel })
end

local function PreGameLoadingScreen(_)
	local current = SignalsReact.useSignalState(getIsLoadingAssets)
	local placeId = not current and 0 or getJoiningPlace.getJoiningPlaceId()
	local universeId = not current and 0 or getJoiningPlace.getJoiningUniverseId()

	local ref = React.useRef(nil)
	local override

	if FFlagBuildExperienceLibrary then
		override = SignalsReact.useSignalState(PregameOverride.getPregameOverride)

		if current then
			if ref.current == nil then
				ref.current = os.clock()
			end
		else
			ref.current = nil
		end

		local ref2 = React.useRef(current)
		React.useEffect(function()
			if ref2.current and not current then
				PregameOverride.setPregameOverride(nil)
			end

			ref2.current = current
		end, { current })
	end

	local ref2 = React.useRef(nil)
	ref2.current = Responsive.usePreferredInput()

	local state, setState = React.useState(nil)
	React.useEffect(function()
		if FFlagEnableTiltLoadingScreen then
			return
		end

		if placeId <= 0 then
			setState(nil)
			return
		end

		local v = false
		task.spawn(function()
			local success, result = pcall(function()
				return MarketplaceService:GetProductInfo(placeId)
			end)

			if success and result and not v then
				setState(result)
			end
		end)
		return function()
			v = true
		end
	end, { placeId })

	local state2, setState2 = React.useState(0)
	React.useEffect(function()
		if FFlagEnableTiltLoadingScreen then
			return
		end

		if placeId <= 0 or universeId > 0 then
			setState2(0)
			return
		end

		local v = false
		createNetworking(string.format("%suniverses/v1/places/%d/universe", Url.APIS_URL, placeId), "GET"):andThen(
			function(p)
				if not v and p and p.responseBody and p.responseBody.universeId then
					setState2(p.responseBody.universeId)
				end
			end,
			function() end
		)
		return function()
			v = true
		end
	end, { placeId, universeId })

	local state3, setState3 = React.useState(false)
	React.useEffect(function()
		if FFlagEnableTiltLoadingScreen then
			return
		end

		local v = false
		task.spawn(function()
			local isSubjectToChinaPolicies = CachedPolicyService:IsSubjectToChinaPolicies()

			if not v then
				setState3(isSubjectToChinaPolicies == true)
			end
		end)
		return function()
			v = true
		end
	end, {})

	if not current or placeId <= 0 then
		return nil
	end

	if
		FFlagBuildExperienceLibrary
		and override ~= nil
		and ref.current ~= nil
		and PregameOverride.claims(override, placeId, ref.current)
	then
		return React.createElement(PregameOverrideScreen, { override = override })
	end

	if FFlagEnableTiltLoadingScreen then
		local TiltLoadingScreenContainer = require(script.Parent.TiltLoadingScreen.TiltLoadingScreenContainer)
		return React.createElement(TiltLoadingScreenContainer, {
			key = tostring(placeId),
			placeId = placeId,
			deferredJoin = {
				universeId = universeId,
				assetService = DeferredAssetManagerService,
				displayOrder = 9999
			},
			onCancel = onCancel
		})
	end

	if universeId > 0 then
		state2 = universeId
	end

	return React.createElement(RoactRodux.StoreProvider, { store = store }, {
		StyleProvider = React.createElement(UiModeStyleProvider, {
			style = { themeName = ColorMode.Dark, fontName = Constants.FontName.Gotham }
		}, {
			LoadingScreen = React.createElement(LoadingScreenView, {
				placeId = placeId,
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
