local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local AnalyticsService = require(ProfileQRCode.Analytics.AnalyticsService)
local Analytics = require(ProfileQRCode.Analytics)
local React = require(ProfileQRCodeParent.React)
local useLocalUserId = require(ProfileQRCodeParent.RobloxAppHooks).useLocalUserId
local ProfileQRCodePage = require(ProfileQRCode.Components.ProfileQRCodePage.ProfileQRCodePage)

return function(t1: {[any]: any}) -- line: 22
	-- upvalues: Analytics (copy), AnalyticsService (copy), useLocalUserId (copy), React (copy), ProfileQRCodePage (copy)
	local v9 = Analytics.setupFireEvent({
		analytics = if not t1.analyticsService then AnalyticsService else t1.analyticsService,
		infoForAllEvents = {
			uid = useLocalUserId(),
			source = t1.source
		}
	})

	return React.createElement(Analytics.Context.Provider, {
		value = {
			fireEvent = v9
		}
	}, {
		Window = React.createElement(ProfileQRCodePage, {
			appStorageService = t1.appStorageService,
			robloxEventReceiver = t1.robloxEventReceiver,
			onClose = t1.onClose,
			openQrCodeScanner = t1.openQrCodeScanner
		})
	})
end
