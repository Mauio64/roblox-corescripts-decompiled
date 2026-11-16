local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent
local React = require(parent.React)
local useGetProfileShareUrl = require(ProfileQRCode.Networking.useGetProfileShareUrl)
local useAnalytics = require(ProfileQRCode.Analytics.useAnalytics)
local useShortUrl = require(ProfileQRCode.Rodux.useShortUrl)
local useHasLoadedSuccessfully = require(script.Parent.useHasLoadedSuccessfully)
local useLoadingState = require(ProfileQRCode.Networking.useLoadingState)
local useRefreshQrSession = require(ProfileQRCode.Networking.useRefreshQrSession)
local configuredRoduxNetworking = require(ProfileQRCode.Networking.configuredRoduxNetworking)
local networkStatus = configuredRoduxNetworking.Enum.NetworkStatus
local QRCodeFailedView = require(script.Parent.QRCodeFailedView)
local QRCodeSucceededView = require(script.Parent.QRCodeSucceededView)
local QRCodeLoadingView = require(script.Parent.QRCodeLoadingView)
local RoactUtils = require(parent.RoactUtils)
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local EventNames = require(ProfileQRCode.Analytics.EventNames)

local useHasFailedToLoad = require(script.Parent.useHasFailedToLoad)

return function(p)
	local v = useAnalytics()
	local v2 = useLoadingState()
	local onActivated = useGetProfileShareUrl()
	local v3 = useRefreshQrSession()

	local url = useShortUrl()
	local v4 = url ~= nil
	local v5 = v2 == networkStatus.Failed

	React.useEffect(function()
		v3():andThen(function(p2)
			local responseBody = p2 and p2.responseBody or {}
			local responseCode = p2 and p2.responseCode
			v.fireEvent(EventNames.RefreshQrSession, {
				success = responseBody.Success,
				responseCode = responseCode
			})
		end)
	end, {})

	useEffectOnce(onActivated, not v4)
	useHasLoadedSuccessfully(v, v4)
	useHasFailedToLoad(v, v5)
	local view

	if v4 then
		view = React.createElement(QRCodeSucceededView, {
			url = url,
			qrCodeLength = 200,
			padding = 24,
			isSmallScreen = p.isSmallScreen
		})
	elseif v5 then
		view = React.createElement(QRCodeFailedView, { onActivated = onActivated, padding = 24 })
	else
		view = React.createElement(QRCodeLoadingView)
	end

	local v6 = p.isSmallScreen and 280 or 304

	return React.createElement(
		"Frame",
		{ Size = UDim2.new(0, 304, 0, v6), LayoutOrder = p.layoutOrder, BackgroundTransparency = 1 },
		{ View = view }
	)
end
