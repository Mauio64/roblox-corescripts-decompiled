local Parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
local View = Foundation.View
local Enums = Foundation.Enums

require(Parent.AvatarExperienceCommon)

local WearTimeOptionButton = require(script.Parent.WearTimeOptionButton)
local AXTooltip = require(Parent.AvatarExperienceUIKit).AXTooltipComponents.AXTooltip

local function WearTimeOptionsCarousel(t1: {[any]: any}) -- line: 27
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), WearTimeOptionButton (copy), View (copy), FoundationText (copy), Foundation (copy), Enums (copy), AXTooltip (copy)
	local v13 = useTokens()
	local v14 = useLocalization({
		wearTimeOptions = "Feature.Durables.ItemDetails.WearTimeOptions.Title",
		tooltipText = "Feature.Durables.FTUX.Tooltip"
	})
	local v15, v16 = React.useState(false)

	React.useEffect(function() -- line: 36
		-- upvalues: v16 (copy)
		local thread = task.delay(5, function() -- line: 37
			-- upvalues: v16 (copy)
			v16(false)
		end)

		return function() -- line: 41
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {})

	local v17, v18 = React.useState(function() -- line: 46
		-- upvalues: t1 (copy)
		for v23, v24 in t1.options do
			if v24.selected then
				return v23
			end
		end

		return 1
	end)
	local v19 = React.useMemo(function() -- line: 57
		-- upvalues: t1 (copy), React (copy), WearTimeOptionButton (copy), v17 (copy), v18 (copy)
		local t2 = {}

		for v26, v27 in t1.options do
			t2[v26] = React.createElement(WearTimeOptionButton, {
				option = {
					days = v27.days,
					price = v27.price,
					selected = v26 == v17
				},
				onActivated = function() -- line: 66
					-- upvalues: v18 (copy), v26 (copy), t1 (copy)
					v18(v26)

					if t1.onOptionActivated then
						t1.onOptionActivated(v26)
					end
				end,
				LayoutOrder = v26
			})
		end

		return t2
	end, {
		t1.options,
		v17,
		t1.onOptionActivated
	})
	local v20 = React.createElement(View, {
		tag = "row gap-medium align-y-center auto-xy"
	}, {
		Options = React.createElement(React.Fragment, nil, v19)
	})
	local v21 = if not t1.useWrapping then React.createElement(View, {
		tag = "size-full-0",
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, v13.Size.Size_1200)
	}, {
		ScrollingFrame = React.createElement("ScrollingFrame", {
			ScrollBarThickness = 0,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ClipsDescendants = false,
			Selectable = false,
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(0, 0, 0, v13.Size.Size_1200),
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			ScrollingDirection = Enum.ScrollingDirection.X,
			ElasticBehavior = Enum.ElasticBehavior.Always
		}, v20)
	}) else React.createElement(View, {
		tag = "row wrap gap-medium align-y-center size-full-0 auto-y",
		LayoutOrder = 2,
		wrap = true
	}, v19)

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-medium",
		LayoutOrder = t1.LayoutOrder
	}, {
		Heading = React.createElement(View, {
			tag = "auto-xy row gap-xxsmall align-y-center",
			LayoutOrder = 1
		}, {
			HeadingText = React.createElement(FoundationText, {
				LayoutOrder = 1,
				Text = v14.wearTimeOptions,
				textStyle = v13.Color.Content.Emphasis,
				fontStyle = {
					Font = v13.Typography.TitleLarge.Font,
					FontSize = v13.FontSize.FontSize_500
				},
				AutomaticSize = Enum.AutomaticSize.XY
			}),
			InfoIconContainer = React.createElement(View, {
				tag = "auto-xy",
				LayoutOrder = 2
			}, {
				InfoIcon = React.createElement(Foundation.IconButton, {
					icon = Enums.IconName.CircleI,
					size = Enums.IconSize.Small,
					onActivated = function() -- line: 144
						-- upvalues: v16 (copy)
						v16(true)
					end
				}),
				Tooltip = React.createElement(AXTooltip, {
					popoverSide = "Top",
					isOpen = v15,
					tooltipText = v14.tooltipText,
					maxWidth = v13.Size.Size_1200 * 3,
					onTooltipActivated = function() -- line: 153
						-- upvalues: v16 (copy)
						v16(false)
					end
				})
			})
		}),
		CarouselContainer = v21
	})
end

return WearTimeOptionsCarousel
