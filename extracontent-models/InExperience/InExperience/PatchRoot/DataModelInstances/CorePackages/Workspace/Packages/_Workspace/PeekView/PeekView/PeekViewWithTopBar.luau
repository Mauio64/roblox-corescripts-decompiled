local Parent = script:FindFirstAncestor("PeekView").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local useRouteName = require(Parent.Navigation).useRouteName
local AppEventIngestService = require(Parent.RoactServiceTags).AppEventIngestService
local useStyle = require(Parent.UIBlox).Core.Style.useStyle
local PeekView = require(script.Parent.PeekView)
local PeekViewState = require(script.Parent.PeekViewState)
local peekViewDismissedEvent = require(script.Parent.analytics.peekViewDismissedEvent)
local FFlagProfilePlatformNewProfileHeader = require(Parent.SharedFlags).FFlagProfilePlatformNewProfileHeader
local FFlagSduiExperienceDetailsSupport = require(Parent.SharedFlags).FFlagSduiExperienceDetailsSupport

local function PeekViewWithTopBar(t1: {[any]: any}) -- line: 49
	-- upvalues: useRoactService (copy), AppEventIngestService (copy), useRouteName (copy), useStyle (copy), React (copy), PeekViewState (copy), peekViewDismissedEvent (copy), Cryo (copy), PeekView (copy), FFlagProfilePlatformNewProfileHeader (copy), FFlagSduiExperienceDetailsSupport (copy)
	local v15 = useRoactService(AppEventIngestService)
	local v16 = useRouteName()
	local v17 = useStyle()
	local onClosed = t1.onClosed
	local onViewStateChanged = t1.onViewStateChanged
	local v20 = React.useCallback(function(p1, p2, p3) -- line: 56
		-- upvalues: PeekViewState (copy), onClosed (copy), v15 (copy), t1 (copy), peekViewDismissedEvent (copy), Cryo (copy), v16 (copy), onViewStateChanged (copy)
		if p1 == PeekViewState.Closed then
			if onClosed then
				onClosed()
			end

			if p3.dismissMethod and v15 then
				local v26 = t1.viewChangedEventMeta or {}

				peekViewDismissedEvent.logEvent(v15, "PeekView", Cryo.Dictionary.join(v26, p3, {
					page = v16
				}))
			end
		end

		if onViewStateChanged then
			onViewStateChanged(p1, p2)
		end
	end, {
		onClosed,
		onViewStateChanged,
		t1.viewChangedEventMeta,
		v15,
		v16
	})
	local v21, v22 = React.useBinding(0)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(t1.viewWidth or UDim.new(1, 0), UDim.new(1, 0))
	}, {
		PeekViewTopBar = React.createElement("CanvasGroup", {
			Active = false,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ZIndex = 2,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, t1.topBarHeight),
			BackgroundColor3 = v17.Theme.BackgroundDefault.Color,
			BorderColor3 = v17.Tokens.Color.Common.Shimmer.Color3,
			GroupTransparency = v21:map(function(p4) -- line: 102
				return 1 - p4
			end)
		}, {
			PeekViewTopBarInner = t1.topBarSlot
		}),
		PeekViewContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0)
		}, {
			PeekView = React.createElement(PeekView, {
				hasScrim = true,
				fullViewContentHeight = t1.fullViewContentHeight,
				briefViewContentHeight = t1.briefViewContentHeight,
				bottomDockedContainerHeight = t1.bottomDockedContainerHeight,
				bottomDockedContainerContent = {
					PeekViewBottomBar = t1.bottomBarSlot
				},
				mountAsFullView = t1.mountAsFullView,
				mountAnimation = t1.mountAnimation,
				viewStateChanged = v20,
				briefToFullTransitionPercent = function(p5) -- line: 81
					-- upvalues: v22 (copy), t1 (copy)
					v22(p5)

					if t1.transitionPercentCallback then
						t1.transitionPercentCallback(p5)
					end
				end,
				hasSolidDragger = if not FFlagProfilePlatformNewProfileHeader then nil else t1.hasSolidDragger,
				scrollingFrameRef = if not FFlagSduiExperienceDetailsSupport then nil else t1.scrollingFrameRef
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					Padding = UDim.new(0, 0),
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Top
				}),
				Content = t1.contentSlot
			})
		})
	})
end

return PeekViewWithTopBar
