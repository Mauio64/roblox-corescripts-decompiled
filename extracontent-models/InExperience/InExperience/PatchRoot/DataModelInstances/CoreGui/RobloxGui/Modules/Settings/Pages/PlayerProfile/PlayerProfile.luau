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
local FoundationText = Foundation.Text
local View = Foundation.View
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local useDeviceOrientation = require(CorePackages.Workspace.Packages.RobloxAppHooks).useDeviceOrientation
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useBreakpointXOrLarger = Responsive.useBreakpointXOrLarger
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local PeopleService = require(CorePackages.Workspace.Packages.PeopleService)
local Enums = require(CorePackages.Workspace.Packages.ProfilePlatform.Enums)
local CurrentlyWearing = require(CorePackages.Workspace.Packages.ProfilePlatform.CurrentlyWearing)
local getProfilePlatform = require(CorePackages.Workspace.Packages.ProfilePlatform.getProfilePlatform)
local useDynamicSizeMargin = require(CorePackages.Workspace.Packages.ProfilePlatform.useDynamicSizeMargin)
local ProfileWrapperContext = require(CorePackages.Workspace.Packages.ProfilePlatform.ProfileWrapperContext)
local AddConnectionButton = require(script.Parent.AddConnectionButton)
local ProfileHeader = require(script.Parent.ProfileHeader)

return React.memo(function(t1: {[any]: any}) -- line: 41
	-- upvalues: useTokens (copy), React (copy), ProfileWrapperContext (copy), PeopleService (copy), Players (copy), SignalsReact (copy), useDeviceOrientation (copy), useBreakpointXOrLarger (copy), Responsive (copy), RobloxAppEnums (copy), useDynamicSizeMargin (copy), useDispatch (copy), getProfilePlatform (copy), Enums (copy), View (copy), IconButton (copy), IconName (copy), FoundationText (copy), ScrollView (copy), Visibility (copy), ProfileHeader (copy), AddConnectionButton (copy), CurrentlyWearing (copy)
	local v27 = useTokens()
	local v28 = React.useContext(ProfileWrapperContext)
	local profileId = v28.profileId
	local profileType = v28.profileType
	local v31 = React.useMemo(function() -- line: 48
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("FriendStatusStore")
	end, {})
	local v32 = React.useMemo(function() -- line: 52
		-- upvalues: t1 (copy), Players (copy)
		if t1.userId then
			return (Players:GetPlayerByUserId(t1.userId))
		end

		return nil
	end, { t1.userId })
	local v33 = SignalsReact.useSignalState(v31.getShouldShowFriendButton(t1.userId, v32))
	local v34 = useDeviceOrientation()
	local v35 = useBreakpointXOrLarger(Responsive.Keys.Medium)
	local v36 = v34 == RobloxAppEnums.DeviceOrientationMode.Portrait and not v35
	local v37, v38 = useDynamicSizeMargin()
	local v39, v40 = React.useState(true)
	local v41, v42 = React.useState(false)
	local v43 = useDispatch()

	React.useEffect(function() -- line: 71
		-- upvalues: v43 (copy), getProfilePlatform (copy), profileId (copy), profileType (copy), Enums (copy), v40 (copy), v42 (copy)
		v43(getProfilePlatform.API({
			includeComponentOrdering = false,
			onlyEssentialComponents = true,
			profileId = profileId,
			profileType = profileType,
			components = {
				{
					component = Enums.Components.CurrentlyWearing
				},
				{
					component = Enums.Components.UserProfileHeader
				}
			}
		})):andThen(function(_) -- line: 86
			-- upvalues: v40 (copy), v42 (copy)
			v40(false)
			v42(false)
		end):catch(function(_) -- line: 90
			-- upvalues: v40 (copy), v42 (copy)
			v40(false)
			v42(true)
		end)
	end, {
		profileId,
		profileType
	})

	if v39 then
		return nil
	end

	if v41 then
		return React.createElement(View, {
			tag = "size-full col"
		}, {
			BackBar = React.createElement(View, {
				tag = "size-full-0 auto-y row padding-xsmall",
				LayoutOrder = 1
			}, {
				BackButton = React.createElement(IconButton, {
					icon = IconName.ChevronLargeLeft,
					onActivated = t1.closePage
				})
			}),
			ErrorMessage = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y content-default text-title-medium",
				Text = "Error loading profile",
				LayoutOrder = 2
			})
		})
	end

	return React.createElement(View, {
		tag = "size-full padding-bottom-medium",
		onAbsoluteSizeChanged = v38
	}, {
		BackBar = React.createElement(View, {
			tag = "size-full-0 auto-y row padding-xsmall",
			LayoutOrder = 1
		}, {
			BackButton = React.createElement(IconButton, {
				icon = IconName.ChevronLargeLeft,
				onActivated = t1.closePage
			})
		}),
		ScrollView = React.createElement(ScrollView, {
			tag = "size-full",
			LayoutOrder = 2,
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
				Padding = UDim.new(0, v27.Padding.XXLarge)
			},
			padding = {
				top = UDim.new(0, 48)
			}
		}, {
			ProfileHeaderContainer = React.createElement(View, {
				LayoutOrder = 1,
				tag = {
					["size-full-0 auto-y"] = true,
					["col gap-xxlarge"] = v36
				}
			}, {
				ProfileHeader = React.createElement(ProfileHeader, {
					layoutOrder = 1,
					profileId = profileId
				}),
				AddConnectionButtonContainer = if not v33 then nil else React.createElement(View, {
					ZIndex = 2,
					LayoutOrder = 2,
					tag = {
						["size-full-0 auto-y"] = v36,
						["size-2500-2200 row align-y-center"] = not v36 and not v35,
						["size-3000-2200 row align-y-center"] = not v36 and v35
					},
					padding = if not v36 then nil else {
						left = UDim.new(0, v37),
						right = UDim.new(0, v37)
					},
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -v37, 0, 0)
				}, {
					AddConnectionButton = React.createElement(AddConnectionButton, {
						userId = t1.userId
					})
				})
			}),
			CurrentlyWearingCarousel = React.createElement(CurrentlyWearing, {
				layoutOrder = 3
			})
		})
	})
end)
