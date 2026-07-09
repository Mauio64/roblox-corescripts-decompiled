local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local VRService = game:GetService("VRService")
local React = require(NotApprovedPageParent.React)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef
local useState = React.useState
local Foundation = require(NotApprovedPageParent.Foundation)
local Button = Foundation.Button
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local OverlayProvider = Foundation.OverlayProvider
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local Popover = Foundation.Popover
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local FocusNavigationUtils = require(NotApprovedPageParent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot
local getVRSurfaceGui = require(NotApprovedPage.Utils.getVRSurfaceGui)
local InputHandlers = require(NotApprovedPageParent.InputHandlers)

require(NotApprovedPageParent.ReactFocusNavigation)

local useLogout = require(NotApprovedPage.Utils.useLogout)
local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext

local function HeaderPopoverMenu(t1: {[any]: any}) -- line: 53
	-- upvalues: useTokens (copy), useNotApprovedPageContext (copy), useState (copy), useLogout (copy), useRef (copy), VRService (copy), getVRSurfaceGui (copy), useMemo (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), useAppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), useCallback (copy), useEffect (copy), React (copy), OverlayProvider (copy), Popover (copy), IconButton (copy), IconName (copy), ButtonVariant (copy), ButtonSize (copy), PopoverSide (copy), PopoverAlign (copy), EnumsRadius (copy), View (copy), Button (copy)
	local v33 = useTokens()
	local translations = useNotApprovedPageContext().translations
	local v35, v36 = useState(false)
	local v37, v38 = useState(false)
	local v39 = useLogout(v36, t1.LogoutThunk)
	local v40 = useRef(nil)
	local v41 = if not VRService.VREnabled then nil else getVRSurfaceGui()
	local v42 = useMemo(function() -- line: 65
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v38 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p1) -- line: 68
					-- upvalues: v38 (copy)
					p1.cancelled = true
					v38(false)
				end)
			}
		}
	end, { v38 })
	local v43 = useAppFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isFocusable = v37,
		customEventHandlers = v42
	})
	local v44 = useCallback(function(p2) -- line: 88
		-- upvalues: v40 (copy), v43 (copy)
		v40.current = p2

		if type(v43) == "function" then
			v43(p2)
		end
	end, { v43 })

	useEffect(function() -- line: 96
		-- upvalues: v40 (copy)
		if v40 and v40.current then
			v40.current.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			v40.current.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
			v40.current.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
			v40.current.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			v40.current.SelectionGroup = true
		end
	end, { v37 })

	local v45 = useCallback(function() -- line: 106
		-- upvalues: v38 (copy)
		v38(function(p3) -- line: 107
			return not p3
		end)
	end, {})
	local v46 = useCallback(function() -- line: 112
		-- upvalues: v38 (copy)
		v38(false)
	end, {})
	local v47 = useCallback(function() -- line: 116
		-- upvalues: v46 (copy), v39 (copy)
		v46()
		v39()
	end, {
		v39,
		v46
	})

	return React.createElement(OverlayProvider, {
		gui = v41
	}, {
		PopoverMenu = React.createElement(Popover.Root, {
			isOpen = v37
		}, {
			Anchor = React.createElement(Popover.Anchor, nil, {
				MenuButton = React.createElement(IconButton, {
					testId = "header-menu-button",
					icon = IconName.ThreeDotsVertical,
					variant = ButtonVariant.Utility,
					onActivated = v45,
					size = ButtonSize.Medium
				})
			}),
			Content = React.createElement(Popover.Content, {
				hasArrow = false,
				side = {
					position = PopoverSide.Bottom,
					offset = v33.Padding.Small
				},
				align = PopoverAlign.End,
				backgroundStyle = v33.Color.Surface.Surface_100,
				radius = EnumsRadius.Medium,
				onPressedOutside = v46
			}, {
				MenuContent = React.createElement(View, {
					tag = "auto-xy radius-medium bg-surface-100 stroke-standard stroke-default padding-small",
					ref = v44
				}, {
					LogoutButton = React.createElement(Button, {
						text = translations.logoutButton,
						onActivated = v47,
						isDisabled = v35,
						isLoading = v35,
						variant = ButtonVariant.Utility,
						size = ButtonSize.Small
					})
				})
			})
		})
	})
end

return React.memo(HeaderPopoverMenu)
