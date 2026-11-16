local ChromeShared = script:FindFirstAncestor("ChromeShared")

local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ChromeUtils = require(ChromeShared.Service.ChromeUtils)
local ObservableValue = ChromeUtils.ObservableValue

local screenSize = ObservableValue.new(Vector2.new(0, 0))
local mobileDevice = ObservableValue.new(false)
local viewportSizeChangedConnection = nil

function createViewportInfo(size: Vector2)
	local portraitOrientation = size.Y > size.X
	local platform = UserInputService:GetPlatform()
	local isMobileDevice = platform == Enum.Platform.IOS or platform == Enum.Platform.Android
	return {
		size = size,
		portraitOrientation = portraitOrientation,
		tinyPortrait = isMobileDevice and portraitOrientation and size.X < 360,
		isMobileDevice = isMobileDevice
	}
end

local viewport = ObservableValue.new(createViewportInfo(Vector2.zero))

function updateViewportSize(vector2: Vector2)
	local vector2_2 = Vector2.new(vector2.X, vector2.Y)
	screenSize:set(vector2_2)
	viewport:set(createViewportInfo(vector2_2))
end

function setCurrentCamera(instance)
	if viewportSizeChangedConnection then
		pcall(function()
			viewportSizeChangedConnection:Disconnect()
		end)
		viewportSizeChangedConnection = nil
	end

	if instance then
		local platform = UserInputService:GetPlatform()
		mobileDevice:set(platform == Enum.Platform.IOS or platform == Enum.Platform.Android)
		viewportSizeChangedConnection = instance:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			updateViewportSize(instance.ViewportSize)
		end)
		updateViewportSize(instance.ViewportSize)
	end
end

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	setCurrentCamera(Workspace.CurrentCamera)
end)
setCurrentCamera(Workspace.CurrentCamera)

return {
	screenSize = screenSize,
	mobileDevice = mobileDevice,
	viewport = viewport,
	isSmallTouchScreen = function()
		local v = screenSize:get()
		return UserInputService.TouchEnabled and (v.Y < 500 or v.X < 700)
	end
}
