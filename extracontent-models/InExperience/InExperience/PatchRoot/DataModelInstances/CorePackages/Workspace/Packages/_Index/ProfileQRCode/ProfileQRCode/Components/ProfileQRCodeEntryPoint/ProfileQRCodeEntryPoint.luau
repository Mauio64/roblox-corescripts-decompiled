local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent

local AnalyticsService = require(ProfileQRCode.Analytics.AnalyticsService)
local Analytics = require(ProfileQRCode.Analytics)

local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local ProfileQRCodePage = require(ProfileQRCode.Components.ProfileQRCodePage.ProfileQRCodePage)

return function(props)
	local setupFireEvent = Analytics.setupFireEvent
	local analytics

	if props.analyticsService then
		analytics = props.analyticsService
	else
		analytics = AnalyticsService
	end

	local fireEvent = setupFireEvent({
		analytics = analytics,
		infoForAllEvents = { uid = useLocalUserId(), source = props.source }
	})

	return React.createElement(Analytics.Context.Provider, {
		value = { fireEvent = fireEvent }
	}, {
		Window = React.createElement(ProfileQRCodePage, {
			appStorageService = props.appStorageService,
			robloxEventReceiver = props.robloxEventReceiver,
			onClose = props.onClose,
			openQrCodeScanner = props.openQrCodeScanner
		})
	})
end
