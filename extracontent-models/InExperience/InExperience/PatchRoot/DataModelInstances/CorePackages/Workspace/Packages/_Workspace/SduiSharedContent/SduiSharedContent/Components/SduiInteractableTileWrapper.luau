local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local parent = SduiSharedContent.Parent

local AppBlox = require(parent.AppBlox)
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local SduiTileOverflowMenu = require(SduiSharedContent.Components.SduiTileOverflowMenu)

local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local useSignalState = SignalsReact.useSignalState
local useUidRefString = SduiCoreSystem.useUidRefString

local function InteractableTileWrapperMenu(props)
	local isHovered = useSignalState(props.getIsHovered)
	local isSelected = useSignalState(props.getIsSelected)

	return React.createElement(SduiTileOverflowMenu, {
		componentConfig = props.componentConfig,
		debugName = "SduiInteractableTileWrapper.OverflowMenu",
		isHovered = isHovered,
		isSelected = isSelected,
		menuKey = props.menuKey,
		parentRef = props.parentRef,
		sduiContext = props.sduiContext,
		zIndex = 5
	})
end

local function useTileMenu(sduiContext)
	local formatted = `sdui-interactable-tile-wrapper-{useUidRefString().current}`
	local ref = React.useRef(nil)

	local v = React.useMemo(function()
		local signal, setIsHovered = Signals.createSignal(false)
		local signal2, setIsSelected = Signals.createSignal(false)
		return {
			getIsHovered = signal,
			setIsHovered = setIsHovered,
			getIsSelected = signal2,
			setIsSelected = setIsSelected
		}
	end, {})

	local triggerFeedback = sduiContext.dependencies.triggerFeedback
	local appPage = sduiContext.appPage

	return React.useMemo(function()
		return {
			menuKey = formatted,
			tileRef = ref,
			getIsHovered = v.getIsHovered,
			getIsSelected = v.getIsSelected,
			tileHandlers = {
				setGuiObject = function(current)
					ref.current = current
				end,
				onMouseEnter = function()
					v.setIsHovered(true)
				end,
				onMouseLeave = function()
					v.setIsHovered(false)
				end,
				onSelectionGained = function()
					v.setIsSelected(true)
				end,
				onSelectionLost = function()
					v.setIsSelected(false)
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
	end, { formatted, v, triggerFeedback, appPage })
end

local function SduiInteractableTileWrapper(data)
	local v = useTileMenu(data.sduiContext)

	local overflowMenuComponent = data.overflowMenuComponent
	local sduiContext = data.sduiContext
	local thumbnailOverflowMenuComponent = React.useMemo(function()
		if overflowMenuComponent then
			return (React.createElement(InteractableTileWrapperMenu, {
				sduiContext = sduiContext,
				componentConfig = overflowMenuComponent,
				menuKey = v.menuKey,
				parentRef = v.tileRef,
				getIsHovered = v.getIsHovered,
				getIsSelected = v.getIsSelected
			}))
		end

		return nil
	end, { overflowMenuComponent, sduiContext, v })

	local tileComponent = data.tileComponent

	if not tileComponent then
		return nil
	end

	local joined = {
		size = data.size,
		layoutOrder = data.layoutOrder,
		selectionOrder = data.selectionOrder
	}

	if thumbnailOverflowMenuComponent then
		joined = Cryo.Dictionary.join(joined, v.tileHandlers, {
			thumbnailOverflowMenuComponent = thumbnailOverflowMenuComponent
		})
	end

	return React.cloneElement(tileComponent, {
		parentAnalyticsContext = data.analyticsContext,
		extraLocalProps = joined
	})
end

return React.memo(SduiInteractableTileWrapper)
