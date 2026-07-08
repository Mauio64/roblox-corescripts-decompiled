local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalizationService = game:GetService("LocalizationService")
local StarterGui = game:GetService("StarterGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Signals = require(CorePackages.Packages.Signals)
local InExperienceTopBar = require(CorePackages.Workspace.Packages.InExperienceTopBar)
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Actions = scriptParent.Actions
local Components = scriptParent.Components
local Reducers = scriptParent.Reducers
local Thunks = scriptParent.Thunks
local Utility = scriptParent.Utility
local FFlagEnableNewBackpack = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableNewBackpack
local v24 = if not FFlagEnableNewBackpack then nil else require(CorePackages.Workspace.Packages.System).Features
local v25 = if FFlagEnableNewBackpack then nil else require(scriptParentParent.BackpackScript)
local ChatSelector = require(scriptParentParent.ChatSelector)
local TenFootInterface = require(scriptParentParent.TenFootInterface)
local Constants = require(scriptParentParent.TopBar.Constants)
local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)
local FFlagTopBarSignalizeSetCores = InExperienceTopBar.Flags.FFlagTopBarSignalizeSetCores
local Constants2 = UIBlox.App.Style.Constants
local UiModeStyleProvider = require(CorePackages.Workspace.Packages.Style).UiModeStyleProvider
local CanPlayEmotes = require(Utility.CanPlayEmotes)
local Constants3 = require(scriptParent.Constants)
local EmotesMenu = require(Components.EmotesMenu)
local EmotesMenuReducer = require(Reducers.EmotesMenuReducer)
local OpenMenu = require(Thunks.OpenMenu)
local HideMenu = require(Actions.HideMenu)
local EmotesChanged = require(Actions.EmotesChanged)
local EquippedEmotesChanged = require(Actions.EquippedEmotesChanged)
local NumberEmotesLoadedChanged = require(Actions.NumberEmotesLoadedChanged)
local SetGuiInset = require(Actions.SetGuiInset)
local SetLayout = require(Actions.SetLayout)
local SetLocale = require(Actions.SetLocale)
local v45 = game:DefineFastFlag("EmotesStayOpenWithChat", false)
local t1 = {}

t1.__index = t1

local function isClient() -- line: 68
	-- upvalues: RunService (copy)
	return RunService:IsClient() and (not RunService:IsEdit() and not RunService:IsRunMode())
end

function t1.isOpen(p1) -- line: 72
	return p1.store:getState().displayOptions.menuVisible
end
function t1.isEmotesLoaded(p2) -- line: 76
	return p2.store:getState().emotesPage.numberEmotesLoaded > 0
end
function t1.open(p3) -- line: 80
	-- upvalues: OpenMenu (copy)
	p3.store:dispatch(OpenMenu())
end
function t1.close(p4) -- line: 84
	-- upvalues: HideMenu (copy)
	p4.store:dispatch(HideMenu())
end
function t1.setTopBarEnabled(p5, p6) -- line: 88
	-- upvalues: StarterGui (copy)
	p5.topBarEnabled = p6

	local CoreGuiEnabled = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu)

	if p6 and (CoreGuiEnabled and p5.canPlayEmotes) then
		p5:_mount()

		return
	end

	p5:_unmount()
end
function t1._connectCoreGuiListeners(p7) -- line: 99
	-- upvalues: FFlagEnableNewBackpack (copy), v24 (copy), v25 (copy), v45 (copy), ChatSelector (copy), InExperienceAppChatModal (copy)
	if FFlagEnableNewBackpack then
		v24.onVisibilityChanged(v24.FeatureName.Backpack, function(p8) -- line: 101
			-- upvalues: p7 (copy)
			if not p8 then
				return
			end

			if p7:isOpen() then
				p7:close()
			end
		end)
	else
		v25.StateChanged.Event:Connect(function(p9) -- line: 111
			-- upvalues: p7 (copy)
			if not p9 then
				return
			end

			if p7:isOpen() then
				p7:close()
			end
		end)
	end

	if not v45 then
		ChatSelector.VisibilityStateChanged:connect(function(p10) -- line: 123
			-- upvalues: p7 (copy)
			if not p10 then
				return
			end

			if p7:isOpen() then
				p7:close()
			end
		end)
	end

	if not v45 then
		InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(p11) -- line: 135
			-- upvalues: p7 (copy)
			if p11 and p7:isOpen() then
				p7:close()
			end
		end)
	end
end
function t1._connectApiListeners(p12) -- line: 143
	-- upvalues: StarterGui (copy), GuiService (copy)
	StarterGui.CoreGuiChangedSignal:connect(function(p13, p14) -- line: 144
		-- upvalues: p12 (copy)
		if not p12.topBarEnabled then
			return
		end

		if not p12.canPlayEmotes then
			return
		end

		if p13 == Enum.CoreGuiType.EmotesMenu or p13 == Enum.CoreGuiType.All then
			if p14 then
				p12:_mount()

				return
			end

			p12:_unmount()
		end
	end)
	GuiService.EmotesMenuOpenChanged:Connect(function(p15) -- line: 162
		-- upvalues: p12 (copy)
		if p15 then
			if not p12:isOpen() then
				p12:open()

				return
			end
		elseif p12:isOpen() then
			p12:close()
		end
	end)
