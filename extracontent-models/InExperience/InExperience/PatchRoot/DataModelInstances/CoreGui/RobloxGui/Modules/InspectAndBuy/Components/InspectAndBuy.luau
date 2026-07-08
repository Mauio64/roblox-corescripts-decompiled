local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local MouseIconOverrideService = require(CorePackages.Workspace.Packages.CoreScriptsCommon).MouseIconOverrideService
local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Symbol = require(CorePackages.Workspace.Packages.AppCommonLib).Symbol
local renderWithCoreScriptsStyleProvider = require(CoreGui.RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)
local SelectionCursorProvider = require(CorePackages.Packages.UIBlox).App.SelectionImage.SelectionCursorProvider
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local v17 = game:DefineFastString("AXInspectAndBuyLayerName", "Experience.Menu")
local v18 = game:DefineFastFlag("AXEnableInspectAndBuyExposureLogging", false)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusRoot = FocusNavigationUtils.FocusRoot
local CoreScriptsRootProvider = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon).CoreScriptsRootProvider
local Chrome = RobloxGui.Modules.Chrome
local Enabled = require(CorePackages.Workspace.Packages.Chrome).Enabled
local v26 = if not Enabled() then nil else require(Chrome.Service)
local FFlagEnableConsoleExpControls = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableConsoleExpControls
local ParentParent = script.Parent.Parent
local SetDetailsInformation = require(ParentParent.Actions.SetDetailsInformation)
local SetTryingOnInfo = require(ParentParent.Actions.SetTryingOnInfo)
local Thunk = require(ParentParent.Thunk)
local Network = require(ParentParent.Services.Network)
local Analytics = require(ParentParent.Services.Analytics)
local InspectAndBuyReducer = require(ParentParent.Reducers.InspectAndBuyReducer)
local Container = require(ParentParent.Components.Container)
local InspectAndBuyBaseContainer = require(ParentParent.Components.InspectAndBuyBaseContainer)
local Constants = require(ParentParent.Constants)
local CompactView = require(ParentParent.CompactView)
local WideView = require(ParentParent.WideView)
local WideLandscapeView = require(ParentParent.WideLandscapeView)
local SetGamepadEnabled = require(ParentParent.Actions.SetGamepadEnabled)
local SetView = require(ParentParent.Actions.SetView)
local SetPlayerId = require(ParentParent.Actions.SetPlayerId)
local SetPlayerName = require(ParentParent.Actions.SetPlayerName)
local SetLocale = require(ParentParent.Actions.SetLocale)
local SetItemBeingPurchased = require(ParentParent.Actions.SetItemBeingPurchased)
local SetIsSubjectToChinaPolicies = require(ParentParent.Actions.SetIsSubjectToChinaPolicies)
local UpdateStoreId = require(ParentParent.Actions.UpdateStoreId)
local v49 = if not require(ParentParent.Flags.FFlagAXEnableFetchAvatarPreview) then require(ParentParent.Thunks.GetAssetsFromHumanoidDescription) else require(ParentParent.Thunks.GetAssetsFromHumanoidDescriptionV2)
local UpdateOwnedStatus = require(ParentParent.Thunks.UpdateOwnedStatus)
local GetCharacterModelFromUserId = require(ParentParent.Thunks.GetCharacterModelFromUserId)
local GetPlayerName = require(ParentParent.Thunks.GetPlayerName)
local InspectAndBuyContext = require(ParentParent.Components.InspectAndBuyContext)
local CloseOverlay = require(ParentParent.Actions.CloseOverlay)
local AvatarExperienceInspectAndBuy = require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)
local getViewType = AvatarExperienceInspectAndBuy.Utils.getViewType
local InspectAndBuyVersion = AvatarExperienceInspectAndBuy.Enums.InspectAndBuyVersion
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagEnableInspectAndBuyV2RootFlag = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableInspectAndBuyV2RootFlag
local FFlagAXEnableInspectAndBuyVersionAnalytics = require(ParentParent.Flags.FFlagAXEnableInspectAndBuyVersionAnalytics)
local FFlagAXEnableInspectAndBuyFocusNavigation = AvatarExperienceFlags.FFlagAXEnableInspectAndBuyFocusNavigation
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)
local FFlagAXEnableNewInspectAndBuyContainer = require(ParentParent.Flags.FFlagAXEnableNewInspectAndBuyContainer)
local v64 = Symbol.named("OverrideCursorInspectMenu")
local v65 = Roact.PureComponent:extend("InspectAndBuy")

