local AnalyticsService = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/AnalyticsService")
local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/React")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/RobloxAppHooks").useLocalUserId
local ProfileQRCodePage = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Components/ProfileQRCodePage/ProfileQRCodePage")

return function(props)
	local setupFireEvent = Analytics.setupFireEvent
	local v6 = if props.analyticsService then props.analyticsService else AnalyticsService
	local v7 = setupFireEvent({
		analytics = v6,
		infoForAllEvents = { uid = useLocalUserId(), source = props.source }
	})

	return React.createElement(Analytics.Context.Provider, {
		value = { fireEvent = v7 }
	}, {
		Window = React.createElement(ProfileQRCodePage, {
			appStorageService = props.appStorageService,
			robloxEventReceiver = props.robloxEventReceiver,
			onClose = props.onClose,
			openQrCodeScanner = props.openQrCodeScanner
		})
	})
end
