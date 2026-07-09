local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local PeekView = require(ProfilePlatformParent.PeekView)
local PeekView2 = PeekView.PeekView
local PeekViewState = PeekView.PeekViewState
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local View = require(ProfilePlatformParent.Foundation).View
local useStyle = require(ProfilePlatformParent.UIBlox).Core.Style.useStyle
local Enums = require(ProfilePlatform.Common.Enums)
local FFlagProfilePlatformNewProfileHeader = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformNewProfileHeader
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local v13 = not FFlagProfilePlatformNewProfileHeader and 25 or 0

local function ProfilePeekView(t1: {[any]: any}) -- line: 39
	-- upvalues: useSelector (copy), FFlagProfilePlatformNewProfileHeader (copy), useStyle (copy), React (copy), PeekViewState (copy), v13 (copy), View (copy), PeekView2 (copy), Enums (copy)
	local v16 = t1.statusBarHeight or useSelector(function(p1) -- line: 41
		return p1.TopBar.statusBarHeight
	end)
	local v17 = if not FFlagProfilePlatformNewProfileHeader then nil else useStyle()
	local v18 = React.useCallback(function(p2, p3, p4) -- line: 46
		-- upvalues: PeekViewState (copy), t1 (copy)
		if p2 == PeekViewState.Closed and t1.onClosed then
			t1.onClosed()
		end

		if t1.onViewStateChanged then
			t1.onViewStateChanged(p2, p3, p4)
		end
	end, {
		t1.onClosed,
		t1.onViewStateChanged
	})
	local v19, v20 = React.useBinding(0)
	local v21 = if not FFlagProfilePlatformNewProfileHeader then UDim2.new(1, 0, 1, -v16 + v13) else UDim2.new(1, 0, 1, -v16)
	local v22 = if not FFlagProfilePlatformNewProfileHeader then UDim2.new(0, 0, 0, v16 - v13) else UDim2.new(0, 0, 0, v16)

	return React.createElement(View, {
		tag = "position-top-left",
		Size = UDim2.new(t1.viewWidth or UDim.new(1, 0), UDim.new(1, 0))
	}, {
		StatusBarSpace = if not FFlagProfilePlatformNewProfileHeader then React.createElement(View, {
			tag = "position-top-left bg-surface-0",
			BorderSizePixel = 0,
			ZIndex = 999,
			Size = UDim2.new(1, 0, 0, v16)
		}) else nil,
		ProfileContent = React.createElement(View, {
			Size = v21,
			Position = v22
		}, {
			PeekView = React.createElement(PeekView2, {
				hasScrim = true,
				fullViewContentHeight = t1.fullViewContentHeight,
				briefViewContentHeight = if not t1.briefViewContentHeight then UDim.new(0.5, 0) else t1.briefViewContentHeight,
				bottomDockedContainerHeight = t1.bottomDockedContainerHeight,
				bottomDockedContainerContent = {
					PeekViewBottomBar = t1.bottomBarSlot
				},
				mountAsFullView = t1.mountAsFullView,
				mountAnimation = t1.mountAnimation,
				viewStateChanged = v18,
				briefToFullTransitionPercent = function(p5) -- line: 59
					-- upvalues: v20 (copy), t1 (copy)
					v20(p5)

					if t1.transitionPercentCallback then
						t1.transitionPercentCallback(p5)
					end
				end,
				hasSolidDragger = (not FFlagProfilePlatformNewProfileHeader or t1.profileType ~= Enums.ProfileTypes.User) and nil
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					Padding = UDim.new(0, 0),
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Top
				}),
				Content = t1.contentSlot
			})
		}),
		PeekViewTopBar = if not FFlagProfilePlatformNewProfileHeader then nil else React.createElement("CanvasGroup", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 1000,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, v16 + 56),
			GroupTransparency = v19:map(function(p6) -- line: 124
				return 1 - p6
			end)
		}, {
			StatusBarBackground = React.createElement("Frame", {
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, v16),
				BackgroundColor3 = v17.Theme.BackgroundDefault.Color
			}),
			TopBarSlotContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0, v16),
				Size = UDim2.new(1, 0, 0, 56)
			}, {
				TopBar = t1.topBarSlot
			})
		}),
		TransparentTopBarOverlay = if not FFlagProfilePlatformNewProfileHeader then React.createElement("CanvasGroup", {
			BackgroundTransparency = 1,
			ZIndex = 1000,
			Size = UDim2.new(1, 0, 0, 56),
			Position = UDim2.new(0, 0, 0, v16),
			GroupTransparency = v19:map(function(p7) -- line: 153
				return 1 - p7
			end)
		}, {
			TopBar = t1.topBarSlot
		}) else nil
	})
end

return ProfilePeekView
