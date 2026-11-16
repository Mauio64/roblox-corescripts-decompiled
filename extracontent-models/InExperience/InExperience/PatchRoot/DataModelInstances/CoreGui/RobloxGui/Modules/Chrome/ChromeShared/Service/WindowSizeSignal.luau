local ChromeShared = script:FindFirstAncestor("ChromeShared")

local CorePackages = game:GetService("CorePackages")
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Signal = AppCommonLib.Signal

require(CorePackages.Workspace.Packages.Chrome)

local ViewportUtil = require(ChromeShared.Service.ViewportUtil)
local Constants = require(ChromeShared.Unibar.Constants)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagChromeWindowSignalConstraintsToggle = SharedFlags.FFlagChromeWindowSignalConstraintsToggle

local function getConstrainedWindowSize(p: number, p2: number, flag: boolean?)
	local v = ViewportUtil.mobileDevice:get()
	local v2 = ViewportUtil.screenSize:get()
	local v3 = v2.Y > v2.X

	if v and not (FFlagChromeWindowSignalConstraintsToggle and flag) then
		if v3 then
			p2 = math.min(p2, Constants.MAX_HEIGHT_PORTRAIT)
			p = math.min(p, Constants.MAX_WIDTH_PORTRAIT)
		elseif not v3 then
			p2 = math.min(p2, Constants.MAX_HEIGHT_LANDSCAPE)
			p = math.min(p, Constants.MAX_WIDTH_LANDSCAPE)
		end
	end

	return UDim2.new(0, p, 0, p2)
end

local WindowSizeSignal = {}
WindowSizeSignal.__index = WindowSizeSignal

function WindowSizeSignal.new(p: number?, p2: number?, flag: boolean?, flag2: boolean?)
	local state

	if FFlagChromeWindowSignalConstraintsToggle then
		state = getConstrainedWindowSize(p or Constants.DEFAULT_WIDTH, p2 or Constants.DEFAULT_HEIGHT, flag2 or false)
	else
		state = getConstrainedWindowSize(p or Constants.DEFAULT_WIDTH, p2 or Constants.DEFAULT_HEIGHT)
	end

	local v = {
		_state = state,
		_isLarge = flag or false,
		_ignoreConstraints = nil,
		_changeSignal = 0
	}
	local ignoreConstraints

	if FFlagChromeWindowSignalConstraintsToggle then
		ignoreConstraints = flag2 or false
	end

	v._ignoreConstraints = ignoreConstraints
	v._changeSignal = Signal.new()

	return (setmetatable(v, WindowSizeSignal))
end

function WindowSizeSignal:connect(p)
	return self._changeSignal:connect(p)
end

function WindowSizeSignal:requestSize(p: number, p2: number)
	local state

	if FFlagChromeWindowSignalConstraintsToggle then
		state = getConstrainedWindowSize(p, p2, self._ignoreConstraints)
	else
		state = getConstrainedWindowSize(p, p2)
	end

	if self._state ~= state then
		self._state = state
		self._changeSignal:fire(state)
	end
end

function WindowSizeSignal:toggleIsLarge()
	local isLarge = not self._isLarge
	self._isLarge = isLarge
	self._changeSignal:fire(isLarge)
end

function WindowSizeSignal:get()
	return self._state
end

function WindowSizeSignal:getIsLarge()
	return self._isLarge
end

function WindowSizeSignal:updateConstraints()
	self:requestSize(self._state.Width.Offset, self._state.Height.Offset)
end

return WindowSizeSignal
