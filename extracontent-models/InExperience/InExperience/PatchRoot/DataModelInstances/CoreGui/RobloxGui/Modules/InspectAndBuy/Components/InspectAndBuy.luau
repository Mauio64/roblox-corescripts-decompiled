local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService
local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Symbol = AppCommonLib.Symbol
local renderWithCoreScriptsStyleProvider = require(CoreGui.RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)
local UIBlox = require(CorePackages.Packages.UIBlox)
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local defineFastString = game:DefineFastString("AXInspectAndBuyLayerName", "Experience.Menu")
local defineFastFlag = game:DefineFastFlag("AXEnableInspectAndBuyExposureLogging", false)

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusRoot = FocusNavigationUtils.FocusRoot
local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider

local Chrome = RobloxGui.Modules.Chrome
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local Enabled = Chrome2.Enabled
local Service

if Enabled() then
	Service = require(Chrome.Service)
else
	Service = nil
end

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls

local parent = script.Parent.Parent
local SetDetailsInformation = require(parent.Actions.SetDetailsInformation)
local SetTryingOnInfo = require(parent.Actions.SetTryingOnInfo)
local Thunk = require(parent.Thunk)
local Network = require(parent.Services.Network)
local Analytics = require(parent.Services.Analytics)
local InspectAndBuyReducer = require(parent.Reducers.InspectAndBuyReducer)
local Container = require(parent.Components.Container)
local InspectAndBuyBaseContainer = require(parent.Components.InspectAndBuyBaseContainer)
local Constants = require(parent.Constants)
local CompactView = require(parent.CompactView)
local WideView = require(parent.WideView)
local WideLandscapeView = require(parent.WideLandscapeView)
local SetGamepadEnabled = require(parent.Actions.SetGamepadEnabled)
local SetView = require(parent.Actions.SetView)
local SetPlayerId = require(parent.Actions.SetPlayerId)
local SetPlayerName = require(parent.Actions.SetPlayerName)
local SetLocale = require(parent.Actions.SetLocale)
local SetItemBeingPurchased = require(parent.Actions.SetItemBeingPurchased)
local SetIsSubjectToChinaPolicies = require(parent.Actions.SetIsSubjectToChinaPolicies)
local UpdateStoreId = require(parent.Actions.UpdateStoreId)
local FFlagAXEnableFetchAvatarPreview = require(parent.Flags.FFlagAXEnableFetchAvatarPreview)
local v

if FFlagAXEnableFetchAvatarPreview then
	v = require(parent.Thunks.GetAssetsFromHumanoidDescriptionV2)
else
	v = require(parent.Thunks.GetAssetsFromHumanoidDescription)
end

local UpdateOwnedStatus = require(parent.Thunks.UpdateOwnedStatus)
local ReportPurchaseSuccessUnifiedEvent = require(parent.Thunks.ReportPurchaseSuccessUnifiedEvent)
local FFlagAXIaBSinglePurchaseUnifiedEvents = require(parent.Flags.FFlagAXIaBSinglePurchaseUnifiedEvents)
local GetCharacterModelFromUserId = require(parent.Thunks.GetCharacterModelFromUserId)
local GetPlayerName = require(parent.Thunks.GetPlayerName)
local InspectAndBuyContext = require(parent.Components.InspectAndBuyContext)
local CloseOverlay = require(parent.Actions.CloseOverlay)
local AvatarExperienceInspectAndBuy = require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)
local getViewType = AvatarExperienceInspectAndBuy.Utils.getViewType
local InspectAndBuyVersion = AvatarExperienceInspectAndBuy.Enums.InspectAndBuyVersion
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableInspectAndBuyV2RootFlag = SharedFlags2.FFlagEnableInspectAndBuyV2RootFlag

local FFlagAXEnableInspectAndBuyVersionAnalytics = require(parent.Flags.FFlagAXEnableInspectAndBuyVersionAnalytics)
local FFlagAXEnableInspectAndBuyFocusNavigation = AvatarExperienceFlags.FFlagAXEnableInspectAndBuyFocusNavigation
local FFlagAXInspectAndBuyAvatarBackground = AvatarExperienceFlags.FFlagAXInspectAndBuyAvatarBackground

