local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/React")
local useGetProfileShareUrl = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Networking/useGetProfileShareUrl")
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/useAnalytics")
local useShortUrl = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Rodux/useShortUrl")
local useHasLoadedSuccessfully = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Components/QRCodeView/useHasLoadedSuccessfully")
local useLoadingState = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Networking/useLoadingState")
local useRefreshQrSession = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Networking/useRefreshQrSession")
local networkStatus = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Networking/configuredRoduxNetworking").Enum.NetworkStatus
local QRCodeFailedView = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Components/QRCodeView/QRCodeFailedView")
local QRCodeSucceededView = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Components/QRCodeView/QRCodeSucceededView")
local QRCodeLoadingView = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Components/QRCodeView/QRCodeLoadingView")
local useEffectOnce = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/RoactUtils").Hooks.useEffectOnce
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/EventNames")

local useHasFailedToLoad = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Components/QRCodeView/useHasFailedToLoad")

return function(p2)
	local v5 = useAnalytics()
	local v6 = useLoadingState()
	local v7 = useGetProfileShareUrl()
	local v8 = useRefreshQrSession()

	local v9 = useShortUrl()
	local v10 = v9 ~= nil
	local v11 = v6 == networkStatus.Failed

	React.useEffect(function()
		v8():andThen(function(p3)
			local responseBody = p3 and p3.responseBody or {}
			local responseCode = p3 and p3.responseCode
			v5.fireEvent(EventNames.RefreshQrSession, {
				success = responseBody.Success,
				responseCode = responseCode
			})
		end)
	end, {})

	useEffectOnce(v7, not v10)
	useHasLoadedSuccessfully(v5, v10)
	useHasFailedToLoad(v5, v11)
	local v12

	if v10 then
		v12 = React.createElement(QRCodeSucceededView, {
			url = v9,
			qrCodeLength = 200,
			padding = 24,
			isSmallScreen = p2.isSmallScreen
		})
	elseif v11 then
		v12 = React.createElement(QRCodeFailedView, { onActivated = v7, padding = 24 })
	else
		v12 = React.createElement(QRCodeLoadingView)
	end

	local v13 = p2.isSmallScreen and 280 or 304

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(0, 304, 0, v13),
			LayoutOrder = p2.layoutOrder,
			BackgroundTransparency = 1
		},
		{ View = v12 }
	)
end
