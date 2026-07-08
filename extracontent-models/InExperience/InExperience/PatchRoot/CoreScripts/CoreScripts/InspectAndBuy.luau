local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local RobloxGui = game:GetService("CoreGui").RobloxGui
local Modules = RobloxGui.Modules
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local InspectAndBuy = Modules.InspectAndBuy
local Roact = require(CorePackages.Packages.Roact)
local InspectAndBuy2 = require(InspectAndBuy.Components.InspectAndBuy)
local u9 = nil
local renderWithCoreScriptsStyleProvider = require(RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)
local FFlagAXEnableNewInspectAndBuyContainer = require(InspectAndBuy.Flags.FFlagAXEnableNewInspectAndBuyContainer)
local TopBar = require(RobloxGui.Modules.TopBar)
local FFlagTopBarSignalizeMenuOpen = CoreGuiCommon.Flags.FFlagTopBarSignalizeMenuOpen
local v14 = game:DefineFastFlag("InspectAndBuyFixStyleLink", false)
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local isSpatial = nil
local UIManager = nil
local PanelType = nil

if isInExperienceUIVREnabled then
	isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial

	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)

	UIManager = VrSpatialUi.UIManager
	PanelType = VrSpatialUi.Constants.PanelType
end

local function mount(p1, p2, p3, p4) -- line: 38
	-- upvalues: u9 (ref), Roact (copy), renderWithCoreScriptsStyleProvider (copy), InspectAndBuy2 (copy), FFlagAXEnableNewInspectAndBuyContainer (copy), v14 (copy), isInExperienceUIVREnabled (copy), isSpatial (ref), UIManager (ref), PanelType (ref), RobloxGui (copy), GuiService (copy), FFlagTopBarSignalizeMenuOpen (copy), CoreGuiCommon (copy), TopBar (copy)
	if u9 then
		Roact.unmount(u9)
		u9 = nil
	end

	local v28 = renderWithCoreScriptsStyleProvider({
		inspectAndBuy = Roact.createElement(InspectAndBuy2, {
			humanoidDescription = p1,
			playerName = p2,
			playerId = p3,
			ctx = p4
		})
	})

	if FFlagAXEnableNewInspectAndBuyContainer then
		v28 = Roact.createElement(InspectAndBuy2, {
			humanoidDescription = p1,
			playerName = p2,
			playerId = p3,
			ctx = p4
		})
	end

	if v14 then
		v28 = Roact.createElement("Folder", nil, v28)
	end

	if isInExperienceUIVREnabled and isSpatial() then
		local v29 = UIManager.getInstance():getPanelObject(PanelType.MoreMenu)

		u9 = Roact.mount(v28, v29, "InspectAndBuy")
	else
		u9 = Roact.mount(v28, RobloxGui, "InspectAndBuy")
	end

	GuiService:SetMenuIsOpen(true, "InspectMenu")

	if FFlagTopBarSignalizeMenuOpen then
		CoreGuiCommon.Stores.GetInspectAndBuyStore(false).setInspectAndBuyOpen(true)

		return
	end

	TopBar:setInspectMenuOpen(true)
end
local function unmountInspectAndBuy() -- line: 82
	-- upvalues: u9 (ref), Roact (copy), GuiService (copy), FFlagTopBarSignalizeMenuOpen (copy), CoreGuiCommon (copy), TopBar (copy)
	if u9 then
		Roact.unmount(u9)
		u9 = nil
		GuiService:SetMenuIsOpen(false, "InspectMenu")

		if FFlagTopBarSignalizeMenuOpen then
			CoreGuiCommon.Stores.GetInspectAndBuyStore(false).setInspectAndBuyOpen(false)

			return
		end

		TopBar:setInspectMenuOpen(false)
	end
end
local function mountInspectAndBuyFromHumanoidDescription(p5, p6, p7) -- line: 97
	-- upvalues: mount (copy)
	mount(p5, p6, nil, p7)
end
local function mountInspectAndBuyFromUserId(p8, p9) -- line: 101
	-- upvalues: mount (copy)
	mount(nil, nil, p8, p9)
end

GuiService.InspectPlayerFromHumanoidDescriptionRequest:Connect(function(p10, p11) -- line: 105
	-- upvalues: mount (copy)
	mount(p10, p11, nil, "developerThroughHumanoidDescription")
end)
GuiService.InspectPlayerFromUserIdWithCtxRequest:Connect(function(p12, p13) -- line: 109
	-- upvalues: mount (copy)
	mount(nil, nil, p12, p13)
end)
GuiService.CloseInspectMenuRequest:Connect(function() -- line: 113
	-- upvalues: u9 (ref), unmountInspectAndBuy (copy)
	if u9 then
		unmountInspectAndBuy()
	end
end)
GuiService.InspectMenuEnabledChangedSignal:Connect(function(p14) -- line: 119
	-- upvalues: u9 (ref), unmountInspectAndBuy (copy)
	if not p14 and u9 then
		unmountInspectAndBuy()
	end
end)
