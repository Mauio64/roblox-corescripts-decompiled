local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/Foundation")
local module2 = require("@luauforge/bundled/dQv")
local avatarScreen = module2.Enums.AvatarScreen
local unifiedLoggingSurface = module2.Enums.UnifiedLoggingSurface
local module3 = require("@luauforge/bundled/dQw")
local sduiFeatureEntryPoint = module3.SduiFeatureEntryPoint
local sduiLoadTimer = module3.SduiLoadTimer

local module4 = require("@luauforge/bundled/dQx")
local module5 = require("@luauforge/bundled/dQy")
local module6 = require("@luauforge/bundled/dQC")
local module7 = require("@luauforge/bundled/dQr")
local module8 = require("@luauforge/bundled/dQF")

local function ItemDetailsSduiEntryPoint(props, p2)
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
		return module6(v8.itemType, v8.itemId, v8.screenSize, v8.entryContext)
	end, { v8 })

	React.useEffect(function()
		module5(v8, v5)
	end, { v5, v8 })

	local v10 = React.useCallback(function()
		module5(v8, v5, { forceRefresh = true })
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

		return module7.add(v9, actionHandlers)
	end, { v9, actionHandlers })

	local setParentScrollingEnabled = props.setParentScrollingEnabled
	local v12 = React.useMemo(function()
		return { setParentScrollingEnabled = setParentScrollingEnabled }
	end, { setParentScrollingEnabled })

	return React.createElement(module8.Provider, { value = v12 }, {
		SduiFeatureEntryPoint = React.createElement(sduiFeatureEntryPoint, {
			configKey = v9,
			identifier = module4.ItemDetailsPageIdentifier,
			appPage = v6,
			additionalAnalyticsData = v7,
			loadTimer = v5,
			Size = props.Size,
			AutomaticSize = props.AutomaticSize,
			Position = props.Position,
			onRetry = v10,
			shouldDisplayLoading = props.shouldDisplayLoading,
			shouldDisplayError = props.shouldDisplayError,
			loadingSlot = props.loadingSlot,
			errorSlot = props.errorSlot,
			extraLocalProps = v11,
			ref = p2
		})
	})
end

return React.forwardRef(ItemDetailsSduiEntryPoint)