local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)

local FFlagAXEnableNewInspectAndBuyContainer = require(parent.Flags.FFlagAXEnableNewInspectAndBuyContainer)

local named = Symbol.named("OverrideCursorInspectMenu")

local extended = Roact.PureComponent:extend("InspectAndBuy")

function extended:pushMouseIconOverride()
	if UserInputService:GetLastInputType().Name:find("Gamepad") then
		MouseIconOverrideService.push(named, Enum.OverrideMouseIconBehavior.ForceHide)
	else
		MouseIconOverrideService.push(named, Enum.OverrideMouseIconBehavior.ForceShow)
	end
end

function extended:popMouseIconOverride()
	MouseIconOverrideService.pop(named)
end

function extended:configureInputType(p)
	if (p or UserInputService:GetLastInputType()).Name:find("Gamepad") then
		self.state.store:dispatch(SetGamepadEnabled(true))
	else
		self.state.store:dispatch(SetGamepadEnabled(false))
	end
end

function extended:updateView()
	local viewportSize = workspace.CurrentCamera.ViewportSize

	if FFlagAXEnableNewInspectAndBuyContainer then
		self.state.store:dispatch(SetView(getViewType(viewportSize)))
		return
	end

	local v2 = Constants.View.Wide

	if viewportSize.X < 600 then
		v2 = Constants.View.Compact
	elseif viewportSize.X > viewportSize.Y and viewportSize.X < 800 then
		v2 = Constants.View.WideLandscape
	end

	self.state.store:dispatch(SetView(v2))
end

function extended:init()
	local playerId = self.props.playerId
	local playerName = self.props.playerName
	local ctx = self.props.ctx
	self.connections = {}
	self.network = self.props.network or Network.new()
	local analytics

	if FFlagAXEnableInspectAndBuyVersionAnalytics then
		local new = Analytics.new
		local v2

		if FFlagEnableInspectAndBuyV2RootFlag then
			v2 = InspectAndBuyVersion.Version2
		else
			v2 = InspectAndBuyVersion.Version1
		end

		analytics = new(playerId, ctx, v2)
	else
		analytics = Analytics.new(playerId, ctx)
	end

	self.analytics = analytics

	self.humanoidDescription = self.props.humanoidDescription

	self.analytics.reportOpenInspectMenu()

	self.state = {
		store = Rodux.Store.new(InspectAndBuyReducer, {}, {
			Thunk.middleware({ [Network] = self.network, [Analytics] = self.analytics })
		}),
		views = {
			[Constants.View.Compact] = CompactView,
			[Constants.View.Wide] = WideView,
			[Constants.View.WideLandscape] = WideLandscapeView
		}
	}

	self.state.store:dispatch(UpdateStoreId())

	self.state.store:dispatch(SetPlayerName(playerName))
	self.state.store:dispatch(SetLocale(LocalizationService.RobloxLocaleId))

	if playerId then
		self.state.store:dispatch(SetPlayerId(playerId))
	end

	if self.humanoidDescription then
		self.state.store:dispatch(v(self.humanoidDescription, false))
	end

	function self.onPromptPurchaseFinished(_, p, p2)
		local itemBeingPurchased = self.state.store:getState().itemBeingPurchased

		self.analytics.sendCounter(Constants.Counters.PurchaseFinished)

		if p2 and tostring(p) == itemBeingPurchased.itemId then
			if FFlagAXIaBSinglePurchaseUnifiedEvents then
				self.state.store:dispatch(ReportPurchaseSuccessUnifiedEvent(
					itemBeingPurchased.itemId,
					itemBeingPurchased.itemType,
					itemBeingPurchased.resalePrice
				))
			else
				self.analytics.reportPurchaseSuccess(itemBeingPurchased.itemType, itemBeingPurchased.itemId)
			end

			self.state.store:dispatch(UpdateOwnedStatus(itemBeingPurchased.itemId, itemBeingPurchased.itemType))

			if itemBeingPurchased.itemType == Constants.ItemType.Asset then
				self.analytics.sendCounter(Constants.Counters.PurchaseSucceededAsset)
			elseif itemBeingPurchased.itemType == Constants.ItemType.Bundle then
				self.analytics.sendCounter(Constants.Counters.PurchaseSucceededBundle)
			else
				self.analytics.sendCounter(Constants.Counters.PurchaseSucceededOther)
			end
		end

		self.state.store:dispatch(SetItemBeingPurchased(nil, nil))
	end
