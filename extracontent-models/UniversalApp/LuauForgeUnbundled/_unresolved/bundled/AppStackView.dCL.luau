local React = require("@game/CorePackages/Workspace/Packages/React")

local module2 = require("@luauforge/bundled/dCC")
local useStackScreens = module2.useStackScreens
local viewState = module2.ViewState

local module3 = require("@luauforge/bundled/dCM")
local module4 = require("@luauforge/bundled/dDj")
local useSignalState = require("@luauforge/bundled/dDk").useSignalState
local module5 = require("@luauforge/bundled/dCz")
local fFlagEnableSplitPane = module5.FFlagEnableSplitPane
local fFlagEnableSplitPaneStackFallbackFix = module5.FFlagEnableSplitPaneStackFallbackFix
local fFlagSplitPaneIneligibleStackFallback = module5.FFlagSplitPaneIneligibleStackFallback
local fFlagSplitPaneOpaqueExpandedPages = module5.FFlagSplitPaneOpaqueExpandedPages

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/dDi") else nil
local supportPaneMode

if fFlagSplitPaneOpaqueExpandedPages then
	supportPaneMode = require("@luauforge/bundled/dDl").Enums.SupportPaneMode
else
	supportPaneMode = nil
end

local isSupportPaneScreen = if fFlagEnableSplitPane then v5.isSupportPaneScreen else nil
local useSplitLayoutStatus = if fFlagEnableSplitPane then v5.useSplitLayoutStatus else nil
local splitPaneNavigationLayout = if fFlagEnableSplitPane then v5.SplitPaneNavigationLayout else nil
local splitPaneStore = if fFlagEnableSplitPane then v5.SplitPaneStore else nil

local fFlagEnableOnScreenAPIIntegration = module5.FFlagEnableOnScreenAPIIntegration

local getOnScreenContextValue = if fFlagEnableOnScreenAPIIntegration then v5.getOnScreenContextValue else nil

local v6 = { overlayTransparency = 0.7, overlayColor3 = Color3.new(0, 0, 0) }

