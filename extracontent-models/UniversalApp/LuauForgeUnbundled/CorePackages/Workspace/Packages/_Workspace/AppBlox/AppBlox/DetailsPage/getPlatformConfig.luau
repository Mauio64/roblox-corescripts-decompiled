local deviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RobloxAppEnums").DeviceType

local v5 = {
	[deviceType.Desktop] = {
		startingOffsetPosition = 500,
		thumbnailHeight = 200,
		dualPanelBreakpoint = 1280,
		headerBarBackgroundHeight = 80,
		sideMargin = 48
	},
	[deviceType.Tablet] = {
		startingOffsetPosition = 200,
		thumbnailHeight = 150,
		dualPanelBreakpoint = 1e999,
		headerBarBackgroundHeight = 80,
		sideMargin = 48
	},
	[deviceType.Phone] = {
		startingOffsetPosition = 250,
		thumbnailHeight = 100,
		dualPanelBreakpoint = 1e999,
		headerBarBackgroundHeight = 24,
		sideMargin = 24
	},
	[deviceType.Console] = {
		startingOffsetPosition = 500,
		thumbnailHeight = 200,
		dualPanelBreakpoint = 1280,
		headerBarBackgroundHeight = 80,
		sideMargin = 48
	},
	[deviceType.VR] = {
		startingOffsetPosition = 500,
		thumbnailHeight = 200,
		dualPanelBreakpoint = 1280,
		headerBarBackgroundHeight = 80,
		sideMargin = 48
	}
}

local function getPlatformConfig(p2)
	local v6 = v5[p2]

	if v6 == nil then
		return v5[deviceType.Desktop]
	end

	return v6
end

return getPlatformConfig