function v65.pushMouseIconOverride(_) -- line: 87
	-- upvalues: UserInputService (copy), MouseIconOverrideService (copy), v64 (copy)
	if UserInputService:GetLastInputType().Name:find("Gamepad") then
		MouseIconOverrideService.push(v64, Enum.OverrideMouseIconBehavior.ForceHide)

		return
	end

	MouseIconOverrideService.push(v64, Enum.OverrideMouseIconBehavior.ForceShow)
end
function v65.popMouseIconOverride(_) -- line: 98
	-- upvalues: MouseIconOverrideService (copy), v64 (copy)
	MouseIconOverrideService.pop(v64)
end
function v65.configureInputType(p3, p4) -- line: 102
	-- upvalues: UserInputService (copy), SetGamepadEnabled (copy)
	if (p4 or UserInputService:GetLastInputType()).Name:find("Gamepad") then
		p3.state.store:dispatch(SetGamepadEnabled(true))

		return
	end

	p3.state.store:dispatch(SetGamepadEnabled(false))
end
function v65.updateView(p5) -- line: 113
	-- upvalues: FFlagAXEnableNewInspectAndBuyContainer (copy), SetView (copy), getViewType (copy), Constants (copy)
	local ViewportSize = workspace.CurrentCamera.ViewportSize

	if FFlagAXEnableNewInspectAndBuyContainer then
		p5.state.store:dispatch(SetView(getViewType(ViewportSize)))

		return
	end

	local Wide = Constants.View.Wide

	if ViewportSize.X < 600 then
		Wide = Constants.View.Compact
	elseif ViewportSize.X > ViewportSize.Y and ViewportSize.X < 800 then
		Wide = Constants.View.WideLandscape
	end

	p5.state.store:dispatch(SetView(Wide))
end
function v65.init(p6) -- line: 131
	-- upvalues: Network (copy), FFlagAXEnableInspectAndBuyVersionAnalytics (copy), Analytics (copy), FFlagEnableInspectAndBuyV2RootFlag (copy), InspectAndBuyVersion (copy), Rodux (copy), InspectAndBuyReducer (copy), Thunk (copy), Constants (copy), CompactView (copy), WideView (copy), WideLandscapeView (copy), UpdateStoreId (copy), SetPlayerName (copy), SetLocale (copy), LocalizationService (copy), SetPlayerId (copy), v49 (copy), UpdateOwnedStatus (copy), SetItemBeingPurchased (copy)
	local playerId = p6.props.playerId
	local playerName = p6.props.playerName
	local ctx = p6.props.ctx

	p6.connections = {}
	p6.network = p6.props.network or Network.new()
	p6.analytics = if not FFlagAXEnableInspectAndBuyVersionAnalytics then Analytics.new(playerId, ctx) else Analytics.new(playerId, ctx, if not FFlagEnableInspectAndBuyV2RootFlag then InspectAndBuyVersion.Version1 else InspectAndBuyVersion.Version2)
	p6.humanoidDescription = p6.props.humanoidDescription
	p6.analytics.reportOpenInspectMenu()
	p6.state = {
		store = Rodux.Store.new(InspectAndBuyReducer, {}, { Thunk.middleware({
			[Network] = p6.network,
			[Analytics] = p6.analytics
		}) }),
		views = {
			[Constants.View.Compact] = CompactView,
			[Constants.View.Wide] = WideView,
			[Constants.View.WideLandscape] = WideLandscapeView
		}
	}
	p6.state.store:dispatch(UpdateStoreId())
	p6.state.store:dispatch(SetPlayerName(playerName))
	p6.state.store:dispatch(SetLocale(LocalizationService.RobloxLocaleId))

	if playerId then
		p6.state.store:dispatch(SetPlayerId(playerId))
	end

	if p6.humanoidDescription then
		p6.state.store:dispatch(v49(p6.humanoidDescription, false))
	end

	function p6.onPromptPurchaseFinished(_, p8, p9) -- line: 184
		-- upvalues: p6 (copy), Constants (copy), UpdateOwnedStatus (copy), SetItemBeingPurchased (copy)
		local itemBeingPurchased = p6.state.store:getState().itemBeingPurchased

		p6.analytics.sendCounter(Constants.Counters.PurchaseFinished)

		if p9 and tostring(p8) == itemBeingPurchased.itemId then
			p6.analytics.reportPurchaseSuccess(itemBeingPurchased.itemType, itemBeingPurchased.itemId)
			p6.state.store:dispatch(UpdateOwnedStatus(itemBeingPurchased.itemId, itemBeingPurchased.itemType))

			if itemBeingPurchased.itemType == Constants.ItemType.Asset then
				p6.analytics.sendCounter(Constants.Counters.PurchaseSucceededAsset)
			elseif itemBeingPurchased.itemType == Constants.ItemType.Bundle then
				p6.analytics.sendCounter(Constants.Counters.PurchaseSucceededBundle)
			else
				p6.analytics.sendCounter(Constants.Counters.PurchaseSucceededOther)
			end
		end

		p6.state.store:dispatch(SetItemBeingPurchased(nil, nil))
	end