end

function extended:didMount()
	local playerId = self.props.playerId
	self.isMounted = true
	self:updateView()
	self:bindButtonB()
	self:configureInputType()
	self:pushMouseIconOverride()

	if defineFastFlag then
		IxpUtils.logLayerExposure(defineFastString)
	end

	if FFlagEnableConsoleExpControls and Enabled() then
		Service:setHideShortcutBar("InspectAndBuy", true)
	end

	local lastInputTypeChangedConnection = UserInputService.LastInputTypeChanged:Connect(function(p)
		self:configureInputType(p)
	end)

	local viewportSizeChangedConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		self:updateView()
	end)

	local robloxLocaleIdChangedConnection = LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(function()
		self.state.store:dispatch(SetLocale(LocalizationService.RobloxLocaleId))
	end)

	local menuOpenedConnection = GuiService.MenuOpened:Connect(function()
		self:popMouseIconOverride()
		GuiService.SelectedCoreObject = nil
	end)

	local menuClosedConnection = GuiService.MenuClosed:Connect(function()
		self:pushMouseIconOverride()
	end)

	coroutine.wrap(function()
		local isSubjectToChinaPolicies = CachedPolicyService:IsSubjectToChinaPolicies()
		self.state.store:dispatch(SetIsSubjectToChinaPolicies(isSubjectToChinaPolicies))
	end)()

	local promptPurchaseFinishedConnection = MarketplaceService.PromptPurchaseFinished:Connect(self.onPromptPurchaseFinished)

	local promptBundlePurchaseFinishedConnection = MarketplaceService.PromptBundlePurchaseFinished:Connect(self.onPromptPurchaseFinished)

	local changedConnection = self.state.store.changed:connect(function(p, p2)
		self:update(p, p2)
	end)

	table.insert(self.connections, viewportSizeChangedConnection)
	table.insert(self.connections, robloxLocaleIdChangedConnection)
	table.insert(self.connections, menuOpenedConnection)
	table.insert(self.connections, menuClosedConnection)
	table.insert(self.connections, lastInputTypeChangedConnection)
	table.insert(self.connections, promptPurchaseFinishedConnection)
	table.insert(self.connections, promptBundlePurchaseFinishedConnection)
	table.insert(self.connections, changedConnection)

	local userId = Players.LocalPlayer.UserId
	self.state.store:dispatch(GetCharacterModelFromUserId(userId, true, function(localPlayerModel)
		if self and self.isMounted then
			self.localPlayerModel = localPlayerModel
			local humanoidDescription = localPlayerModel.Humanoid.HumanoidDescription

			if humanoidDescription then
				self.state.store:dispatch(v(humanoidDescription, true))
			end

			self:setState({ obtainedLocalPlayerModel = true })
		end
	end))

	if playerId then
		self.state.store:dispatch(GetCharacterModelFromUserId(playerId, false, function(playerModel)
			if self and self.isMounted then
				self.playerModel = playerModel
				local humanoidDescription = self.playerModel.Humanoid.HumanoidDescription

				if humanoidDescription then
					local fn = FFlagAXInspectAndBuyAvatarBackground and function()
						return self.isMounted
					end or nil

					self.state.store:dispatch(v(humanoidDescription, false, fn))
				end

				self:setState({ obtainedPlayerModel = true })
			end
		end))

		self.state.store:dispatch(GetPlayerName(playerId))
	end
end

