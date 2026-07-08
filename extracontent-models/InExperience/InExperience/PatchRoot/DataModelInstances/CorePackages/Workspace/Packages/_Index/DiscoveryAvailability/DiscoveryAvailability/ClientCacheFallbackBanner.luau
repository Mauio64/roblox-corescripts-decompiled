local Parent = script:FindFirstAncestor("DiscoveryAvailability").Parent
local AppBlox = require(Parent.AppBlox)
local React = require(Parent.React)
local Responsive = require(Parent.Responsive)
local Foundation = require(Parent.Foundation)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local CollectionViews = require(Parent.CollectionViews)
local UIBlox = require(Parent.UIBlox)

require(Parent.LuauPolyfill)

local NotificationModalsManager = require(Parent.NotificationModalsManager)
local usePageSideMargin = CollectionViews.usePageSideMargin
local Banner = AppBlox.Banner
local View = Foundation.View
local Enums = Foundation.Enums
local useTokens = Foundation.Hooks.useTokens

return function(t1: {[any]: any}) -- line: 28
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), usePageSideMargin (copy), Responsive (copy), NotificationModalsManager (copy), UIBlox (copy), View (copy), Banner (copy), Enums (copy)
	local v16 = useTokens()
	local v17 = useLocalization({
		errorTitle = "Feature.Home.ClientCacheFallbackBanner.Label.Error",
		errorMessage = "Feature.Home.ClientCacheFallbackBanner.Label.RefreshPageToLoadContents",
		refreshButton = "Feature.Home.ClientCacheFallbackBanner.Action.Refresh",
		errorRefreshingToastTitle = "Feature.Home.ClientCacheFallbackBanner.Label.ErrorRefreshingToastTitle"
	})
	local v18 = React.useRef(nil)
	local v19 = usePageSideMargin(v18.current)
	local v20 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
	local v21, v22 = React.useState(false)
	local v23 = React.useCallback(function() -- line: 45
		-- upvalues: v22 (copy), t1 (copy), NotificationModalsManager (copy), UIBlox (copy), v17 (copy)
		v22(true)
		t1.onRefreshButtonClick():andThen(function(_) -- line: 49
			-- upvalues: v22 (copy)
			v22(false)
		end):catch(function(_) -- line: 52
			-- upvalues: v22 (copy), NotificationModalsManager (copy), UIBlox (copy), v17 (copy)
			v22(false)
			NotificationModalsManager.SetUIBloxToast({
				iconImage = UIBlox.App.ImageSet.Images["icons/status/alert"],
				toastTitle = v17.errorRefreshingToastTitle,
				sequenceNumber = DateTime.now().UnixTimestamp
			})
		end)
	end, {
		t1.onRefreshButtonClick,
		v17.errorRefreshingToastTitle
	})

	return React.createElement(View, {
		position = t1.Position,
		[React.Change.AbsoluteSize] = t1[React.Change.AbsoluteSize],
		ref = v18,
		tag = "size-full-0 auto-y"
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v19),
			PaddingRight = UDim.new(0, v19),
			PaddingTop = UDim.new(0, v16.Padding.Large),
			PaddingBottom = UDim.new(0, if not v20 then v16.Padding.Large else 0)
		}),
		BannerContent = React.createElement(Banner, {
			icon = Enums.IconName.CircleX,
			iconVariant = Enums.IconVariant.Filled,
			iconStyle = v16.Color.System.Alert,
			title = v17.errorTitle,
			body = v17.errorMessage,
			buttons = {{
				text = v17.refreshButton,
				isLoading = v21,
				onActivated = v23
			}}
		})
	})
end
