local parent = script:FindFirstAncestor("AppBlox").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)

local DeviceType = RobloxAppEnums.DeviceType

local v = {
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

local function getPlatformConfig(p)
	local v2 = v[p]

	if v2 == nil then
		return v[DeviceType.Desktop]
	end

	return v2
end

return getPlatformConfig
