local ChromeShared = script:FindFirstAncestor("ChromeShared")
local CorePackages = game:GetService("CorePackages")
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal

require(CorePackages.Workspace.Packages.Chrome)

local ViewportUtil = require(ChromeShared.Service.ViewportUtil)
local Constants = require(ChromeShared.Unibar.Constants)
local FFlagChromeWindowSignalConstraintsToggle = require(CorePackages.Workspace.Packages.SharedFlags).FFlagChromeWindowSignalConstraintsToggle

local function getConstrainedWindowSize(n1: number, n2: number, b1: boolean?) -- line: 18
	-- upvalues: ViewportUtil (copy), FFlagChromeWindowSignalConstraintsToggle (copy), Constants (copy)
	local v12 = ViewportUtil.mobileDevice:get()
	local v13 = ViewportUtil.screenSize:get()
	local v14 = v13.Y > v13.X

	if v12 and (not FFlagChromeWindowSignalConstraintsToggle or not b1) then
		if v14 then
			n2 = math.min(n2, Constants.MAX_HEIGHT_PORTRAIT)
			n1 = math.min(n1, Constants.MAX_WIDTH_PORTRAIT)
		elseif not v14 then
			n2 = math.min(n2, Constants.MAX_HEIGHT_LANDSCAPE)
			n1 = math.min(n1, Constants.MAX_WIDTH_LANDSCAPE)
		end
	end

	return UDim2.new(0, n1, 0, n2)
end

local t1 = {}

t1.__index = t1

function t1.new(n3: number?, n4: number?, b2: boolean?, b3: boolean?) -- line: 43
	-- upvalues: FFlagChromeWindowSignalConstraintsToggle (copy), getConstrainedWindowSize (copy), Constants (copy), Signal (copy), t1 (copy)
	return (setmetatable({
		_state = if not FFlagChromeWindowSignalConstraintsToggle then getConstrainedWindowSize(n3 or Constants.DEFAULT_WIDTH, n4 or Constants.DEFAULT_HEIGHT) else getConstrainedWindowSize(n3 or Constants.DEFAULT_WIDTH, n4 or Constants.DEFAULT_HEIGHT, b3 or false),
		_isLarge = b2 or false,
		_ignoreConstraints = if not FFlagChromeWindowSignalConstraintsToggle then nil else b3 or false,
		_changeSignal = Signal.new()
	}, t1))
end
function t1.connect(p1, p2) -- line: 67
	return p1._changeSignal:connect(p2)
end
function t1.requestSize(t2: {[any]: any}, n5: number, n6: number) -- line: 72
	-- upvalues: FFlagChromeWindowSignalConstraintsToggle (copy), getConstrainedWindowSize (copy)
	local v24 = if not FFlagChromeWindowSignalConstraintsToggle then getConstrainedWindowSize(n5, n6) else getConstrainedWindowSize(n5, n6, t2._ignoreConstraints)

	if v24 ~= t2._state then
		t2._state = v24
		t2._changeSignal:fire(v24)
	end
end
function t1.toggleIsLarge(p3) -- line: 83
	local v26 = not p3._isLarge

	p3._isLarge = v26
	p3._changeSignal:fire(v26)
end
function t1.get(p4) -- line: 89
	return p4._state
end
function t1.getIsLarge(p5) -- line: 93
	return p5._isLarge
end
function t1.updateConstraints(p6) -- line: 98
	p6:requestSize(p6._state.Width.Offset, p6._state.Height.Offset)
end

return t1
