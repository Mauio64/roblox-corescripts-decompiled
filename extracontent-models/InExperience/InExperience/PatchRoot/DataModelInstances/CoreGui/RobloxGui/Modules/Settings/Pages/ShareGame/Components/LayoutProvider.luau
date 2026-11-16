local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local UserInputService = game:GetService("UserInputService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local ShareGame = Modules.Settings.Pages.ShareGame
local Constants = require(ShareGame.Constants)

local DeviceOrientationRodux = require(CorePackages.Workspace.Packages.DeviceOrientationRodux)
local SetDeviceOrientation = DeviceOrientationRodux.Actions.SetDeviceOrientation
local SetIsSmallTouchScreen = require(ShareGame.Actions.SetIsSmallTouchScreen)
local SetDeviceLayout = require(ShareGame.Actions.SetDeviceLayout)

local extended = Roact.Component:extend("LayoutProvider")

function extended:didMount()
	if workspace.CurrentCamera then
		self:setObservedCamera(workspace.CurrentCamera)
	end

	self.cameraChangedListener = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		if workspace.CurrentCamera then
			self:setObservedCamera(workspace.CurrentCamera)
		end
	end)
end

function extended.willUnmount(p)
	if p.cameraChangedListener then
		p.cameraChangedListener:Disconnect()
	end

	if p.viewportSizeListener then
		p.viewportSizeListener:Disconnect()
	end
end

function extended:setObservedCamera(instance)
	if self.viewportSizeListener then
		self.viewportSizeListener:Disconnect()
	end

	self:checkAllDeviceInfo(instance.ViewportSize)
	self.viewportSizeListener = instance:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		local viewportSize = instance.ViewportSize

		if viewportSize.X <= 1 or viewportSize.Y <= 1 then
			return
		end

		self:checkAllDeviceInfo(viewportSize)
	end)
end

function extended:checkDeviceOrientation(p)
	local landscape = p.X > p.Y and Constants.DeviceOrientation.LANDSCAPE or Constants.DeviceOrientation.PORTRAIT

	if self._deviceOrientation ~= landscape then
		self._deviceOrientation = landscape
		self.props.setDeviceOrientation(landscape)
	end
end

function extended:checkDeviceIsSmallTouchScreen(p)
	local isSmallTouchScreen = UserInputService.TouchEnabled and (p.X < 700 or p.Y < 500)

	if self._isSmallTouchScreen ~= isSmallTouchScreen then
		self._isSmallTouchScreen = isSmallTouchScreen
		self.props.setIsSmallTouchScreen(self._isSmallTouchScreen)
	end
end

function extended:checkDeviceLayout()
	local deviceLayout

	if self._isSmallTouchScreen then
		if self._deviceOrientation == Constants.DeviceOrientation.LANDSCAPE then
			deviceLayout = Constants.DeviceLayout.PHONE_LANDSCAPE
		else
			deviceLayout = Constants.DeviceLayout.PHONE_PORTRAIT
		end
	elseif UserInputService.TouchEnabled then
		if self._deviceOrientation == Constants.DeviceOrientation.LANDSCAPE then
			deviceLayout = Constants.DeviceLayout.TABLET_LANDSCAPE
		else
			deviceLayout = Constants.DeviceLayout.TABLET_PORTRAIT
		end
	else
		deviceLayout = Constants.DeviceLayout.DESKTOP
	end

	if self._deviceLayout ~= deviceLayout then
		self._deviceLayout = deviceLayout
		self.props.setDeviceLayout(self._deviceLayout)
	end
end

function extended:checkAllDeviceInfo(p)
	self:checkDeviceOrientation(p)
	self:checkDeviceIsSmallTouchScreen(p)
	self:checkDeviceLayout()
end

function extended.render(p)
	return Roact.oneChild(p.props[Roact.Children])
end

return RoactRodux.UNSTABLE_connect2(nil, function(callback)
	return {
		setDeviceOrientation = function(p)
			return callback(SetDeviceOrientation(p))
		end,
		setIsSmallTouchScreen = function(p)
			return callback(SetIsSmallTouchScreen(p))
		end,
		setDeviceLayout = function(p)
			return callback(SetDeviceLayout(p))
		end
	}
end)(extended)
