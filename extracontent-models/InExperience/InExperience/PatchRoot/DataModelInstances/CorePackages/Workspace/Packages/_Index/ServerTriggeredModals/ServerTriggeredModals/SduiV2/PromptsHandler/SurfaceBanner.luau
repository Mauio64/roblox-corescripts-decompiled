local Parent = script:FindFirstAncestor("ServerTriggeredModals").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local AppNavBar = require(Parent.AppNavBar)
local SduiSharedUtilities = require(Parent.SduiSharedUtilities)
local SignalsReact = require(Parent.SignalsReact)
local RobloxAppHooks = require(Parent.RobloxAppHooks)
local View = Foundation.View
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local useComponentConfig = SduiSharedUtilities.useComponentConfig
local useStatusBarHeight = RobloxAppHooks.useStatusBarHeight
local useTopBarHeight = RobloxAppHooks.useTopBarHeight
local VisibilityControl = AppNavBar.VisibilityControl

local function noopGetter() -- line: 30
	return nil
end
local function SurfaceBanner(t1: {[any]: any}) -- line: 34
	-- upvalues: useStatusBarHeight (copy), useTopBarHeight (copy), React (copy), VisibilityControl (copy), useComponentConfig (copy), noopGetter (copy), SignalsReact (copy), View (copy), SduiFeatureEntryPoint (copy)
	local v17 = useStatusBarHeight()
	local v18 = useTopBarHeight()
	local v19, v20 = React.useState(0)
	local v21 = VisibilityControl.getHeaderBinding()
	local v22 = t1.identifier ~= nil
	local v23 = useComponentConfig(t1.configKey, t1.identifier)
	local v24 = if not v22 then nil else v23
	local v25 = if not v24 or not v24.props then nil else v24.props.backgroundStyle
	local v26 = if not v24 or (not v24.propSignals or not v24.propSignals.backgroundStyle) then noopGetter else v24.propSignals.backgroundStyle
	local v27 = SignalsReact.useSignalState(v26)
	local v28 = if v25 == nil then if v27 == nil then nil else v27.data else v25
	local v29 = v21:map(function(n1: number) -- line: 70
		-- upvalues: v17 (copy), v18 (copy)
		return UDim2.new(0, 0, 0, (math.max(v17, n1 * v18)))
	end)
	local v30 = v21:map(function(n2: number) -- line: 80
		-- upvalues: v17 (copy), v18 (copy)
		return UDim2.new(1, 0, 0, (math.max(0, v17 - n2 * v18)))
	end)
	local surfaceBannerContent = t1.surfaceBannerContent
	local v32 = surfaceBannerContent and (not not surfaceBannerContent.props and surfaceBannerContent.props.canvasTopPadding) or 0
	local v33 = if not surfaceBannerContent then nil else React.cloneElement(surfaceBannerContent, {
		canvasTopPadding = v32 + v19
	})

	return React.createElement(View, {
		tag = "size-full"
	}, {
		Content = v33,
		Filler = if not v22 then nil else React.createElement(View, {
			ZIndex = 2,
			backgroundStyle = v28,
			AnchorPoint = Vector2.new(0, 1),
			Position = v29,
			Size = v30
		}),
		Banner = React.createElement(View, {
			ZIndex = 2,
			Position = v29,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			onAbsoluteSizeChanged = function(p1) -- line: 110
				-- upvalues: v20 (copy)
				v20(p1.AbsoluteSize.Y)
			end
		}, {
			SurfaceBanner = if not v22 then nil else React.createElement(SduiFeatureEntryPoint, {
				shouldDisplayLoading = false,
				shouldDisplayError = false,
				configKey = t1.configKey,
				identifier = t1.identifier,
				appPage = t1.appPage
			})
		})
	})
end

return React.memo(SurfaceBanner)
