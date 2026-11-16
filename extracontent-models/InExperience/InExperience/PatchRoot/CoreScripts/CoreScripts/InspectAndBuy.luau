local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui.RobloxGui
local Modules = RobloxGui.Modules
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local inspectAndBuy = Modules.InspectAndBuy
local Roact = require(CorePackages.Packages.Roact)
local InspectAndBuy = require(inspectAndBuy.Components.InspectAndBuy)
local v = nil

local renderWithCoreScriptsStyleProvider = require(RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)

local FFlagAXEnableNewInspectAndBuyContainer = require(inspectAndBuy.Flags.FFlagAXEnableNewInspectAndBuyContainer)

local TopBar = require(RobloxGui.Modules.TopBar)

local FFlagTopBarSignalizeMenuOpen = CoreGuiCommon.Flags.FFlagTopBarSignalizeMenuOpen
local defineFastFlag = game:DefineFastFlag("InspectAndBuyFixStyleLink", false)

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local isSpatial, uiManager, panelType

if isInExperienceUIVREnabled then
	local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
	isSpatial = AppCommonLib.isSpatial

	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)
	uiManager = VrSpatialUi.UIManager
	panelType = VrSpatialUi.Constants.PanelType
else
	isSpatial = nil
	uiManager = nil
	panelType = nil
end

local function mount(humanoidDescription, playerName, playerId, ctx)
	if v then
		Roact.unmount(v)
		v = nil
	end

	local v2 = renderWithCoreScriptsStyleProvider({
		inspectAndBuy = Roact.createElement(InspectAndBuy, {
			humanoidDescription = humanoidDescription,
			playerName = playerName,
			playerId = playerId,
			ctx = ctx
		})
	})

	if FFlagAXEnableNewInspectAndBuyContainer then
		v2 = Roact.createElement(InspectAndBuy, {
			humanoidDescription = humanoidDescription,
			playerName = playerName,
			playerId = playerId,
			ctx = ctx
		})
	end

	if defineFastFlag then
		v2 = Roact.createElement("Folder", nil, v2)
	end

	if isInExperienceUIVREnabled and isSpatial() then
		local panelObject = uiManager.getInstance():getPanelObject(panelType.MoreMenu)
		v = Roact.mount(v2, panelObject, "InspectAndBuy")
	else
		v = Roact.mount(v2, RobloxGui, "InspectAndBuy")
	end

	GuiService:SetMenuIsOpen(true, "InspectMenu")

	if FFlagTopBarSignalizeMenuOpen then
		CoreGuiCommon.Stores.GetInspectAndBuyStore(false).setInspectAndBuyOpen(true)
	else
		TopBar:setInspectMenuOpen(true)
	end
end

local function unmountInspectAndBuy()
	if v then
		Roact.unmount(v)
		v = nil
		GuiService:SetMenuIsOpen(false, "InspectMenu")

		if FFlagTopBarSignalizeMenuOpen then
			CoreGuiCommon.Stores.GetInspectAndBuyStore(false).setInspectAndBuyOpen(false)
		else
			TopBar:setInspectMenuOpen(false)
		end
	end
end

local function mountInspectAndBuyFromHumanoidDescription(humanoidDescription, playerName, ctx) -- 1 equivalent call inferred from this helper
	mount(humanoidDescription, playerName, nil, ctx)
end

local function mountInspectAndBuyFromUserId(playerId, ctx) -- 1 equivalent call inferred from this helper
	mount(nil, nil, playerId, ctx)
end

GuiService.InspectPlayerFromHumanoidDescriptionRequest:Connect(function(humanoidDescription, playerName)
	mountInspectAndBuyFromHumanoidDescription(humanoidDescription, playerName, "developerThroughHumanoidDescription") -- inferred equivalent call
end)

GuiService.InspectPlayerFromUserIdWithCtxRequest:Connect(function(playerId, ctx)
	mountInspectAndBuyFromUserId(playerId, ctx) -- inferred equivalent call
end)

GuiService.CloseInspectMenuRequest:Connect(function()
	if v then
		unmountInspectAndBuy()
	end
end)

GuiService.InspectMenuEnabledChangedSignal:Connect(function(p)
	if not p and v then
		unmountInspectAndBuy()
	end
end)
