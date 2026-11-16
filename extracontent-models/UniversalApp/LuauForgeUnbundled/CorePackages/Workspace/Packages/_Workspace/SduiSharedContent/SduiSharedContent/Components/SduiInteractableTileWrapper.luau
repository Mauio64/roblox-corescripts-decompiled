local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/AppBlox")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SignalsReact")

local SduiTileOverflowMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiTileOverflowMenu")

local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local useSignalState = SignalsReact.useSignalState
local useUidRefString = SduiCoreSystem.useUidRefString

local function InteractableTileWrapperMenu(props)
	local v5 = useSignalState(props.getIsHovered)
	local v6 = useSignalState(props.getIsSelected)

	return React.createElement(SduiTileOverflowMenu, {
		componentConfig = props.componentConfig,
		debugName = "SduiInteractableTileWrapper.OverflowMenu",
		isHovered = v5,
		isSelected = v6,
		menuKey = props.menuKey,
		parentRef = props.parentRef,
		sduiContext = props.sduiContext,
		zIndex = 5
	})
end

local function useTileMenu(sduiContext)
	local formatted = `sdui-interactable-tile-wrapper-{useUidRefString().current}`
	local ref = React.useRef(nil)

	local v5 = React.useMemo(function()
		local signal, v6 = Signals.createSignal(false)
		local signal2, v7 = Signals.createSignal(false)
		return {
			getIsHovered = signal,
			setIsHovered = v6,
			getIsSelected = signal2,
			setIsSelected = v7
		}
	end, {})

	local triggerFeedback = sduiContext.dependencies.triggerFeedback
	local appPage = sduiContext.appPage

	return React.useMemo(function()
		return {
			menuKey = formatted,
			tileRef = ref,
			getIsHovered = v5.getIsHovered,
			getIsSelected = v5.getIsSelected,
			tileHandlers = {
				setGuiObject = function(current)
					ref.current = current
				end,
				onMouseEnter = function()
					v5.setIsHovered(true)
				end,
				onMouseLeave = function()
					v5.setIsHovered(false)
				end,
				onSelectionGained = function()
					v5.setIsSelected(true)
				end,
				onSelectionLost = function()
					v5.setIsSelected(false)
				end,
				onTouchLongPress = function()
					local overflowMenuSignalStore = getOverflowMenuSignalStore()

					if triggerFeedback and not overflowMenuSignalStore.getIsMenuOpen(formatted) then
						triggerFeedback("TileLongPress", "Press", appPage or "Unknown")
					end

					overflowMenuSignalStore.openMenu(formatted)
				end
			}
		}
	end, { formatted, v5, triggerFeedback, appPage })
end

local function SduiInteractableTileWrapper(data)
	local v5 = useTileMenu(data.sduiContext)

	local overflowMenuComponent = data.overflowMenuComponent
	local sduiContext = data.sduiContext
	local v6 = React.useMemo(function()
		if overflowMenuComponent then
			return (React.createElement(InteractableTileWrapperMenu, {
				sduiContext = sduiContext,
				componentConfig = overflowMenuComponent,
				menuKey = v5.menuKey,
				parentRef = v5.tileRef,
				getIsHovered = v5.getIsHovered,
				getIsSelected = v5.getIsSelected
			}))
		end

		return nil
	end, { overflowMenuComponent, sduiContext, v5 })

	local tileComponent = data.tileComponent

	if not tileComponent then
		return nil
	end

	local joined = {
		size = data.size,
		layoutOrder = data.layoutOrder,
		selectionOrder = data.selectionOrder
	}

	if v6 then
		joined = Cryo.Dictionary.join(joined, v5.tileHandlers, {
			thumbnailOverflowMenuComponent = v6
		})
	end

	return React.cloneElement(tileComponent, {
		parentAnalyticsContext = data.analyticsContext,
		extraLocalProps = joined
	})
end

return React.memo(SduiInteractableTileWrapper)
