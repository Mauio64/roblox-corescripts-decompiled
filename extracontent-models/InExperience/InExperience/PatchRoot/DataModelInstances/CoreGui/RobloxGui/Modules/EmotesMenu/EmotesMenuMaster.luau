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

local Foundation = require(CorePackages.Packages.Foundation)
local ColorMode = Foundation.Enums.ColorMode

local parent = script.Parent
local parent2 = parent.Parent

local actions = parent.Actions
local components = parent.Components
local reducers = parent.Reducers
local thunks = parent.Thunks
local utility = parent.Utility

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableNewBackpack = SharedFlags.FFlagEnableNewBackpack
local features

if FFlagEnableNewBackpack then
	local System = require(CorePackages.Workspace.Packages.System)
	features = System.Features
else
	features = nil
end

local BackpackScript

if FFlagEnableNewBackpack then
	BackpackScript = nil
else
	BackpackScript = require(parent2.BackpackScript)
end

local ChatSelector = require(parent2.ChatSelector)
local TenFootInterface = require(parent2.TenFootInterface)
local Constants = require(parent2.TopBar.Constants)
local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)
local FFlagTopBarSignalizeSetCores = InExperienceTopBar.Flags.FFlagTopBarSignalizeSetCores

local constants = UIBlox.App.Style.Constants
local Style = require(CorePackages.Workspace.Packages.Style)
local UiModeStyleProvider = Style.UiModeStyleProvider

local CanPlayEmotes = require(utility.CanPlayEmotes)
local Constants2 = require(parent.Constants)
local FFlagFixEmotesMenuAvailability = require(parent.Flags.FFlagFixEmotesMenuAvailability)

local EmotesMenu = require(components.EmotesMenu)
local EmotesMenuReducer = require(reducers.EmotesMenuReducer)

local OpenMenu = require(thunks.OpenMenu)
local HideMenu = require(actions.HideMenu)

local EmotesChanged = require(actions.EmotesChanged)
local EquippedEmotesChanged = require(actions.EquippedEmotesChanged)
local NumberEmotesLoadedChanged = require(actions.NumberEmotesLoadedChanged)
local SetGuiInset = require(actions.SetGuiInset)
local SetLayout = require(actions.SetLayout)
local SetLocale = require(actions.SetLocale)

local defineFastFlag = game:DefineFastFlag("EmotesStayOpenWithChat", false)

local class = {}
class.__index = class

local function isClient() -- 1 equivalent call inferred from this helper
	return RunService:IsClient() and not (RunService:IsEdit() or RunService:IsRunMode())
end

function class:isOpen()
	return self.store:getState().displayOptions.menuVisible
end

function class.isEmotesLoaded(p): boolean
	return p.store:getState().emotesPage.numberEmotesLoaded > 0
end

function class:open()
	self.store:dispatch(OpenMenu())
end

function class:close()
	self.store:dispatch(HideMenu())
end

function class:setTopBarEnabled(topBarEnabled)
	self.topBarEnabled = topBarEnabled

	local coreGuiEnabled = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu)

	if topBarEnabled and coreGuiEnabled and self.canPlayEmotes then
		self:_mount()
	else
		self:_unmount()
	end
end

function class:_connectCoreGuiListeners()
	if FFlagEnableNewBackpack then
		features.onVisibilityChanged(features.FeatureName.Backpack, function(p)
			if not p then
				return
			end

			if self:isOpen() then
				self:close()
			end
		end)
	else
		BackpackScript.StateChanged.Event:Connect(function(p)
			if not p then
				return
			end

			if self:isOpen() then
				self:close()
			end
		end)
	end

	if not defineFastFlag then
		ChatSelector.VisibilityStateChanged:connect(function(p)
			if not p then
				return
			end

			if self:isOpen() then
				self:close()
			end
		end)
	end

	if not defineFastFlag then
		InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(p)
			if p and self:isOpen() then
				self:close()
			end
		end)
	end
end