local function AppStackView(props)
	local v7 = useStackScreens({
		navigation = props.navigation,
		descriptors = props.descriptors
	})
	local v8

	if fFlagEnableSplitPane and fFlagEnableSplitPaneStackFallbackFix then
		v8 = useSignalState(splitPaneStore.getStore().getWasSplitPaneAvailable)
	else
		v8 = false
	end

	local v9

	if fFlagSplitPaneOpaqueExpandedPages then
		v9 = useSignalState(splitPaneStore.getStore().getSupportPaneMode)
	end

	local v10 = if fFlagSplitPaneOpaqueExpandedPages then v9 == supportPaneMode.Expanded else false

	local function fn()
		local v11 = 0
		local v12 = 0

		for i = #v7, 1, -1 do
			local descriptor = v7[i].descriptor

			local v13 = fFlagEnableSplitPane
				and (not fFlagEnableSplitPaneStackFallbackFix or v8)
				and isSupportPaneScreen(v7[i])
			local v14 = not (descriptor.options.transparent or descriptor.options.overlayEnabled)

			if v13 then
				if fFlagSplitPaneOpaqueExpandedPages and v10 then
					if v14 and v11 == 0 then
						v11 = i
					end
				else
					continue
				end
			end

			if v14 and v12 == 0 then
				v12 = i
			end

			local v15 = not (fFlagSplitPaneOpaqueExpandedPages and v10) or v11 ~= 0

			if v12 ~= 0 and v15 then
				break
			end
		end

		return { topMostOpaqueSceneIndex = v12, topMostOpaqueSupportSceneIndex = v11 }
	end

	local v13 = React.useMemo(fn, { v7, v8, if fFlagSplitPaneOpaqueExpandedPages then v10 else nil })

	local topMostOpaqueSceneIndex = v13.topMostOpaqueSceneIndex
	local topMostOpaqueSupportSceneIndex = v13.topMostOpaqueSupportSceneIndex

	local elements = {}

	local v14 = useSignalState(module4.GetDisplayStore().getDeviceSafePadding)

	local v15 = if fFlagEnableSplitPane then useSplitLayoutStatus(v7, topMostOpaqueSceneIndex) else nil
	local v16 = not (v15 == nil) and v15.isSplitLayoutEnabled
	local v17 = not (v15 == nil) and v15.isRouteActiveOnPane
	local v18

	if fFlagSplitPaneIneligibleStackFallback and v15 ~= nil then
		v18 = not v15.isSplitEnabled
	else
		v18 = false
	end

	local v19 = nil

	if fFlagEnableSplitPane then
		for i = #v7, 1, -1 do
			if
				v7[i].viewState ~= viewState.Closing
				and (fFlagEnableSplitPaneStackFallbackFix and not v8 or not isSupportPaneScreen(v7[i]))
			then
				v19 = v7[i]
				break
			end
		end
	else
		v19 = v7[#v7]
	end

	if v19 and not (fFlagEnableSplitPane and v16 and v17) then
		local options = v19.descriptor.options

		if options.absorbInput == nil or options.absorbInput then
			elements.AbsorbInput = React.createElement("TextButton", {
				Active = true,
				Selectable = options.absorbInputSelectable or false,
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(0, -v14.top),
				Size = UDim2.new(1, v14.right, 1, v14.top + v14.bottom),
				Text = "",
				ZIndex = #v7 * 2 - 1
			})
		end

		if options.overlayEnabled then
			elements.Overlay = React.createElement("Frame", {
				Position = UDim2.fromOffset(0, -v14.top),
				Size = UDim2.new(1, v14.right, 1, v14.top + v14.bottom),
				BackgroundTransparency = options.overlayTransparency or v6.overlayTransparency,
				BackgroundColor3 = v6.overlayColor3,
				ClipsDescendants = true,
				BorderSizePixel = 0,
				ZIndex = #v7 * 2 - 1
			})
		end
	end

	for k, v20 in v7 do
		if not (not fFlagEnableSplitPane or fFlagEnableSplitPaneStackFallbackFix and not v8 or v18 or v16 or not isSupportPaneScreen(v20)) then
			continue
		end

		local v21 = if fFlagEnableOnScreenAPIIntegration then getOnScreenContextValue(v15, k, v20) else nil

		local createElement = React.createElement
		local v23 = {
			isActive = k == #v7,
			descriptor = v20.descriptor,
			screenProps = props.screenProps,
			isVisible = 0,
			ZIndex = 0,
			onAnimationComplete = 0,
			onScreenContextValue = 0
		}
		local v24

		if fFlagEnableSplitPane then
			if fFlagSplitPaneOpaqueExpandedPages and v10 and v17 and isSupportPaneScreen(v20) then
				v24 = topMostOpaqueSupportSceneIndex <= k
			else
				v24 = v16 and not (fFlagSplitPaneOpaqueExpandedPages and v10) and true
					or topMostOpaqueSceneIndex <= k
			end
		else
			v24 = topMostOpaqueSceneIndex <= k
		end

		v23.isVisible = v24

		v23.ZIndex = k * 2
		function v23.onAnimationComplete()
			if v20.viewState == viewState.Opening or v20.viewState == viewState.Opened then
				v20.setOpened()
			elseif v20.viewState == viewState.Closing then
				v20.setClosed()
			end
		end
		v23.onScreenContextValue = v21
		local element = createElement(module3, v23)

		elements[v20.descriptor.key] = element
	end

	if fFlagEnableSplitPane and v15 ~= nil and v15.isSplitLayoutEnabled then
		return React.createElement(splitPaneNavigationLayout, {
			screens = v7,
			cards = elements,
			paneIndices = v15.paneIndices,
			isRouteActiveOnPane = v15.isRouteActiveOnPane
		})
	end

	return React.createElement(React.Fragment, nil, elements)
end

return AppStackView
