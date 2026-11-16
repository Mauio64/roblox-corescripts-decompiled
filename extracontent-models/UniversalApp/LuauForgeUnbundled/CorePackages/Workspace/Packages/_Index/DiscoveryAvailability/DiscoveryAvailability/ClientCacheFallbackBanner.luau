local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/AppBlox")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/Responsive")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/Localization").Hooks.useLocalization
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/CollectionViews")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/UIBlox")
require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/LuauPolyfill")
local NotificationModalsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/NotificationModalsManager")
local usePageSideMargin = CollectionViews.usePageSideMargin

local banner = AppBlox.Banner
local view = Foundation.View
local enums = Foundation.Enums
local useTokens = Foundation.Hooks.useTokens

return function(p2)
	local v5 = useTokens()
	local v6 = useLocalization({
		errorTitle = "Feature.Home.ClientCacheFallbackBanner.Label.Error",
		errorMessage = "Feature.Home.ClientCacheFallbackBanner.Label.RefreshPageToLoadContents",
		refreshButton = "Feature.Home.ClientCacheFallbackBanner.Action.Refresh",
		errorRefreshingToastTitle = "Feature.Home.ClientCacheFallbackBanner.Label.ErrorRefreshingToastTitle"
	})

	local ref = React.useRef(nil)

	local v7 = usePageSideMargin(ref.current)

	local v8 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)

	local state, setState = React.useState(false)

	local v9 = React.useCallback(function()
		setState(true)
		p2.onRefreshButtonClick():andThen(function(p3)
			setState(false)
		end):catch(function(p3)
			setState(false)
			NotificationModalsManager.SetUIBloxToast({
				iconImage = UIBlox.App.ImageSet.Images["icons/status/alert"],
				toastTitle = v6.errorRefreshingToastTitle,
				sequenceNumber = DateTime.now().UnixTimestamp
			})
		end)
	end, { p2.onRefreshButtonClick, v6.errorRefreshingToastTitle })

	return React.createElement(
		view,
		{
			position = p2.Position,
			[React.Change.AbsoluteSize] = p2[React.Change.AbsoluteSize],
			ref = ref,
			tag = "size-full-0 auto-y"
		},
		{
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v7),
				PaddingRight = UDim.new(0, v7),
				PaddingTop = UDim.new(0, v5.Padding.Large),
				PaddingBottom = UDim.new(0, v8 and 0 or v5.Padding.Large)
			}),
			BannerContent = React.createElement(banner, {
				icon = enums.IconName.CircleX,
				iconVariant = enums.IconVariant.Filled,
				iconStyle = v5.Color.System.Alert,
				title = v6.errorTitle,
				body = v6.errorMessage,
				buttons = {
					{ text = v6.refreshButton, isLoading = state, onActivated = v9 }
				}
			})
		}
	)
end