function class:_connectApiListeners()
	StarterGui.CoreGuiChangedSignal:connect(function(p, p2)
		if not (self.topBarEnabled and self.canPlayEmotes) then
			return
		end

		if p == Enum.CoreGuiType.EmotesMenu or p == Enum.CoreGuiType.All then
			if p2 then
				self:_mount()
			else
				self:_unmount()
			end
		end
	end)

	GuiService.EmotesMenuOpenChanged:Connect(function(p)
		if p then
			if not self:isOpen() then
				self:open()
			end
		elseif self:isOpen() then
			self:close()
		end
	end)
end

function class:_onEquippedEmotesChanged(p)
	self.store:dispatch(EquippedEmotesChanged(p))
end

function class:_onEmotesChanged(p)
	self.store:dispatch(EmotesChanged(p))
end

function class:_onNumberEmotesLoadedChanged(p)
	self.store:dispatch(NumberEmotesLoadedChanged(p))
	self.EmotesLoaded:Fire(p > 0)
end

function class:_onHumanoidDescriptionChanged(instance)
	if self.equippedEmotesChangedConn then
		self.equippedEmotesChangedConn:Disconnect()
		self.equippedEmotesChangedConn = nil
	end

	if self.emotesChangedConn then
		self.emotesChangedConn:Disconnect()
		self.emotesChangedConn = nil
	end

	if self.numberEmotesLoadedChangedConn then
		self.numberEmotesLoadedChangedConn:Disconnect()
		self.numberEmotesLoadedChangedConn = nil
	end

	if self.humanoidDescriptionAncestryConn then
		self.humanoidDescriptionAncestryConn:Disconnect()
		self.humanoidDescriptionAncestryConn = nil
	end

	if instance then
		self.equippedEmotesChangedConn = instance.EquippedEmotesChanged:Connect(function(p)
			self:_onEquippedEmotesChanged(p)
		end)
		self:_onEquippedEmotesChanged(instance:GetEquippedEmotes())

		self.emotesChangedConn = instance.EmotesChanged:Connect(function(p)
			self:_onEmotesChanged(p)
		end)

		self:_onEmotesChanged(instance:GetEmotes())

		self.numberEmotesLoadedChangedConn = instance:GetPropertyChangedSignal("NumberEmotesLoaded"):Connect(function(p)
			if FFlagFixEmotesMenuAvailability then
				self:_onNumberEmotesLoadedChanged(instance.NumberEmotesLoaded)
			else
				self:_onNumberEmotesLoadedChanged(p)
			end
		end)
		self:_onNumberEmotesLoadedChanged(instance.NumberEmotesLoaded)

		self.humanoidDescriptionAncestryConn = instance.AncestryChanged:Connect(function(p, parent3)
			if p == instance and parent3 == nil then
				self:_onHumanoidDescriptionChanged(nil)
			end
		end)
	else
		self:_onEquippedEmotesChanged({})
		self:_onEmotesChanged({})
		self:_onNumberEmotesLoadedChanged(-1)
	end
end

function class:_onHumanoidChanged(instance)
	if self.humanoidChildAddedConn then
		self.humanoidChildAddedConn:Disconnect()
		self.humanoidChildAddedConn = nil
	end

	if self.humanoidAncestryChangedConn then
		self.humanoidAncestryChangedConn:Disconnect()
		self.humanoidAncestryChangedConn = nil
	end

	if not instance then
		self:_onHumanoidDescriptionChanged(nil)

		return
	end

	self.humanoidChildAddedConn = instance.ChildAdded:Connect(function(humanoidDescription)
		if humanoidDescription:IsA("HumanoidDescription") then
			self:_onHumanoidDescriptionChanged(humanoidDescription)
		end
	end)

	local humanoidDescription = instance:FindFirstChildOfClass("HumanoidDescription")

	if humanoidDescription then
		self:_onHumanoidDescriptionChanged(humanoidDescription)
	end

	self.humanoidAncestryChangedConn = instance.AncestryChanged:Connect(function(p, parent3)
		if p == instance and parent3 == nil then
			self:_onHumanoidChanged(nil)
		end
	end)
end

