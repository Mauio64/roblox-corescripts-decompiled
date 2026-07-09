local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

require(Parent.AppCommonLib)

local useLocalization = require(Parent.Localization).Hooks.useLocalization
local Cryo = require(Parent.Cryo)
local View = Foundation.View
local Button = Foundation.Button
local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local useAiOverviewExpansion = require(script.Parent.useAiOverviewExpansion)

local function SduiAiOverview(t1: {[any]: any}) -- line: 45
	-- upvalues: useTokens (copy), usePreferences (copy), useLocalization (copy), React (copy), Cryo (copy), useAiOverviewExpansion (copy), View (copy), Button (copy), ButtonSize (copy), ButtonVariant (copy), FillBehavior (copy)
	local v16 = useTokens()
	local v17 = usePreferences()
	local v18 = useLocalization({
		expandButtonText = "CommonUI.Controls.Action.ShowMore"
	})
	local v19 = React.useMemo(function() -- line: 53
		-- upvalues: t1 (copy)
		return {
			index = t1.index,
			scrollViewPositionChangedSignal = t1.scrollViewPositionChangedSignal,
			verticalScrollingFrameRef = t1.verticalScrollingFrameRef,
			startRow = t1.startRow or t1.index
		}
	end, {
		t1.index,
		t1.scrollViewPositionChangedSignal,
		t1.verticalScrollingFrameRef,
		t1.startRow
	})
	local v20 = React.useCallback(function(p1) -- line: 64
		-- upvalues: React (copy), Cryo (copy), v19 (copy)
		if p1 and typeof(p1) == "table" then
			local t2 = {}

			for v32, v33 in p1 do
				local v34 = v33.props and v33.props.extraLocalProps or {}

				t2[v32] = React.cloneElement(v33, {
					extraLocalProps = Cryo.Dictionary.join(v34, v19)
				})
			end

			return t2
		end

		return p1
	end, { v19 })
	local v21 = React.useMemo(function() -- line: 79
		-- upvalues: v20 (copy), t1 (copy)
		return v20(t1.content)
	end, {
		t1.content,
		v20
	})
	local v22 = React.useMemo(function() -- line: 83
		-- upvalues: v20 (copy), t1 (copy)
		return v20(t1.footer)
	end, {
		t1.footer,
		v20
	})
	local Large = v16.Gap.Large
	local v24 = t1.titleComponent ~= nil or t1.descriptionComponent ~= nil
	local v25 = t1.content ~= nil or t1.footer ~= nil
	local v26 = t1.expandButtonText or v18.expandButtonText
	local v27 = t1.backgroundStyle or v16.Color.Surface.Surface_0
	local Size_1000 = v16.Size.Size_1000
	local v29 = useAiOverviewExpansion({
		buttonHeight = Size_1000,
		compactHeight = t1.compactHeight,
		hasHeader = v24,
		hasExpandableBody = v25,
		sectionGap = Large,
		reducedMotion = v17.reducedMotion
	})

	return React.createElement(View, {
		tag = "col gap-large size-full-0 auto-y",
		backgroundStyle = t1.backgroundStyle,
		LayoutOrder = t1.layoutOrder,
		sizeConstraint = if not v29.shouldReserveCompactHeight then nil else {
			MinSize = Vector2.new(0, t1.compactHeight)
		},
		testId = t1.testId or "--sdui-ai-overview"
	}, {
		Header = if not v24 then nil else React.createElement(View, {
			tag = "col gap-large size-full-0 auto-y",
			LayoutOrder = 1,
			onAbsoluteSizeChanged = v29.onHeaderAbsoluteSizeChanged
		}, {
			Title = if not t1.titleComponent then nil else React.createElement(View, {
				tag = "size-full-0 auto-y",
				LayoutOrder = 1,
				testId = "--sdui-ai-overview-title"
			}, {
				Slot = t1.titleComponent
			}),
			Description = if not t1.descriptionComponent then nil else React.createElement(View, {
				tag = "size-full-0 auto-y",
				LayoutOrder = 2,
				testId = "--sdui-ai-overview-description"
			}, {
				Slot = t1.descriptionComponent
			})
		}),
		Body = if not v25 then nil else React.createElement(View, {
			tag = "col size-full-0 auto-y",
			LayoutOrder = 2
		}, {
			Inner = React.createElement(View, {
				tag = {
					clip = v29.useCompactViewport,
					["no-clip"] = not v29.useCompactViewport,
					["auto-none"] = v29.useCompactViewport,
					["auto-y"] = not v29.useCompactViewport
				},
				Size = if not v29.useCompactViewport then UDim2.fromScale(1, 0) else v29.animatedViewportHeight:map(function(n1: number) -- line: 155
					return UDim2.new(1, 0, 0, (math.ceil(n1)))
				end)
			}, {
				Content = React.createElement(View, {
					tag = "col gap-large size-full-0 auto-y",
					onAbsoluteSizeChanged = v29.onContentAbsoluteSizeChanged
				}, {
					Content = if not v21 then nil else React.createElement(View, {
						tag = "col gap-large size-full-0 auto-y",
						LayoutOrder = 3,
						testId = "--sdui-ai-overview-content"
					}, v21),
					Footer = if not v22 then nil else React.createElement(View, {
						tag = "col gap-large size-full-0 auto-y",
						LayoutOrder = 4,
						testId = "--sdui-ai-overview-footer"
					}, v22)
				}),
				FadeOverlay = if not v29.isCompact then nil else React.createElement(View, {
					tag = "position-bottom-left anchor-bottom-left",
					ZIndex = 2,
					backgroundStyle = v27,
					Size = v29.animatedViewportHeight:map(function(n2: number) -- line: 184
						return UDim2.new(1, 0, 0, (math.ceil(n2 * 0.25)))
					end)
				}, {
					Gradient = React.createElement("UIGradient", {
						Rotation = 90,
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 1),
							NumberSequenceKeypoint.new(1, 0)
						})
					})
				})
			})
		}),
		ToggleButtonContainer = if not v29.isCompact then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, Size_1000)
		}, {
			ToggleButton = React.createElement(Button, {
				testId = "--sdui-ai-overview-toggle",
				text = v26,
				size = ButtonSize.Medium,
				variant = ButtonVariant.Standard,
				fillBehavior = FillBehavior.Fill,
				onActivated = v29.onExpand
			})
		})
	})
end

return React.memo(SduiAiOverview)
