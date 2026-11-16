local ContextActionService = game:GetService("ContextActionService")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local VRService = game:GetService("VRService")
local CoreGui = game:GetService("CoreGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local parent = script.Parent
local parent2 = parent.Parent
local actions = parent2.Actions
local thunks = parent2.Thunks

local HideMenu = require(actions.HideMenu)
local SetLayout = require(actions.SetLayout)
local ShowError = require(actions.ShowError)
local HideError = require(actions.HideError)

local OpenMenu = require(thunks.OpenMenu)

local EmotesWheel = require(parent.EmotesWheel)
local ErrorMessage = require(parent.ErrorMessage)

local Constants = require(parent2.Constants)

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local LocalPlayer = Players.LocalPlayer
local playerGui = nil

local extended = Roact.PureComponent:extend("EmotesMenu")

function extended:init()
	self.savedSelectedCoreObject = nil
	self.savedSelectedObject = nil
end

function extended.displayVisitShopMessage(p)
	local locale = p.props.locale
	local formatByKeyForLocale = RobloxTranslator:FormatByKeyForLocale(
		Constants.LocalizationKeys.VisitShopToGetEmotes,
		locale
	)
	p.props.showError(formatByKeyForLocale)
	delay(Constants.ErrorDisplayTimeSeconds, function()
		p.props.hideError()
	end)
end

function extended:bindActions()
	local function toggleMenuFunc(_, p, _)
		if
			GuiService.MenuIsOpen
			or (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift))
		then
			return Enum.ContextActionResult.Pass
		end

		if p == Enum.UserInputState.Begin then
			if self.props.displayOptions.menuVisible then
				self.props.hideMenu()
			else
				self.props.openMenu()
			end
		end

		return nil
	end

	ContextActionService:BindAction(Constants.ToggleMenuAction, toggleMenuFunc, false, Constants.EmoteMenuOpenKey)
end

function extended:unbindActions()
	ContextActionService:UnbindAction(Constants.ToggleMenuAction)
end

function extended:saveSelectedObject()
	self.savedSelectedCoreObject = GuiService.SelectedCoreObject
	GuiService.SelectedCoreObject = nil
	self.savedSelectedObject = GuiService.SelectedObject
	GuiService.SelectedObject = nil
end

function extended:resetSelectedObject()
	if
		GuiService.SelectedCoreObject == nil
		and (self.savedSelectedCoreObject == nil or self.savedSelectedCoreObject:IsDescendantOf(CoreGui))
	then
		GuiService.SelectedCoreObject = self.savedSelectedCoreObject
	end

	if GuiService.SelectedObject == nil then
		if playerGui == nil then
			playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		end

		local v

		if playerGui then
			v = self.savedSelectedObject == nil or self.savedSelectedObject:IsDescendantOf(playerGui)
		else
			v = false
		end

		if v then
			GuiService.SelectedObject = self.savedSelectedObject
		end
	end
end

function extended:viewPortSizeChanged()
	if self.props.layout == Constants.Layout.TenFoot then
		return
	end

	local currentCamera = Workspace.CurrentCamera

	if not currentCamera then
		return
	end

	local viewportSize = currentCamera.ViewportSize

	if viewportSize == Vector2.new(1, 1) then
		return
	end

	local v = Constants.Layout.Large

	local v2 = viewportSize.X < Constants.SmallScreenMaxSize.X
	local v3 = viewportSize.Y < Constants.SmallScreenMaxSize.Y

	if v2 or v3 then
		v = Constants.Layout.Small
	end

	self.props.setLayout(v)
end

function extended:currentCameraChanged()
	if self.viewportSizeChangedConn then
		self.viewportSizeChangedConn:Disconnect()
	end

	local currentCamera = Workspace.CurrentCamera

	if currentCamera then
		self.viewportSizeChangedConn = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			self:viewPortSizeChanged()
		end)
		self:viewPortSizeChanged()
	end
end

function extended:didMount()
	self.currentCameraChangedConn = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		self:currentCameraChanged()
	end)
	self:currentCameraChanged()

	self.menuOpenedConn = GuiService.MenuOpened:Connect(function()
		if self.props.displayOptions.menuVisible and not VRService.VREnabled then
			self.props.hideMenu()
		end
	end)

	self.inputOutsideMenuConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed or not self.props.displayOptions.menuVisible then
			return
		end

		local userInputType = input.UserInputType

		if userInputType == Enum.UserInputType.MouseButton1 or userInputType == Enum.UserInputType.Touch then
			self.props.hideMenu()
		end
	end)

	self:bindActions()
end

function extended:willUnmount()
	self.currentCameraChangedConn:Disconnect()
	self.viewportSizeChangedConn:Disconnect()
	self.menuOpenedConn:Disconnect()
	self.inputOutsideMenuConn:Disconnect()

	self.currentCameraChangedConn = nil
	self.viewportSizeChangedConn = nil
	self.menuOpenedConn = nil
	self.inputOutsideMenuConn = nil

	self:unbindActions()
end

function extended:didUpdate(p, _)
	if self.props.displayOptions.menuVisible ~= p.displayOptions.menuVisible then
		if self.props.displayOptions.menuVisible then
			self:saveSelectedObject()
		else
			self:resetSelectedObject()
		end
	end
end

function extended.render(p)
	local layout = Constants.Layouts[p.props.layout]
	local guiInset = p.props.displayOptions.guiInset

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, -guiInset),
		Size = UDim2.new(1, 0, 1, guiInset),
		ZIndex = Constants.EmotesMenuZIndex,
		AutoLocalize = false
	}, {
		Main = Roact.createElement(
			"Frame",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = Constants.ScreenAvailable,
				BackgroundTransparency = 1
			},
			{
				AsspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
					AspectRatio = 1
				}),
				SizeConstraint = Roact.createElement("UISizeConstraint", {
					MinSize = layout.EmotesWheelMinSize,
					MaxSize = layout.EmotesWheelMaxSize
				}),
				EmotesWheel = Roact.createElement(EmotesWheel)
			}
		),
		ErrorMessage = Roact.createElement(ErrorMessage)
	})
end

local function mapStateToProps(data)
	return {
		displayOptions = data.displayOptions,
		emotesInfo = data.emotesPage.emotesInfo,
		layout = data.layout,
		locale = data.locale
	}
end

local function mapDispatchToProps(callback)
	return {
		openMenu = function()
			return callback(OpenMenu())
		end,
		hideMenu = function()
			return callback(HideMenu())
		end,
		setLayout = function(p)
			return callback(SetLayout(p))
		end,
		showError = function(p)
			return callback(ShowError(p))
		end,
		hideError = function()
			return callback(HideError())
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
