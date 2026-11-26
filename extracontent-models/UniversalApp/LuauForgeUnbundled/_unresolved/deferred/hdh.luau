local module = require("@luauforge/deferred/hcS")
local module2 = require("@luauforge/deferred/hcT")
local module3 = require("@luauforge/deferred/hdi")
local module4 = require("@luauforge/deferred/hdj")
require("@luauforge/deferred/hdk")
local backHandlerRegistry = require("@luauforge/deferred/hdl").BackHandlerRegistry

local fFlagAXFixBackgroundGenerationResultMenuNavigation = require("@luauforge/deferred/hcQ").FFlagAXFixBackgroundGenerationResultMenuNavigation

local buttonVariant = module2.Enums.ButtonVariant
local iconName = module2.Enums.IconName
local inputSize = module2.Enums.InputSize
local popoverAlign = module2.Enums.PopoverAlign
local popoverSide = module2.Enums.PopoverSide
local focusNavigableSurfaceIdentifierEnum = module3.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = module3.FocusNavigationEventNameEnum
local useAppFocusRoot = module3.useAppFocusRoot

local function forwardRefValue(callback, current)
	if type(callback) == "function" then
		callback(current)
	elseif type(callback) == "table" then
		callback.current = current
	end
end

local function GenerationResultMenu(props)
	local state, setState = module.useState(props.initiallyOpen == true)
	local publishLabel = props.publishLabel
	local deleteLabel = props.deleteLabel
	local onPublish = props.onPublish
	local onDelete = props.onDelete

	local v5 = module.useCallback(function()
		setState(function(p2): boolean
			return not p2
		end)
	end, {})

	local v6 = module.useCallback(function()
		setState(false)
	end, {})

	local isDisabled = props.isDisabled == true
	local v7

	if fFlagAXFixBackgroundGenerationResultMenuNavigation then
		v7 = module.useMemo(function()
			local v8 = {}
			v8[focusNavigationEventNameEnum.NavigateBack] = {
				handler = module4.onRelease(function(object)
					object:cancel()
					v6()
				end)
			}

			return v8
		end, { v6 })
	end

	local v8

	if fFlagAXFixBackgroundGenerationResultMenuNavigation then
		v8 = useAppFocusRoot({
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ContextualMenu,
			customEventHandlers = v7,
			isFocusable = state and not isDisabled and props.isVisible ~= false
		})
	else
		v8 = nil
	end

	local ref = module.useRef(nil)
	local ref2 = module.useRef(nil)
	local v9

	if fFlagAXFixBackgroundGenerationResultMenuNavigation then
		v9 = module.useCallback(function(current)
			ref2.current = current
			local v10 = v8

			if type(v10) == "function" then
				v10(current)
			elseif type(v10) == "table" then
				v10.current = current
			end
		end, { v8 })
	end

	if fFlagAXFixBackgroundGenerationResultMenuNavigation then
		module.useLayoutEffect(function()
			if state then
				return backHandlerRegistry.register(v6)
			end

			return nil
		end, { v6, state })

		module.useEffect(function()
			local current = ref2.current

			if current then
				current.SelectionGroup = true
				current.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
				current.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
				current.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
				current.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			end
		end, { state })

		module.useEffect(function()
			if props.isVisible == false then
				v6()
			end
		end, { v6, props.isVisible })
	end

	local v10 = module.useMemo(function()
		return {
			{
				items = {
					{ id = "publish", text = publishLabel, isDisabled = isDisabled }
				}
			},
			{
				items = {
					{ id = "delete", text = deleteLabel, isDisabled = isDisabled }
				}
			}
		}
	end, { deleteLabel, isDisabled, publishLabel })

	local v11 = module.useCallback(function(p2)
		v6()

		if p2 == "publish" then
			onPublish()
		elseif p2 == "delete" then
			onDelete()
		end
	end, { v6, onDelete, onPublish })

	local element = module.createElement(module2.IconButton, {
		icon = iconName.ThreeDotsHorizontal,
		isCircular = true,
		onActivated = v5,
		size = inputSize.Medium,
		variant = buttonVariant.OverMedia,
		testId = "generation-result-menu-button",
		ref = if fFlagAXFixBackgroundGenerationResultMenuNavigation then ref else nil
	})

	if fFlagAXFixBackgroundGenerationResultMenuNavigation then
		return module.createElement(
			module2.View,
			{ tag = "align-y-center auto-xy", LayoutOrder = props.LayoutOrder },
			{
				Trigger = element,
				Menu = module.createElement(module2.Menu, {
					align = popoverAlign.End,
					anchorRef = ref,
					isOpen = state and props.isVisible ~= false,
					items = v10,
					onActivated = v11,
					onPressedOutside = v6,
					ref = v9,
					side = popoverSide.Bottom,
					testId = "generation-result-menu"
				})
			}
		)
	end

	return module.createElement(module2.Menu, {
		align = popoverAlign.End,
		isOpen = state,
		items = v10,
		LayoutOrder = props.LayoutOrder,
		onActivated = v11,
		onPressedOutside = v6,
		side = popoverSide.Bottom,
		testId = "generation-result-menu"
	}, { Trigger = element })
end

return module.memo(GenerationResultMenu)