end
function t1._onEquippedEmotesChanged(p16, p17) -- line: 175
	-- upvalues: EquippedEmotesChanged (copy)
	p16.store:dispatch(EquippedEmotesChanged(p17))
end
function t1._onEmotesChanged(p18, p19) -- line: 179
	-- upvalues: EmotesChanged (copy)
	p18.store:dispatch(EmotesChanged(p19))
end
function t1._onNumberEmotesLoadedChanged(p20, p21) -- line: 183
	-- upvalues: NumberEmotesLoadedChanged (copy)
	p20.store:dispatch(NumberEmotesLoadedChanged(p21))
	p20.EmotesLoaded:Fire(p21 > 0)
end
function t1._onHumanoidDescriptionChanged(p22, p23) -- line: 188
	if p22.equippedEmotesChangedConn then
		p22.equippedEmotesChangedConn:Disconnect()
		p22.equippedEmotesChangedConn = nil
	end

	if p22.emotesChangedConn then
		p22.emotesChangedConn:Disconnect()
		p22.emotesChangedConn = nil
	end

	if p22.numberEmotesLoadedChangedConn then
		p22.numberEmotesLoadedChangedConn:Disconnect()
		p22.numberEmotesLoadedChangedConn = nil
	end

	if p22.humanoidDescriptionAncestryConn then
		p22.humanoidDescriptionAncestryConn:Disconnect()
		p22.humanoidDescriptionAncestryConn = nil
	end

	if p23 then
		p22.equippedEmotesChangedConn = p23.EquippedEmotesChanged:Connect(function(p24) -- line: 210
			-- upvalues: p22 (copy)
			p22:_onEquippedEmotesChanged(p24)
		end)
		p22:_onEquippedEmotesChanged(p23:GetEquippedEmotes())
		p22.emotesChangedConn = p23.EmotesChanged:Connect(function(p25) -- line: 215
			-- upvalues: p22 (copy)
			p22:_onEmotesChanged(p25)
		end)
		p22:_onEmotesChanged(p23:GetEmotes())
		p22.numberEmotesLoadedChangedConn = p23:GetPropertyChangedSignal("NumberEmotesLoaded"):Connect(function(p26) -- line: 222
			-- upvalues: p22 (copy)
			p22:_onNumberEmotesLoadedChanged(p26)
		end)
		p22:_onNumberEmotesLoadedChanged(p23.NumberEmotesLoaded)
		p22.humanoidDescriptionAncestryConn = p23.AncestryChanged:Connect(function(child, parent) -- line: 227
			-- upvalues: p23 (copy), p22 (copy)
			if child == p23 and parent == nil then
				p22:_onHumanoidDescriptionChanged(nil)
			end
		end)

		return
	end

	p22:_onEquippedEmotesChanged({})
	p22:_onEmotesChanged({})
	p22:_onNumberEmotesLoadedChanged(-1)
end
function t1._onHumanoidChanged(p27, p28) -- line: 239
	if p27.humanoidChildAddedConn then
		p27.humanoidChildAddedConn:Disconnect()
		p27.humanoidChildAddedConn = nil
	end

	if p27.humanoidAncestryChangedConn then
		p27.humanoidAncestryChangedConn:Disconnect()
		p27.humanoidAncestryChangedConn = nil
	end

	if p28 then
		p27.humanoidChildAddedConn = p28.ChildAdded:Connect(function(child) -- line: 251
			-- upvalues: p27 (copy)
			if child:IsA("HumanoidDescription") then
				p27:_onHumanoidDescriptionChanged(child)
			end
		end)

		local HumanoidDescription = p28:FindFirstChildOfClass("HumanoidDescription")

		if HumanoidDescription then
			p27:_onHumanoidDescriptionChanged(HumanoidDescription)
		end

		p27.humanoidAncestryChangedConn = p28.AncestryChanged:Connect(function(child, parent) -- line: 262
			-- upvalues: p28 (copy), p27 (copy)
			if child == p28 and parent == nil then
				p27:_onHumanoidChanged(nil)
			end
		end)

		return
	end

	p27:_onHumanoidDescriptionChanged(nil)
end
function t1._onCharacterAdded(p29, p30) -- line: 272
	if p29.characterChildAddedConn then
		p29.characterChildAddedConn:Disconnect()
		p29.characterChildAddedConn = nil
	end

	p29.characterChildAddedConn = p30.ChildAdded:Connect(function(child) -- line: 278
		-- upvalues: p29 (copy)
		if child:IsA("Humanoid") then
			p29:_onHumanoidChanged(child)
		end
	end)

	local Humanoid = p30:FindFirstChildWhichIsA("Humanoid")

	if Humanoid then
		p29:_onHumanoidChanged(Humanoid)
	end
