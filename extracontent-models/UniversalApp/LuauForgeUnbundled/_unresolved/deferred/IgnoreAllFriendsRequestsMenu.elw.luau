local CoreGui = game:GetService("CoreGui")

local module = require("@luauforge/deferred/eil")
local useIsSpatial = require("@luauforge/deferred/elx").useIsSpatial
local module2 = require("@luauforge/deferred/eiR")
local focusNavigableSurfaceIdentifierEnum = module2.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = module2.FocusNavigationEventNameEnum
local useFocusRoot = module2.useFocusRoot
local module3 = require("@luauforge/deferred/eiV")
require("@luauforge/deferred/eiS")

local module4 = require("@luauforge/deferred/eiT")
local images = module4.App.ImageSet.Images
local baseMenu = module4.App.Menu.BaseMenu

local module5 = require("@luauforge/deferred/eiU")
local menu = module5.Menu
local overlayProvider = module5.OverlayProvider
local inputSize = module5.Enums.InputSize
local popoverSide = module5.Enums.PopoverSide
local popoverAlign = module5.Enums.PopoverAlign

local useLocalization = require("@luauforge/deferred/ejG").Hooks.useLocalization
local useDispatch = require("@luauforge/deferred/eiP").Hooks.RoactRodux.useDispatch
local module6 = require("@luauforge/deferred/ely")
local useDesignTokens = require("@luauforge/deferred/eip").useDesignTokens

local module7 = require("@luauforge/deferred/eiD")
local module8 = require("@luauforge/deferred/eiu")
local eventNames = module8.EventNames
local namespaces = module8.Namespaces

local module9 = require("@luauforge/deferred/eiz")
local fFlagAddFriendsPageTrustedFriendRequestSection = module9.FFlagAddFriendsPageTrustedFriendRequestSection
local module10 = require("@luauforge/deferred/elz")
local fFlagAddFriendsIgnoreAllMenuFocusNavigation = module9.FFlagAddFriendsIgnoreAllMenuFocusNavigation

local module11 = require("@luauforge/deferred/eiI")
local friendsRequestsStore = require("@luauforge/deferred/elA").FriendsRequestsStore
local v5

if fFlagAddFriendsPageTrustedFriendRequestSection then
	v5 = module11.TrustedConnections.TrustedConnectionsStore.get()
else
	v5 = nil
end

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function getVROverlaySurfaceGui()
	local luaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")

	if luaAppScreenGui then
		return luaAppScreenGui:FindFirstChild("MainAppScreen_SurfaceGui")
	end

	return nil
end

local function IgnoreAllFriendsRequestsMenu(props)
	local open = props.open
	local width = props.width or UDim.new(0, 300)
	local openPositionY = props.openPositionY or UDim.new(0, 0)
	local closeMenu = props.closeMenu

	local v6 = if module10 then useIsSpatial() else false
	local v7 = module.useMemo(function()
		if not v6 then
			return nil
		end

		local luaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")

		if luaAppScreenGui then
			return (luaAppScreenGui:FindFirstChild("MainAppScreen_SurfaceGui"))
		end

		return nil
	end, { v6 })

	local v8 = useDispatch()
	local v9 = useLocalization({
		ignoreAllLabel = "Feature.AddFriends.Action.IgnoreAllAltCase"
	})

	local v10 = useDesignTokens()

	local v11 = module7()
	local v12

	if fFlagAddFriendsIgnoreAllMenuFocusNavigation then
		local v13 = module.useMemo(function()
			local v14 = {}
			v14[focusNavigationEventNameEnum.NavigateBack] = {
				handler = module3.onRelease(function(object)
					closeMenu()
					object:cancel()
				end)
			}

			return v14
		end, { closeMenu })

		v12 = useFocusRoot({
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
			isFocusable = open,
			isAutoFocusRoot = true,
			eventMap = navigateBacks,
			eventHandlers = v13
		})
	end

	local v13 = module.useCallback(function(p2)
		if not p2 then
			return
		end

		v8(module6.Actions.SetCurrentToastMessage({
			toastMessage = p2.toastTitle,
			toastIcon = p2.iconImage
		}))
	end, { v8 })

	local v14 = module.useCallback(function()
		local ignoreAllBtnClick = eventNames.IgnoreAllBtnClick
		local v17 = if fFlagAddFriendsPageTrustedFriendRequestSection then namespaces.FriendRequests else nil
		v11(ignoreAllBtnClick, { namespace = v17 })

		return friendsRequestsStore.get().declineAllFriendRequests():andThen(function(p2)
			v13({
				toastTitle = p2 and p2.backgrounded and "Feature.AddFriends.Label.DeclineAllBackgrounded" or "Feature.Profile.Action.AllRequestsIgnored",
				iconImage = images["icons/actions/reject"]
			})
		end)
	end, { v11 })
	local v15

	if fFlagAddFriendsPageTrustedFriendRequestSection then
		v15 = module.useCallback(function()
			v11(eventNames.IgnoreAllBtnClick, {
				namespace = namespaces.TrustedFriendRequests
			})

			return v5.ignoreAllTrustedFriendRequests():andThen(function()
				v13({
					toastTitle = "Feature.Profile.Action.AllRequestsIgnored",
					iconImage = images["icons/actions/reject"]
				})
			end)
		end, { v11, v13 })
	else
		v15 = nil
	end

	local useCallback = module.useCallback
	local function fn()
		if fFlagAddFriendsPageTrustedFriendRequestSection then
			if props.isTrustedFriendRequest then
				v15()
			else
				v14()
			end
		else
			v14()
		end

		closeMenu()
	end

	local v17 = if fFlagAddFriendsPageTrustedFriendRequestSection then props.isTrustedFriendRequest else nil
	local v18 = useCallback(fn, { v14, v15, v17, closeMenu })

	if not props.anchorRef then
		return open
			and module.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					ZIndex = 5
				},
				{
					IgnoreAllMenuFrame = module.createElement(
						"Frame",
						{
							Size = UDim2.new(1, 0, 0, v10.Size.Size_1200),
							BackgroundTransparency = 1,
							LayoutOrder = 2
						},
						{
							IgnoreAllFriendsRequestsMenu = module.createElement(baseMenu, {
								width = width,
								buttonProps = {
									{ text = v9.ignoreAllLabel, onActivated = v18 }
								},
								anchorPoint = Vector2.new(1, 0),
								position = UDim2.new(UDim.new(1, 0), openPositionY)
							})
						}
					)
				}
			)
			or nil
	end

	local v19

	if not open then
		return v19
	end

	local createElement = module.createElement

	local createElement2 = module.createElement
	local v24 = {
		isOpen = open,
		anchorRef = props.anchorRef,
		width = width,
		size = inputSize.Medium,
		side = popoverSide.Bottom,
		align = popoverAlign.End,
		onPressedOutside = closeMenu,
		ref = 0,
		items = 0
	}

	if not fFlagAddFriendsIgnoreAllMenuFocusNavigation then
		v12 = nil
	end

	v24.ref = v12
	v24.items = {
		{ id = "ignoreAll", text = v9.ignoreAllLabel, onActivated = v18 }
	}
	v19 = createElement(overlayProvider, v7 and { gui = v7 } or { DisplayOrder = 11 }, {
			IgnoreAllFriendsRequestsMenu = createElement2(menu, v24)
		})
		or nil

	return v19
end

return IgnoreAllFriendsRequestsMenu