function class:_onCharacterAdded(instance)
	if self.characterChildAddedConn then
		self.characterChildAddedConn:Disconnect()
		self.characterChildAddedConn = nil
	end

	self.characterChildAddedConn = instance.ChildAdded:Connect(function(humanoid)
		if humanoid:IsA("Humanoid") then
			self:_onHumanoidChanged(humanoid)
		end
	end)

	local humanoid = instance:FindFirstChildWhichIsA("Humanoid")

	if humanoid then
		self:_onHumanoidChanged(humanoid)
	end
end

function class:_connectListeners()
	self:_connectCoreGuiListeners()
	self:_connectApiListeners()

	LocalPlayer.CharacterAdded:Connect(function(character)
		self:_onCharacterAdded(character)
	end)

	if LocalPlayer.Character then
		self:_onCharacterAdded(LocalPlayer.Character)
	end

	LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(function()
		self.store:dispatch(SetLocale(LocalizationService.RobloxLocaleId))
	end)

	CanPlayEmotes.ChangedEvent.Event:connect(function(canPlayEmotes)
		self.canPlayEmotes = canPlayEmotes
		local coreGuiEnabled = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu)

		if canPlayEmotes and self.topBarEnabled and coreGuiEnabled then
			self:_mount()
		else
			self:_unmount()
		end
	end)

	if FFlagTopBarSignalizeSetCores then
		self.disposeEffect = Signals.createEffect(function(p)
			local getTopBarStore = InExperienceTopBar.Stores.GetTopBarStore

			if getTopBarStore then
				self:setTopBarEnabled(getTopBarStore(p).getTopBarCoreGuiEnabled(p))
			end
		end)
	end
end

function class:_onStateChanged(p, p2)
	if p2.displayOptions.menuVisible ~= p.displayOptions.menuVisible then
		self.EmotesMenuToggled:Fire(p.displayOptions.menuVisible)

		GuiService:SetEmotesMenuOpen(p.displayOptions.menuVisible)
	end
end

function class:_mount()
	local style = { themeName = ColorMode.Dark, fontName = constants.FontName.Gotham }

	if not self.instance then
		local element = Roact.createElement(RoactRodux.StoreProvider, { store = self.store }, {
			StyleProvider = Roact.createElement(UiModeStyleProvider, { style = style }, {
				EmotesMenu = Roact.createElement(EmotesMenu)
			})
		})

		local element2 = Roact.createElement("Folder", { Name = "EmotesMenu" }, element)

		self.instance = Roact.mount(element2, RobloxGui, "EmotesMenu")

		self.MenuIsVisible = true
		self.MenuVisibilityChanged:Fire(true)
	end
end

function class:_unmount()
	if self.instance then
		Roact.unmount(self.instance)
		self.instance = nil

		self.MenuIsVisible = false
		self.MenuVisibilityChanged:Fire(false)
	end
end

function class.new()
	local object = setmetatable({}, class)

	object.canPlayEmotes = CanPlayEmotes.Value
	object.topBarEnabled = true

	object.EmotesMenuToggled = Instance.new("BindableEvent")

	object.MenuIsVisible = false

	object.MenuVisibilityChanged = Instance.new("BindableEvent")

	object.EmotesLoaded = Instance.new("BindableEvent")

	object.store = Rodux.Store.new(EmotesMenuReducer, {}, { Rodux.thunkMiddleware })

	if not isClient() then -- inferred equivalent call
		return object
	end

	object.store.changed:connect(function(p, p2)
		object:_onStateChanged(p, p2)
	end)

	object.store:dispatch(SetLocale(LocalizationService.RobloxLocaleId))

	if TenFootInterface:IsEnabled() then
		object.store:dispatch(SetLayout(Constants2.Layout.TenFoot))
	end

	local v = Constants.ApplyDisplayScale(Constants.TopBarHeight)

	if not RobloxGui.IgnoreGuiInset then
		object.store:dispatch(SetGuiInset(v))
	end

	object:_mount()

	object:_connectListeners()

	return object
end

return class.new()
