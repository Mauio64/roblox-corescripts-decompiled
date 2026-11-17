local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Banner = require(Foundation.Components.Banner)
require(Foundation.Components.Banner.Banner)
local InternalFloatingElement = require(Foundation.Components.InternalFloatingElement)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

local BannerSize = require(Foundation.Enums.BannerSize)
local CardDensity = require(Foundation.Enums.CardDensity)
local ElevationLayer = require(Foundation.Enums.ElevationLayer)
local ScreenRegion = require(Foundation.Providers.ScreenRegion.ScreenRegion)
local ScreenRegionKind = require(Foundation.Providers.ScreenRegion.ScreenRegionKind)

local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = { testId = "--foundation-floating-banner" }

local function FloatingBanner(p, ref)
	local v2 = withDefaults(p, v)

	local state, setState = React.useState(false)
	React.useEffect(function()
		if not v2.isOpen then
			setState(false)
		end
	end, { v2.isOpen })

	local onClose = v2.onClose
	local primary

	if v2.actions then
		primary = v2.actions.primary
	else
		primary = nil
	end

	local actions = React.useMemo(function()
		if primary == nil then
			return nil
		end

		return {
			primary = {
				onActivated = function()
					setState(true)
					primary.onActivated()
				end
			}
		}
	end, { primary })
	local onClose2 = React.useMemo(function()
		if onClose == nil then
			return nil
		end

		return function()
			setState(true)
			onClose()
		end
	end, { onClose })

	return React.createElement(InternalFloatingElement, withCommonProps(v2, {
		isOpen = v2.isOpen and not state,
		onCloseComplete = v2.onCloseComplete,
		layer = ElevationLayer.Floating,
		queue = { region = ScreenRegion.Bottom, kind = ScreenRegionKind.FloatingBanner },
		ref = ref
	}), {
		Fill = React.createElement(
			View,
			{
				LayoutOrder = 1,
				tag = "shadow-overlay-100 size-full-0 auto-y radius-medium bg-surface-200",
				testId = `{v2.testId}--fill`
			},
			{
				Banner = React.createElement(Banner, {
					size = BannerSize.Small,
					density = CardDensity.Compact,
					title = v2.title,
					description = v2.description,
					thumbnail = v2.thumbnail,
					actions = actions,
					onClose = onClose2,
					testId = `{v2.testId}--banner`
				})
			}
		)
	})
end

return React.memo(React.forwardRef(FloatingBanner))
