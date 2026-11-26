local VRService = game:GetService("VRService")

local module = require("@luauforge/deferred/gzS")
local useCallback = module.useCallback
local useEffect = module.useEffect
local useMemo = module.useMemo
local useRef = module.useRef
local useState = module.useState

local module2 = require("@luauforge/deferred/gzT")
local button = module2.Button
local buttonSize = module2.Enums.ButtonSize
local buttonVariant = module2.Enums.ButtonVariant
local iconButton = module2.IconButton
local iconName = module2.Enums.IconName
local overlayProvider = module2.OverlayProvider
local popoverSide = module2.Enums.PopoverSide
local popoverAlign = module2.Enums.PopoverAlign
local popover = module2.Popover
local radius = module2.Enums.Radius
local useTokens = module2.Hooks.useTokens
local view = module2.View

local module3 = require("@luauforge/deferred/gAR")
local focusNavigableSurfaceIdentifierEnum = module3.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = module3.FocusNavigationEventNameEnum
local useAppFocusRoot = module3.useAppFocusRoot

local module4 = require("@luauforge/deferred/gAT")
local module5 = require("@luauforge/deferred/gAV")
require("@luauforge/deferred/gAS")
local module6 = require("@luauforge/deferred/gBp")
local useNotApprovedPageContext = require("@luauforge/deferred/gAo").useNotApprovedPageContext

local function HeaderPopoverMenu(p2)
	local v5 = useTokens()
	local translations = useNotApprovedPageContext().translations

	local state, setState = useState(false)
	local state2, setState2 = useState(false)
	local v6 = module6(setState, p2.LogoutThunk)

	local v7 = useRef(nil)
	local v8 = if VRService.VREnabled then module4() else nil

	local v9 = useMemo(function()
		local v10 = {}
		v10[focusNavigationEventNameEnum.NavigateBack] = {
			handler = module5.onRelease(function(p3)
				p3.cancelled = true
				setState2(false)
			end)
		}

		return v10
	end, { setState2 })

	local v10 = useAppFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isFocusable = state2,
		customEventHandlers = v9
	})

	local v11 = useCallback(function(current)
		v7.current = current

		if type(v10) == "function" then
			v10(current)
		end
	end, { v10 })

	useEffect(function()
		if v7 and v7.current then
			v7.current.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			v7.current.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
			v7.current.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
			v7.current.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			v7.current.SelectionGroup = true
		end
	end, { state2 })

	local v12 = useCallback(function()
		setState2(function(p3): boolean
			return not p3
		end)
	end, {})

	local v13 = useCallback(function()
		setState2(false)
	end, {})

	local v14 = useCallback(function()
		v13()
		v6()
	end, { v6, v13 })

	return module.createElement(overlayProvider, { gui = v8 }, {
		PopoverMenu = module.createElement(popover.Root, { isOpen = state2 }, {
			Anchor = module.createElement(popover.Anchor, nil, {
				MenuButton = module.createElement(iconButton, {
					icon = iconName.ThreeDotsVertical,
					variant = buttonVariant.Utility,
					onActivated = v12,
					size = buttonSize.Medium,
					testId = "header-menu-button"
				})
			}),
			Content = module.createElement(popover.Content, {
				side = { position = popoverSide.Bottom, offset = v5.Padding.Small },
				align = popoverAlign.End,
				backgroundStyle = v5.Color.Surface.Surface_100,
				radius = radius.Medium,
				hasArrow = false,
				onPressedOutside = v13
			}, {
				MenuContent = module.createElement(
					view,
					{
						tag = "auto-xy radius-medium bg-surface-100 stroke-standard stroke-default padding-small",
						ref = v11
					},
					{
						LogoutButton = module.createElement(button, {
							text = translations.logoutButton,
							onActivated = v14,
							isDisabled = state,
							isLoading = state,
							variant = buttonVariant.Utility,
							size = buttonSize.Small
						})
					}
				)
			})
		})
	})
end

return module.memo(HeaderPopoverMenu)
