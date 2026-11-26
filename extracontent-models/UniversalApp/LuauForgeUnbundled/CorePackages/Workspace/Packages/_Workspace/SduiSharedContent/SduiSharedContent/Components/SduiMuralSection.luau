local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/AppCommonLib")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/CollectionViews")
local useCollectionLayout = CollectionViews.useCollectionLayout
local maybeForceDarkTheme = CollectionViews.maybeForceDarkTheme

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")

local fFlagLuaAppCompositionAlways = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagLuaAppCompositionAlways

local function MuralArtImage(p2)
	local v5 = useTokens()
	local createElement = React.createElement
	local v7 = {
		Size = UDim2.fromScale(1, 1),
		Image = p2.image,
		ScaleType = Enum.ScaleType.Crop,
		BackgroundColor3 = v5.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v5.Color.Surface.Surface_0.Transparency,
		ZIndex = -1
	}

	local v9 = if p2.cornerRadius > 0 then React.createElement("UICorner", {
		CornerRadius = UDim.new(0, p2.cornerRadius)
	}) else nil
	return createElement("ImageLabel", v7, { UICorner = v9 })
end

local function SduiMuralSection(props)
	local v5 = fFlagLuaAppCompositionAlways
		or props.appCompositionEnabled
		or props.sduiContext.appCompositionEnabled
	local v6 = useCollectionLayout()
	local v7 = not (props.contentTag == nil) and string.find(props.contentTag, "padding", 1, true) ~= nil
	local v8 = not (props.fullBleed and v5) and 0 or v6.margin
	local cornerRadius = props.cornerRadius or 0
	local v9, v10 = React.useBinding(0)
	local v11 = React.useCallback(function(p2)
		v10(p2.AbsoluteSize.Y)
	end, {})

	local v12 = React.useMemo(function()
		if props.content then
			return React.cloneElement(props.content, {
				extraLocalProps = {
					appCompositionEnabled = v5,
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
		v5,
		props.scrollViewPositionChangedSignal,
		props.verticalScrollingFrameRef,
		props.startRow,
		props.numUpdatesToDelayImpressions,
		props.index,
		props.selectionOrderBase,
		props.pageSideMargin
	})
	local v14

	if props.backgroundMuralUrl then
		v14 = React.createElement(view, {
			Position = UDim2.new(0, -v8, 0, 0),
			Size = v9:map(function(p2)
				return UDim2.new(1, 2 * v8, 0, (math.ceil(p2)))
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

	local v13 = {
		Art = v14,
		Content = React.createElement(view, {
			tag = {
				["col size-full-0 auto-y"] = true,
				["padding-y-xxlarge"] = props.backgroundMuralUrl ~= nil and not v7,
				[props.contentTag or ""] = props.contentTag ~= nil
			},
			testId = "--sdui-mural-section-content",
			onAbsoluteSizeChanged = v11
		}, { Content = v12 })
	}

	return React.createElement(view, {
		tag = "size-full-0 auto-y",
		LayoutOrder = props.layoutOrder,
		testId = props.testId or "--sdui-mural-section"
	}, {
		Section = maybeForceDarkTheme(
			React.createElement(React.Fragment, nil, v13),
			props.colorMode == "Dark"
		)
	})
end

return React.memo(SduiMuralSection)
