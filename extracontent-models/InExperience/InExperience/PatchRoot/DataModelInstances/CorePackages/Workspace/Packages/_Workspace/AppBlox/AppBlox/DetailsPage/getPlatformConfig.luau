local Parent = script:FindFirstAncestor("AppBlox").Parent
local DeviceType = require(Parent.RobloxAppEnums).DeviceType
local t1 = {
	[DeviceType.Desktop] = {
		startingOffsetPosition = 500,
		thumbnailHeight = 200,
		dualPanelBreakpoint = 1280,
		headerBarBackgroundHeight = 80,
		sideMargin = 48
	},
	[DeviceType.Tablet] = {
		startingOffsetPosition = 200,
		thumbnailHeight = 150,
		dualPanelBreakpoint = 1e999,
		headerBarBackgroundHeight = 80,
		sideMargin = 48
	},
	[DeviceType.Phone] = {
		startingOffsetPosition = 250,
		thumbnailHeight = 100,
		dualPanelBreakpoint = 1e999,
		headerBarBackgroundHeight = 24,
		sideMargin = 24
	},
	[DeviceType.Console] = {
		startingOffsetPosition = 500,
		thumbnailHeight = 200,
		dualPanelBreakpoint = 1280,
		headerBarBackgroundHeight = 80,
		sideMargin = 48
	},
	[DeviceType.VR] = {
		startingOffsetPosition = 500,
		thumbnailHeight = 200,
		dualPanelBreakpoint = 1280,
		headerBarBackgroundHeight = 80,
		sideMargin = 48
	}
}

local function getPlatformConfig(p1) -- line: 60
	-- upvalues: t1 (copy), DeviceType (copy)
	local v6 = t1[p1]

	if v6 == nil then
		return t1[DeviceType.Desktop]
	end

	return v6
end

return getPlatformConfig
