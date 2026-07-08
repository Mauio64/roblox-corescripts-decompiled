local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local React = require(ProfileQRCodeParent.React)
local useGetProfileShareUrl = require(ProfileQRCode.Networking.useGetProfileShareUrl)
local useAnalytics = require(ProfileQRCode.Analytics.useAnalytics)
local useShortUrl = require(ProfileQRCode.Rodux.useShortUrl)
local useHasLoadedSuccessfully = require(script.Parent.useHasLoadedSuccessfully)
local useLoadingState = require(ProfileQRCode.Networking.useLoadingState)
local useRefreshQrSession = require(ProfileQRCode.Networking.useRefreshQrSession)
local NetworkStatus = require(ProfileQRCode.Networking.configuredRoduxNetworking).Enum.NetworkStatus
local QRCodeFailedView = require(script.Parent.QRCodeFailedView)
local QRCodeSucceededView = require(script.Parent.QRCodeSucceededView)
local QRCodeLoadingView = require(script.Parent.QRCodeLoadingView)
local useEffectOnce = require(ProfileQRCodeParent.RoactUtils).Hooks.useEffectOnce
local EventNames = require(ProfileQRCode.Analytics.EventNames)
local useHasFailedToLoad = require(script.Parent.useHasFailedToLoad)

return function(t1: {[any]: any}) -- line: 30
	-- upvalues: useAnalytics (copy), useLoadingState (copy), useGetProfileShareUrl (copy), useRefreshQrSession (copy), useShortUrl (copy), NetworkStatus (copy), React (copy), EventNames (copy), useEffectOnce (copy), useHasLoadedSuccessfully (copy), useHasFailedToLoad (copy), QRCodeSucceededView (copy), QRCodeFailedView (copy), QRCodeLoadingView (copy)
	local v18 = useAnalytics()
	local v19 = useLoadingState()
	local v20 = useGetProfileShareUrl()
	local v21 = useRefreshQrSession()
	local v22 = useShortUrl()
	local v23 = v22 ~= nil
	local v24 = v19 == NetworkStatus.Failed

	React.useEffect(function() -- line: 40
		-- upvalues: v21 (copy), v18 (copy), EventNames (copy)
		v21():andThen(function(p1) -- line: 41
			-- upvalues: v18 (copy), EventNames (copy)
			local v28 = p1 and p1.responseBody or {}
			local v29 = p1 and p1.responseCode

			v18.fireEvent(EventNames.RefreshQrSession, {
				success = v28.Success,
				responseCode = v29
			})
		end)
	end, {})
	useEffectOnce(v20, not v23)
	useHasLoadedSuccessfully(v18, v23)
	useHasFailedToLoad(v18, v24)

	local v25 = if not v23 then if not v24 then React.createElement(QRCodeLoadingView) else React.createElement(QRCodeFailedView, {
		padding = 24,
		onActivated = v20
	}) else React.createElement(QRCodeSucceededView, {
		qrCodeLength = 200,
		padding = 24,
		url = v22,
		isSmallScreen = t1.isSmallScreen
	})
	local v26 = not t1.isSmallScreen and 304 or 280

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 304, 0, v26),
		LayoutOrder = t1.layoutOrder
	}, {
		View = v25
	})
end