end
function v65.didMount(p10) -- line: 204
	-- upvalues: v18 (copy), IxpUtils (copy), v17 (copy), FFlagEnableConsoleExpControls (copy), Enabled (copy), v26 (copy), UserInputService (copy), LocalizationService (copy), SetLocale (copy), GuiService (copy), CachedPolicyService (copy), SetIsSubjectToChinaPolicies (copy), MarketplaceService (copy), Players (copy), GetCharacterModelFromUserId (copy), v49 (copy), GetPlayerName (copy)
	local playerId = p10.props.playerId

	p10.isMounted = true
	p10:updateView()
	p10:bindButtonB()
	p10:configureInputType()
	p10:pushMouseIconOverride()

	if v18 then
		IxpUtils.logLayerExposure(v17)
	end

	if FFlagEnableConsoleExpControls and Enabled() then
		v26:setHideShortcutBar("InspectAndBuy", true)
	end

	local connection = UserInputService.LastInputTypeChanged:Connect(function(p11) -- line: 221
		-- upvalues: p10 (copy)
		p10:configureInputType(p11)
	end)
	local connection2 = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 227
		-- upvalues: p10 (copy)
		p10:updateView()
	end)
	local connection3 = LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(function() -- line: 231
		-- upvalues: p10 (copy), SetLocale (copy), LocalizationService (copy)
		p10.state.store:dispatch(SetLocale(LocalizationService.RobloxLocaleId))
	end)
	local connection4 = GuiService.MenuOpened:Connect(function() -- line: 235
		-- upvalues: p10 (copy), GuiService (copy)
		p10:popMouseIconOverride()
		GuiService.SelectedCoreObject = nil
	end)
	local connection5 = GuiService.MenuClosed:Connect(function() -- line: 240
		-- upvalues: p10 (copy)
		p10:pushMouseIconOverride()
	end)

	coroutine.wrap(function() -- line: 244
		-- upvalues: CachedPolicyService (copy), p10 (copy), SetIsSubjectToChinaPolicies (copy)
		local v102 = CachedPolicyService:IsSubjectToChinaPolicies()

		p10.state.store:dispatch(SetIsSubjectToChinaPolicies(v102))
	end)()

	local connection6 = MarketplaceService.PromptPurchaseFinished:Connect(p10.onPromptPurchaseFinished)
	local connection7 = MarketplaceService.PromptBundlePurchaseFinished:Connect(p10.onPromptPurchaseFinished)
	local v86 = p10.state.store.changed:connect(function(p12, p13) -- line: 257
		-- upvalues: p10 (copy)
		p10:update(p12, p13)
	end)

	table.insert(p10.connections, connection2)
	table.insert(p10.connections, connection3)
	table.insert(p10.connections, connection4)
	table.insert(p10.connections, connection5)
	table.insert(p10.connections, connection)
	table.insert(p10.connections, connection6)
	table.insert(p10.connections, connection7)
	table.insert(p10.connections, v86)

	local UserId = Players.LocalPlayer.UserId

	p10.state.store:dispatch(GetCharacterModelFromUserId(UserId, true, function(p14) -- line: 271
		-- upvalues: p10 (copy), v49 (copy)
		if p10 and p10.isMounted then
			p10.localPlayerModel = p14

			local HumanoidDescription = p14.Humanoid.HumanoidDescription

			if HumanoidDescription then
				p10.state.store:dispatch(v49(HumanoidDescription, true))
			end

			p10:setState({
				obtainedLocalPlayerModel = true
			})
		end
	end))

	if playerId then
		p10.state.store:dispatch(GetCharacterModelFromUserId(playerId, false, function(p15) -- line: 287
			-- upvalues: p10 (copy), v49 (copy)
			if p10 and p10.isMounted then
				p10.playerModel = p15

				local HumanoidDescription = p10.playerModel.Humanoid.HumanoidDescription

				if HumanoidDescription then
					p10.state.store:dispatch(v49(HumanoidDescription, false))
				end

				p10:setState({
					obtainedPlayerModel = true
				})
			end
		end))
		p10.state.store:dispatch(GetPlayerName(playerId))
	end