end
function t1._connectListeners(p31) -- line: 290
	-- upvalues: LocalPlayer (ref), LocalizationService (copy), SetLocale (copy), CanPlayEmotes (copy), StarterGui (copy), FFlagTopBarSignalizeSetCores (copy), Signals (copy), InExperienceTopBar (copy)
	p31:_connectCoreGuiListeners()
	p31:_connectApiListeners()
	LocalPlayer.CharacterAdded:Connect(function(character) -- line: 294
		-- upvalues: p31 (copy)
		p31:_onCharacterAdded(character)
	end)

	if LocalPlayer.Character then
		p31:_onCharacterAdded(LocalPlayer.Character)
	end

	LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(function() -- line: 302
		-- upvalues: p31 (copy), SetLocale (copy), LocalizationService (copy)
		p31.store:dispatch(SetLocale(LocalizationService.RobloxLocaleId))
	end)
	CanPlayEmotes.ChangedEvent.Event:connect(function(p32) -- line: 306
		-- upvalues: p31 (copy), StarterGui (copy)
		p31.canPlayEmotes = p32

		local CoreGuiEnabled = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu)

		if p32 and (p31.topBarEnabled and CoreGuiEnabled) then
			p31:_mount()

			return
		end

		p31:_unmount()
	end)

	if FFlagTopBarSignalizeSetCores then
		p31.disposeEffect = Signals.createEffect(function(p33) -- line: 318
			-- upvalues: InExperienceTopBar (copy), p31 (copy)
			local GetTopBarStore = InExperienceTopBar.Stores.GetTopBarStore

			if GetTopBarStore then
				p31:setTopBarEnabled(GetTopBarStore(p33).getTopBarCoreGuiEnabled(p33))
			end
		end)
	end
end
function t1._onStateChanged(p34, p35, p36) -- line: 327
	-- upvalues: GuiService (copy)
	if p36.displayOptions.menuVisible ~= p35.displayOptions.menuVisible then
		p34.EmotesMenuToggled:Fire(p35.displayOptions.menuVisible)
		GuiService:SetEmotesMenuOpen(p35.displayOptions.menuVisible)
	end
end
function t1._mount(p37) -- line: 335
	-- upvalues: Constants2 (copy), Roact (copy), RoactRodux (copy), UiModeStyleProvider (copy), EmotesMenu (copy), RobloxGui (copy)
	local t2 = {
		themeName = Constants2.ThemeName.Dark,
		fontName = Constants2.FontName.Gotham
	}

	if not p37.instance then
		local v77 = Roact.createElement(RoactRodux.StoreProvider, {
			store = p37.store
		}, {
			StyleProvider = Roact.createElement(UiModeStyleProvider, {
				style = t2
			}, {
				EmotesMenu = Roact.createElement(EmotesMenu)
			})
		})
		local v78 = Roact.createElement("Folder", {
			Name = "EmotesMenu"
		}, v77)

		p37.instance = Roact.mount(v78, RobloxGui, "EmotesMenu")
		p37.MenuIsVisible = true
		p37.MenuVisibilityChanged:Fire(true)
	end
end
function t1._unmount(p38) -- line: 363
	-- upvalues: Roact (copy)
	if p38.instance then
		Roact.unmount(p38.instance)
		p38.instance = nil
		p38.MenuIsVisible = false
		p38.MenuVisibilityChanged:Fire(false)
	end
end
function t1.new() -- line: 373
	-- upvalues: t1 (copy), CanPlayEmotes (copy), Rodux (copy), EmotesMenuReducer (copy), RunService (copy), SetLocale (copy), LocalizationService (copy), TenFootInterface (copy), SetLayout (copy), Constants3 (copy), Constants (copy), RobloxGui (copy), SetGuiInset (copy)
	local self = setmetatable({}, t1)

	self.canPlayEmotes = CanPlayEmotes.Value
	self.topBarEnabled = true
	self.EmotesMenuToggled = Instance.new("BindableEvent")
	self.MenuIsVisible = false
	self.MenuVisibilityChanged = Instance.new("BindableEvent")
	self.EmotesLoaded = Instance.new("BindableEvent")
	self.store = Rodux.Store.new(EmotesMenuReducer, {}, { Rodux.thunkMiddleware })

	if not RunService:IsClient() or (RunService:IsEdit() or RunService:IsRunMode()) then
		return self
	end

	self.store.changed:connect(function(p39, p40) -- line: 403
		-- upvalues: self (copy)
		self:_onStateChanged(p39, p40)
	end)
	self.store:dispatch(SetLocale(LocalizationService.RobloxLocaleId))

	if TenFootInterface:IsEnabled() then
		self.store:dispatch(SetLayout(Constants3.Layout.TenFoot))
	end

	local v81 = Constants.ApplyDisplayScale(Constants.TopBarHeight)

	if not RobloxGui.IgnoreGuiInset then
		self.store:dispatch(SetGuiInset(v81))
	end

	self:_mount()
	self:_connectListeners()

	return self
end

return t1.new()
