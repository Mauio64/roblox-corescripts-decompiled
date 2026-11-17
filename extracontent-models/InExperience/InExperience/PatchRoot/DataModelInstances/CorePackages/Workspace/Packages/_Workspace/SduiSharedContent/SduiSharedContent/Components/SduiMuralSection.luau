local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
require(parent.AppCommonLib)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local CollectionViews = require(parent.CollectionViews)
local useCollectionLayout = CollectionViews.useCollectionLayout
local maybeForceDarkTheme = CollectionViews.maybeForceDarkTheme

require(parent.SduiCoreSystem)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways

local function MuralArtImage(p)
	local v = useTokens()
	local createElement = React.createElement
	local v2 = {
		Size = UDim2.fromScale(1, 1),
		Image = p.image,
		ScaleType = Enum.ScaleType.Crop,
		BackgroundColor3 = v.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v.Color.Surface.Surface_0.Transparency,
		ZIndex = -1
	}
	local uiCorner

	if p.cornerRadius > 0 then
		uiCorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, p.cornerRadius) })
	end

	return createElement("ImageLabel", v2, { UICorner = uiCorner })
end

local function SduiMuralSection(props)
	local appCompositionEnabled = FFlagLuaAppCompositionAlways
		or props.appCompositionEnabled
		or props.sduiContext.appCompositionEnabled
	local v = useCollectionLayout()
	local v2

	if props.contentTag == nil then
		v2 = false
	else
		v2 = string.find(props.contentTag, "padding", 1, true) ~= nil
	end

	local v3 = not (props.fullBleed and appCompositionEnabled) and 0 or v.margin
	local cornerRadius = props.cornerRadius or 0
	local v4, v5 = React.useBinding(0)
	local onAbsoluteSizeChanged = React.useCallback(function(p)
		v5(p.AbsoluteSize.Y)
	end, {})

	local content = React.useMemo(function()
		if props.content then
			return React.cloneElement(props.content, {
				extraLocalProps = {
					appCompositionEnabled = appCompositionEnabled,
					scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
					verticalScrollingFrameRef = props.verticalScrollingFrameRef,
					startRow = props.startRow,
					numUpdatesToDelayImpressions = props.numUpdatesToDelayImpressions,
					index = props.index,
					selectionOrderBase = props.selectionOrderBase,
					pageSideMargin = props.pageSideMargin
				}
			})
		end

		return nil
	end, {
		props.content,
		appCompositionEnabled,
		props.scrollViewPositionChangedSignal,
		props.verticalScrollingFrameRef,
		props.startRow,
		props.numUpdatesToDelayImpressions,
		props.index,
		props.selectionOrderBase,
		props.pageSideMargin
	})
	local art

	if props.backgroundMuralUrl then
		art = React.createElement(View, {
			Position = UDim2.new(0, -v3, 0, 0),
			Size = v4:map(function(p: number)
				return UDim2.new(1, 2 * v3, 0, (math.ceil(p)))
			end),
			ZIndex = -1,
			testId = "--sdui-mural-section-art"
		}, {
			Image = React.createElement(MuralArtImage, {
				image = props.backgroundMuralUrl,
				cornerRadius = cornerRadius
			})
		})
	end

	local v6 = {
		Art = art,
		Content = React.createElement(View, {
			tag = {
				["col size-full-0 auto-y"] = true,
				["padding-y-xxlarge"] = props.backgroundMuralUrl ~= nil and not v2,
				[props.contentTag or ""] = props.contentTag ~= nil
			},
			testId = "--sdui-mural-section-content",
			onAbsoluteSizeChanged = onAbsoluteSizeChanged
		}, { Content = content })
	}

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = props.layoutOrder,
		testId = props.testId or "--sdui-mural-section"
	}, {
		Section = maybeForceDarkTheme(React.createElement(React.Fragment, nil, v6), props.colorMode == "Dark")
	})
end

return React.memo(SduiMuralSection)