end
function v65.update(p16, p17, p18) -- line: 306
	-- upvalues: ContextActionService (copy)
	if not p17.visible and p18.visible then
		ContextActionService:UnbindCoreAction("BackButtonInspectMenu")

		return
	end

	if p17.visible and not p18.visible then
		p16:bindButtonB()
	end
end
function v65.willUnmount(p19) -- line: 314
	-- upvalues: ContextActionService (copy), FFlagEnableConsoleExpControls (copy), Enabled (copy), v26 (copy)
	p19.isMounted = false

	for _, v in pairs(p19.connections) do
		v:disconnect()
	end

	ContextActionService:UnbindCoreAction("BackButtonInspectMenu")
	p19:popMouseIconOverride()

	if FFlagEnableConsoleExpControls and Enabled() then
		v26:setHideShortcutBar("InspectAndBuy", false)
	end
end
function v65.render(p20) -- line: 328
	-- upvalues: FFlagAXEnableNewInspectAndBuyContainer (copy), Roact (copy), CoreScriptsRootProvider (copy), FFlagAXEnableInspectAndBuyFocusNavigation (copy), RoactRodux (copy), InspectAndBuyBaseContainer (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), InspectAndBuyContext (copy), renderWithCoreScriptsStyleProvider (copy), SelectionCursorProvider (copy), Container (copy)
	local localPlayerModel = p20.localPlayerModel

	if FFlagAXEnableNewInspectAndBuyContainer then
		return Roact.createElement("Folder", {
			Name = "InspectAndBuyApp"
		}, {
			CoreScriptsRootProvider = Roact.createElement(CoreScriptsRootProvider, {}, if not FFlagAXEnableInspectAndBuyFocusNavigation then {
				FocusNavigationWrapper = Roact.createElement(FocusRoot, {
					surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
				}, {
					StoreProvider = Roact.createElement(RoactRodux.StoreProvider, {
						store = p20.state.store
					}, {
						Container = Roact.createElement(InspectAndBuyBaseContainer, {
							localPlayerModel = localPlayerModel,
							analytics = p20.analytics
						})
					})
				})
			} else {
				StoreProvider = Roact.createElement(RoactRodux.StoreProvider, {
					store = p20.state.store
				}, {
					Container = Roact.createElement(InspectAndBuyBaseContainer, {
						localPlayerModel = localPlayerModel,
						analytics = p20.analytics
					})
				})
			})
		})
	end

	return Roact.createElement(InspectAndBuyContext.Provider, {
		value = p20.state.views
	}, {
		StoreProvider = Roact.createElement(RoactRodux.StoreProvider, {
			store = p20.state.store
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
function v65.bindButtonB(p21) -- line: 382
	-- upvalues: ContextActionService (copy), CloseOverlay (copy), SetDetailsInformation (copy), SetTryingOnInfo (copy), GuiService (copy)
	ContextActionService:BindCoreAction("BackButtonInspectMenu", function(_, p23, p24) -- line: 383
		-- upvalues: p21 (copy), CloseOverlay (copy), SetDetailsInformation (copy), SetTryingOnInfo (copy), GuiService (copy)
		if p23 == Enum.UserInputState.End and p24.KeyCode == Enum.KeyCode.ButtonB then
			local v112 = p21.state.store:getState()
			local viewingDetails = v112.detailsInformation.viewingDetails

			if v112.overlay and v112.overlay.overlay ~= nil then
				p21.state.store:dispatch(CloseOverlay())
			elseif viewingDetails then
				p21.state.store:dispatch(SetDetailsInformation(false, nil))
				p21.state.store:dispatch(SetTryingOnInfo(false, nil))
			else
				GuiService:CloseInspectMenu()
			end
		elseif p23 == Enum.UserInputState.Begin and p24.KeyCode == Enum.KeyCode.Escape or p24.KeyCode == Enum.KeyCode.ButtonStart then
			GuiService:CloseInspectMenu()

			return Enum.ContextActionResult.Pass
		end

		return Enum.ContextActionResult.Sink
	end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape, Enum.KeyCode.ButtonStart)
end

return v65