function extended:update(p, p2)
	if p.visible or not p2.visible then
		if p.visible and not p2.visible then
			self:bindButtonB()
		end
	else
		ContextActionService:UnbindCoreAction("BackButtonInspectMenu")
	end
end

function extended:willUnmount()
	self.isMounted = false

	for _, connection in pairs(self.connections) do
		connection:disconnect()
	end

	ContextActionService:UnbindCoreAction("BackButtonInspectMenu")
	self:popMouseIconOverride()

	if FFlagEnableConsoleExpControls and Enabled() then
		Service:setHideShortcutBar("InspectAndBuy", false)
	end
end

function extended.render(props)
	local localPlayerModel = props.localPlayerModel

	if not FFlagAXEnableNewInspectAndBuyContainer then
		return Roact.createElement(InspectAndBuyContext.Provider, { value = props.state.views }, {
			StoreProvider = Roact.createElement(RoactRodux.StoreProvider, {
				store = props.state.store
			}, {
				ThemeProvider = renderWithCoreScriptsStyleProvider({
					CursorProvider = Roact.createElement(SelectionCursorProvider, {}, {
						Container = Roact.createElement(Container, {
							localPlayerModel = localPlayerModel
						})
					})
				})
			})
		})
	end

	local createElement = Roact.createElement
	local createElement2 = Roact.createElement
	local children

	if FFlagAXEnableInspectAndBuyFocusNavigation then
		children = { StoreProvider = 0 }
		local createElement3 = Roact.createElement
		local storeProvider = RoactRodux.StoreProvider
		local v2 = { store = props.state.store }

		local createElement4 = Roact.createElement
		local v3 = {
			localPlayerModel = localPlayerModel,
			analytics = props.analytics,
			playerId = 0
		}
		local playerId

		if FFlagAXInspectAndBuyAvatarBackground then
			playerId = props.props.playerId
		end

		v3.playerId = playerId
		children.StoreProvider = createElement3(storeProvider, v2, {
			Container = createElement4(InspectAndBuyBaseContainer, v3)
		})
	else
		children = { FocusNavigationWrapper = 0 }
		local createElement3 = Roact.createElement
		local v2 = { surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay }

		local createElement4 = Roact.createElement
		local storeProvider = RoactRodux.StoreProvider
		local v3 = { store = props.state.store }

		local createElement5 = Roact.createElement
		local v4 = {
			localPlayerModel = localPlayerModel,
			analytics = props.analytics,
			playerId = 0
		}
		local playerId

		if FFlagAXInspectAndBuyAvatarBackground then
			playerId = props.props.playerId
		end

		v4.playerId = playerId
		children.FocusNavigationWrapper = createElement3(FocusRoot, v2, {
			StoreProvider = createElement4(storeProvider, v3, {
				Container = createElement5(InspectAndBuyBaseContainer, v4)
			})
		})
	end

	return createElement("Folder", { Name = "InspectAndBuyApp" }, {
		CoreScriptsRootProvider = createElement2(CoreScriptsRootProvider, {}, children)
	})
end

function extended:bindButtonB()
	ContextActionService:BindCoreAction("BackButtonInspectMenu", function(_, p, p2)
		if p == Enum.UserInputState.End and p2.KeyCode == Enum.KeyCode.ButtonB then
			local state = self.state.store:getState()
			local viewingDetails = state.detailsInformation.viewingDetails

			if state.overlay and state.overlay.overlay ~= nil then
				self.state.store:dispatch(CloseOverlay())
			elseif viewingDetails then
				self.state.store:dispatch(SetDetailsInformation(false, nil))
				self.state.store:dispatch(SetTryingOnInfo(false, nil))
			else
				GuiService:CloseInspectMenu()
			end
		elseif
			p == Enum.UserInputState.Begin and p2.KeyCode == Enum.KeyCode.Escape
			or p2.KeyCode == Enum.KeyCode.ButtonStart
		then
			GuiService:CloseInspectMenu()
			return Enum.ContextActionResult.Pass
		end

		return Enum.ContextActionResult.Sink
	end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape, Enum.KeyCode.ButtonStart)
end

return extended
