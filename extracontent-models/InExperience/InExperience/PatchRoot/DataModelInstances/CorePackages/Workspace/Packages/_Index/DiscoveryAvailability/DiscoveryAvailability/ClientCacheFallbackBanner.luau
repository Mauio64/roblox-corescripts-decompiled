local parent = script:FindFirstAncestor("DiscoveryAvailability").Parent
local AppBlox = require(parent.AppBlox)
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local CollectionViews = require(parent.CollectionViews)
local UIBlox = require(parent.UIBlox)
require(parent.LuauPolyfill)
local NotificationModalsManager = require(parent.NotificationModalsManager)
local usePageSideMargin = CollectionViews.usePageSideMargin

local Banner = AppBlox.Banner
local View = Foundation.View
local Enums = Foundation.Enums
local useTokens = Foundation.Hooks.useTokens

return function(p)
	local v = useTokens()
	local v2 = useLocalization({
		errorTitle = "Feature.Home.ClientCacheFallbackBanner.Label.Error",
		errorMessage = "Feature.Home.ClientCacheFallbackBanner.Label.RefreshPageToLoadContents",
		refreshButton = "Feature.Home.ClientCacheFallbackBanner.Action.Refresh",
		errorRefreshingToastTitle = "Feature.Home.ClientCacheFallbackBanner.Label.ErrorRefreshingToastTitle"
	})

	local ref = React.useRef(nil)

	local v3 = usePageSideMargin(ref.current)

	local v4 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)

	local state, setState = React.useState(false)

	local onActivated = React.useCallback(function()
		setState(true)
		p.onRefreshButtonClick():andThen(function(_)
			setState(false)
		end):catch(function(_)
			setState(false)
			NotificationModalsManager.SetUIBloxToast({
				iconImage = UIBlox.App.ImageSet.Images["icons/status/alert"],
				toastTitle = v2.errorRefreshingToastTitle,
				sequenceNumber = DateTime.now().UnixTimestamp
			})
		end)
	end, { p.onRefreshButtonClick, v2.errorRefreshingToastTitle })

	return React.createElement(
		View,
		{
			position = p.Position,
			[React.Change.AbsoluteSize] = p[React.Change.AbsoluteSize],
			ref = ref,
			tag = "size-full-0 auto-y"
		},
		{
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v3),
				PaddingRight = UDim.new(0, v3),
				PaddingTop = UDim.new(0, v.Padding.Large),
				PaddingBottom = UDim.new(0, v4 and 0 or v.Padding.Large)
			}),
			BannerContent = React.createElement(Banner, {
				icon = Enums.IconName.CircleX,
				iconVariant = Enums.IconVariant.Filled,
				iconStyle = v.Color.System.Alert,
				title = v2.errorTitle,
				body = v2.errorMessage,
				buttons = {
					{ text = v2.refreshButton, isLoading = state, onActivated = onActivated }
				}
			})
		}
	)
end
