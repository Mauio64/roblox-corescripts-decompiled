local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local IconName = Foundation.Enums.IconName
local Visibility = Foundation.Enums.Visibility
local IconButton = Foundation.IconButton
local ScrollView = Foundation.ScrollView
local Text = Foundation.Text
local View = Foundation.View

local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation

local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useBreakpointXOrLarger = Responsive.useBreakpointXOrLarger

local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local PeopleService = require(CorePackages.Workspace.Packages.PeopleService)
local Enums = require(CorePackages.Workspace.Packages.ProfilePlatform.Enums)
local CurrentlyWearing = require(CorePackages.Workspace.Packages.ProfilePlatform.CurrentlyWearing)
local getProfilePlatform = require(CorePackages.Workspace.Packages.ProfilePlatform.getProfilePlatform)
local useDynamicSizeMargin = require(CorePackages.Workspace.Packages.ProfilePlatform.useDynamicSizeMargin)
local ProfileWrapperContext = require(CorePackages.Workspace.Packages.ProfilePlatform.ProfileWrapperContext)

local FFlagProfilePlatformGracefulVisibility = require(CorePackages.Workspace.Packages.ProfilePlatform.FFlagProfilePlatformGracefulVisibility)

local AddConnectionButton = require(script.Parent.AddConnectionButton)
local ProfileHeader = require(script.Parent.ProfileHeader)

return React.memo(function(p)
	local v = useTokens()

	local v2 = React.useContext(ProfileWrapperContext)
	local profileId = v2.profileId
	local profileType = v2.profileType

	local v3 = React.useMemo(function()
		return PeopleService.getService("FriendStatusStore")
	end, {})

	local v4 = React.useMemo(function()
		if p.userId then
			return (Players:GetPlayerByUserId(p.userId))
		end

		return nil
	end, { p.userId })

	local v5 = SignalsReact.useSignalState(v3.getShouldShowFriendButton(p.userId, v4))

	local v6 = useDeviceOrientation()
	local v7 = useBreakpointXOrLarger(Responsive.Keys.Medium)
	local v8 = v6 == RobloxAppEnums.DeviceOrientationMode.Portrait and not v7

	local v9, onAbsoluteSizeChanged = useDynamicSizeMargin()

	local state, setState = React.useState(true)
	local state2, setState2 = React.useState(false)

	local v10 = useDispatch()

	React.useEffect(function()
		local components = {
			{ component = Enums.Components.CurrentlyWearing },
			{ component = Enums.Components.UserProfileHeader }
		}

		if FFlagProfilePlatformGracefulVisibility then
			table.insert(components, { component = Enums.Components.Friends })
		end

		v10(getProfilePlatform.API({
			profileId = profileId,
			profileType = profileType,
			components = components,
			includeComponentOrdering = false,
			onlyEssentialComponents = not FFlagProfilePlatformGracefulVisibility or nil
		})):andThen(function(_)
			setState(false)
			setState2(false)
		end):catch(function(_)
			setState(false)
			setState2(true)
		end)
	end, { profileId, profileType })

	if state then
		return nil
	end

	if state2 then
		return React.createElement(View, { tag = "size-full col" }, {
			BackBar = React.createElement(View, {
				tag = "size-full-0 auto-y row padding-xsmall",
				LayoutOrder = 1
			}, {
				BackButton = React.createElement(IconButton, {
					icon = IconName.ChevronLargeLeft,
					onActivated = p.closePage
				})
			}),
			ErrorMessage = React.createElement(Text, {
				tag = "size-full-0 auto-y content-default text-title-medium",
				Text = "Error loading profile",
				LayoutOrder = 2
			})
		})
	end

	local createElement = React.createElement

	local v11 = {
		BackBar = React.createElement(View, {
			tag = "size-full-0 auto-y row padding-xsmall",
			LayoutOrder = 1
		}, {
			BackButton = React.createElement(IconButton, {
				icon = IconName.ChevronLargeLeft,
				onActivated = p.closePage
			})
		}),
		ScrollView = 0
	}

	local createElement2 = React.createElement
	local v12 = {
		tag = "size-full",
		scroll = {
			scrollBarVisibility = Visibility.Auto,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			CanvasSize = UDim2.fromScale(1, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
		},
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v.Padding.XXLarge)
		},
		padding = { top = UDim.new(0, 48) },
		LayoutOrder = 2
	}

	local createElement3 = React.createElement

	local v13 = {
		ProfileHeader = React.createElement(ProfileHeader, {
			profileId = profileId,
			layoutOrder = 1
		}),
		AddConnectionButtonContainer = 0
	}
	local addConnectionButtonContainer

	if v5 then
		addConnectionButtonContainer = React.createElement(View, {
			tag = {
				["size-full-0 auto-y"] = v8,
				["size-2500-2200 row align-y-center"] = not (v8 or v7),
				["size-3000-2200 row align-y-center"] = not v8 and v7
			},
			padding = v8 and { left = UDim.new(0, v9), right = UDim.new(0, v9) } or nil,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -v9, 0, 0),
			ZIndex = 2,
			LayoutOrder = 2
		}, {
			AddConnectionButton = React.createElement(AddConnectionButton, { userId = p.userId })
		})
	end

	v13.AddConnectionButtonContainer = addConnectionButtonContainer
	v11.ScrollView = createElement2(ScrollView, v12, {
		ProfileHeaderContainer = createElement3(View, {
			tag = { ["size-full-0 auto-y"] = true, ["col gap-xxlarge"] = v8 },
			LayoutOrder = 1
		}, v13),
		CurrentlyWearingCarousel = React.createElement(CurrentlyWearing, { layoutOrder = 3 })
	})
	return createElement(
		View,
		{ tag = "size-full padding-bottom-medium", onAbsoluteSizeChanged = onAbsoluteSizeChanged },
		v11
	)
end)
