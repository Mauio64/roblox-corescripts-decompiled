local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/Foundation")
local view = Foundation.View
local module3 = require("@luauforge/bundled/dTL")
local avatarScreen = module3.Enums.AvatarScreen
local unifiedLoggingSurface = module3.Enums.UnifiedLoggingSurface
local module4 = require("@luauforge/bundled/dTM")
local sduiFeatureEntryPoint = module4.SduiFeatureEntryPoint
local sduiLoadTimer = module4.SduiLoadTimer

local module5 = require("@luauforge/bundled/dTN")
local module6 = require("@luauforge/bundled/dTO")
local module7 = require("@luauforge/bundled/dTS")
local module8 = require("@luauforge/bundled/dTV")
local module9 = require("@luauforge/bundled/dTH")
local module10 = require("@luauforge/bundled/dTW")

local fFlagAXItemDetailsSduiFillView = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/AvatarExperienceFlags").FFlagAXItemDetailsSduiFillView

local function ItemDetailsSduiEntryPoint(props, ref)
	local v5 = React.useMemo(function()
		return sduiLoadTimer.createLoadTimer(avatarScreen.ItemDetails)
	end, {})

	if props.loadTimer then
		v5 = props.loadTimer
	end

	local v6 = if props.appPage then props.appPage else avatarScreen.ItemDetails

	local v7 = React.useMemo(function()
		return { surface = unifiedLoggingSurface.ITEM_DETAILS }
	end, {})

	local v8 = React.useMemo(function()
		return {
			itemId = props.itemId,
			itemType = props.itemType,
			screenSize = not props.screenSize and "" or props.screenSize,
			entryContext = props.entryContext
		}
	end, { props.itemId, props.itemType, props.screenSize, props.entryContext })

	local v9 = React.useMemo(function()
		return module7(v8.itemType, v8.itemId, v8.screenSize, v8.entryContext)
	end, { v8 })

	React.useEffect(function()
		module6(v8, v5)
	end, { v5, v8 })

	local v10 = React.useCallback(function()
		module6(v8, v5, { forceRefresh = true })
	end, { v5, v8 })

	local v11 = React.useMemo(function()
		local scrollingFrameRef = props.scrollingFrameRef

		if scrollingFrameRef == nil then
			return nil
		end

		return {
			scrollingFrameRef = scrollingFrameRef,
			scrollToSelectionAnimationManagedByParent = true
		}
	end, { props.scrollingFrameRef })

	local actionHandlers = props.actionHandlers
	React.useEffect(function()
		if actionHandlers == nil then
			return nil
		end

		return module9.add(v9, actionHandlers)
	end, { v9, actionHandlers })

	local actionBarHeaderRef = props.actionBarHeaderRef
	local ref2 = React.useRef(nil)
	local v12 = React.useCallback(function()
		local current = ref2.current
		local current2 = if actionBarHeaderRef then actionBarHeaderRef.current else nil

		if current and current2 then
			current2.Visible = module8(current.AbsolutePosition.Y, current2.AbsolutePosition.Y)
		end
	end, { actionBarHeaderRef })

	React.useEffect(function()
		if actionBarHeaderRef == nil then
			return nil
		end

		local thread = task.defer(v12)
		return function()
			task.cancel(thread)
		end
	end, { actionBarHeaderRef, v12 })

	local loadingHeight = props.loadingHeight
	local v13

	if fFlagAXItemDetailsSduiFillView then
		v13 = React.useMemo(function()
			if props.loadingSlot == nil and loadingHeight ~= nil then
				return React.createElement(
					view,
					{
						testId = "item-details-sdui-loading",
						Size = UDim2.new(1, 0, 0, loadingHeight)
					},
					{
						Loading = React.createElement(Foundation.Loading, {
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.5)
						})
					}
				)
			end

			return props.loadingSlot
		end, { props.loadingSlot, loadingHeight })
	end

	local setParentScrollingEnabled = props.setParentScrollingEnabled
	local v14 = React.useMemo(function()
		return { setParentScrollingEnabled = setParentScrollingEnabled }
	end, { setParentScrollingEnabled })

	local createElement = React.createElement
	local provider = module10.Provider

	local createElement2 = React.createElement
	local v18 = {
		tag = "bg-surface-0",
		testId = "item-details-sdui-body",
		Size = props.Size,
		AutomaticSize = props.AutomaticSize,
		Position = props.Position,
		onAbsolutePositionChanged = if actionBarHeaderRef then v12 else nil,
		padding = props.bottomPadding and {
			bottom = UDim.new(0, props.bottomPadding)
		} or nil,
		ref = ref2
	}

	local createElement3 = React.createElement
	local v22 = {
		configKey = v9,
		identifier = module5.ItemDetailsPageIdentifier,
		appPage = v6,
		additionalAnalyticsData = v7,
		loadTimer = v5,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		onRetry = v10,
		shouldDisplayLoading = props.shouldDisplayLoading,
		shouldDisplayError = props.shouldDisplayError,
		loadingSlot = 0,
		errorSlot = 0,
		extraLocalProps = 0,
		ref = 0
	}

	if not fFlagAXItemDetailsSduiFillView then
		v13 = props.loadingSlot
	end

	v22.loadingSlot = v13
	v22.errorSlot = props.errorSlot
	v22.extraLocalProps = v11
	v22.ref = ref
	return createElement(provider, { value = v14 }, {
		Body = createElement2(view, v18, {
			SduiFeatureEntryPoint = createElement3(sduiFeatureEntryPoint, v22)
		})
	})
end

return React.forwardRef(ItemDetailsSduiEntryPoint)
