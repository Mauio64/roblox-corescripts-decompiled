local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ShareGame = Modules.Settings.Pages.ShareGame
local Constants = require(ShareGame.Constants)
local SetDeviceOrientation = require(CorePackages.Workspace.Packages.DeviceOrientationRodux).Actions.SetDeviceOrientation
local SetIsSmallTouchScreen = require(ShareGame.Actions.SetIsSmallTouchScreen)
local SetDeviceLayout = require(ShareGame.Actions.SetDeviceLayout)
local v11 = Roact.Component:extend("LayoutProvider")

function v11.didMount(p1) -- line: 22
	if workspace.CurrentCamera then
		p1:setObservedCamera(workspace.CurrentCamera)
	end

	p1.cameraChangedListener = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 27
		-- upvalues: p1 (copy)
		if workspace.CurrentCamera then
			p1:setObservedCamera(workspace.CurrentCamera)
		end
	end)
end
function v11.willUnmount(p2) -- line: 34
	if p2.cameraChangedListener then
		p2.cameraChangedListener:Disconnect()
	end

	if p2.viewportSizeListener then
		p2.viewportSizeListener:Disconnect()
	end
end
function v11.setObservedCamera(p3, p4) -- line: 44
	if p3.viewportSizeListener then
		p3.viewportSizeListener:Disconnect()
	end

	p3:checkAllDeviceInfo(p4.ViewportSize)
	p3.viewportSizeListener = p4:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 51
		-- upvalues: p4 (copy), p3 (copy)
		local ViewportSize = p4.ViewportSize

		if ViewportSize.X <= 1 or ViewportSize.Y <= 1 then
			return
		end

		p3:checkAllDeviceInfo(ViewportSize)
	end)
end
function v11.checkDeviceOrientation(p5, p6) -- line: 63
	-- upvalues: Constants (copy)
	local v18 = p6.X > p6.Y and Constants.DeviceOrientation.LANDSCAPE or Constants.DeviceOrientation.PORTRAIT

	if v18 ~= p5._deviceOrientation then
		p5._deviceOrientation = v18
		p5.props.setDeviceOrientation(v18)
	end
end
function v11.checkDeviceIsSmallTouchScreen(p7, p8) -- line: 73
	-- upvalues: UserInputService (copy)
	local v21 = UserInputService.TouchEnabled and (p8.X < 700 or p8.Y < 500)

	if v21 ~= p7._isSmallTouchScreen then
		p7._isSmallTouchScreen = v21
		p7.props.setIsSmallTouchScreen(p7._isSmallTouchScreen)
	end
end
function v11.checkDeviceLayout(p9) -- line: 83
	-- upvalues: Constants (copy), UserInputService (copy)
	local v23 = if not p9._isSmallTouchScreen then if not UserInputService.TouchEnabled then Constants.DeviceLayout.DESKTOP else if p9._deviceOrientation ~= Constants.DeviceOrientation.LANDSCAPE then Constants.DeviceLayout.TABLET_PORTRAIT else Constants.DeviceLayout.TABLET_LANDSCAPE else if p9._deviceOrientation ~= Constants.DeviceOrientation.LANDSCAPE then Constants.DeviceLayout.PHONE_PORTRAIT else Constants.DeviceLayout.PHONE_LANDSCAPE

	if v23 ~= p9._deviceLayout then
		p9._deviceLayout = v23
		p9.props.setDeviceLayout(p9._deviceLayout)
	end
end
function v11.checkAllDeviceInfo(p10, p11) -- line: 108
	p10:checkDeviceOrientation(p11)
	p10:checkDeviceIsSmallTouchScreen(p11)
	p10:checkDeviceLayout()
end
function v11.render(p12) -- line: 114
	-- upvalues: Roact (copy)
	return Roact.oneChild(p12.props[Roact.Children])
end

return RoactRodux.UNSTABLE_connect2(nil, function(p13) -- line: 118
	-- upvalues: SetDeviceOrientation (copy), SetIsSmallTouchScreen (copy), SetDeviceLayout (copy)
	return {
		setDeviceOrientation = function(p14) -- line: 120
			-- upvalues: p13 (copy), SetDeviceOrientation (copy)
			return p13(SetDeviceOrientation(p14))
		end,
		setIsSmallTouchScreen = function(p15) -- line: 123
			-- upvalues: p13 (copy), SetIsSmallTouchScreen (copy)
			return p13(SetIsSmallTouchScreen(p15))
		end,
		setDeviceLayout = function(p16) -- line: 126
			-- upvalues: p13 (copy), SetDeviceLayout (copy)
			return p13(SetDeviceLayout(p16))
		end
	}
end)(v11)
