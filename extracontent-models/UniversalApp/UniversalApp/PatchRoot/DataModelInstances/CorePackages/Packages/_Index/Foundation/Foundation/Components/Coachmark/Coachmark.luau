local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)
local Button = require(Foundation.Components.Button)
local CloseAffordance = require(Foundation.Components.CloseAffordance)
local CloseAffordanceVariant = require(Foundation.Enums.CloseAffordanceVariant)
local ColorMode = require(Foundation.Enums.ColorMode)
local FillBehavior = require(Foundation.Enums.FillBehavior)
local Flags = require(Foundation.Utility.Flags)
local InputSize = require(Foundation.Enums.InputSize)
local Logger = require(Foundation.Utility.Logger)
local PopoverAlign = require(Foundation.Enums.PopoverAlign)
local PopoverSide = require(Foundation.Enums.PopoverSide)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local Radius = require(Foundation.Enums.Radius)
local Text = require(Foundation.Components.Text)
local Translator = require(Foundation.Utility.Localization.Translator)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useScaledValue = require(Foundation.Utility.useScaledValue)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local Popover = require(Foundation.Components.Popover)
local t1 = {
	isOpen = false,
	testId = "--foundation-coachmark",
	align = PopoverAlign.Start,
	side = PopoverSide.Right
}

local function stepsText(n1: number, n2: number) -- line: 75
	-- upvalues: Translator (copy)
	return Translator:FormatByKey("CommonUI.Controls.Label.PageCount", {
		current = n1,
		total = n2
	})
end
local function Coachmark(p1, p2) -- line: 79
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useScaledValue (copy), React (copy), Logger (copy), InputSize (copy), FillBehavior (copy), Dash (copy), Button (copy), Popover (copy), withCommonProps (copy), Flags (copy), Radius (copy), PresentationContext (copy), ColorMode (copy), View (copy), CloseAffordance (copy), CloseAffordanceVariant (copy), Text (copy), Translator (copy)
	local v32 = withDefaults(p1, t1)
	local v33 = useTokens()
	local v34 = useScaledValue(320)
	local v35 = if not v32.onClose then nil else {
		MaxSize = Vector2.new(v34 - v33.Size.Size_1200, 1e999)
	}
	local v36 = React.useMemo(function() -- line: 90
		-- upvalues: v32 (copy), Logger (copy), InputSize (copy), FillBehavior (copy), Dash (copy), React (copy), Button (copy)
		local t2 = {}

		if not v32.actions then
			return t2
		end

		for v62, v63 in v32.actions do
			if v62 > 2 then
				Logger:warning(`Coachmark only supports up to { 2 } actions`)

				return t2
			end

			local t3 = {
				LayoutOrder = v62,
				size = InputSize.Medium,
				fillBehavior = FillBehavior.Fill,
				testId = `{ v32.testId }--action-{ v62 }`
			}
			local v65 = Dash.union(v63, t3)

			t2["CoachmarkButton" .. v62] = React.createElement(Button, v65)
		end

		return t2
	end, {
		v32.actions,
		v32.testId
	})
	local createElement = React.createElement
	local Root = Popover.Root
	local t4 = {
		isOpen = v32.isOpen,
		testId = v32.testId
	}
	local t5 = {
		Anchor = React.createElement(Popover.Anchor, withCommonProps(v32, {
			anchorRef = v32.anchorRef
		}), v32.children)
	}
	local createElement2 = React.createElement
	local Content = Popover.Content
	local t6 = {
		hasArrow = true,
		align = v32.align,
		DO_NOT_USE_hasContentInputSink = Flags.FoundationCoachmarkInteractionFixes,
		side = {
			position = v32.side,
			offset = v33.Size.Size_200
		},
		radius = Radius.Medium,
		backgroundStyle = v33.Inverse.Surface.Surface_0,
		selection = v32.selection,
		selectionGroup = v32.selectionGroup,
		ref = p2
	}
	local createElement3 = React.createElement
	local Provider = PresentationContext.Provider
	local t7 = {
		value = {
			colorMode = ColorMode.Inverse
		}
	}
	local createElement4 = React.createElement
	local v48 = View
	local t8 = {
		tag = "col gap-medium auto-xy padding-bottom-medium",
		sizeConstraint = {
			MaxSize = Vector2.new(v34, 1e999)
		}
	}
	local t9 = {
		CloseAffordanceContainer = if not v32.onClose then nil else React.createElement("Folder", {}, {
			CloseAffordance = React.createElement(CloseAffordance, {
				onActivated = v32.onClose,
				size = InputSize.Small,
				variant = CloseAffordanceVariant.Utility,
				Position = UDim2.new(1, -v33.Padding.Small, 0, v33.Padding.Small),
				AnchorPoint = Vector2.new(1, 0),
				ZIndex = if not Flags.FoundationCoachmarkInteractionFixes then nil else 2,
				testId = `{ v32.testId }--close-affordance`
			})
		}),
		Media = if not v32.media then nil else React.createElement(View, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y"
		}, v32.media)
	}
	local createElement5 = React.createElement
	local v52 = View
	local t10 = {
		LayoutOrder = 2,
		tag = "col gap-xsmall auto-xy padding-x-medium padding-bottom-xsmall padding-top-medium"
	}
	local t11 = {}
	local v60

	if v32.steps then
		local createElement6 = React.createElement
		local v56 = Text
		local t12 = {
			LayoutOrder = 1,
			tag = "auto-xy text-label-small text-align-x-left text-truncate-end content-inverse-default"
		}
		local current = v32.steps.current
		local total = v32.steps.total

		t12.Text = Translator:FormatByKey("CommonUI.Controls.Label.PageCount", {
			current = current,
			total = total
		})
		t12.sizeConstraint = v35
		t12.testId = `{ v32.testId }--step-indicator`
		v60 = createElement6(v56, t12)
	else
		v60 = nil
	end

	t11.StepIndicator = v60
	t11.Header = if v32.title == "" then nil else React.createElement(Text, {
		LayoutOrder = 2,
		tag = "auto-xy text-title-large text-align-x-left text-truncate-split content-inverse-emphasis",
		Text = v32.title,
		sizeConstraint = v35,
		testId = `{ v32.testId }--header`
	})
	t11.Text = if not v32.text or v32.text == "" then nil else React.createElement(Text, {
		LayoutOrder = 3,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-inverse-default",
		Text = v32.text,
		testId = `{ v32.testId }--text`
	})
	t9.ContentSection = createElement5(v52, t10, t11)
	t9.Actions = if not v32.actions or not (#v32.actions > 0) then nil else React.createElement(View, {
		LayoutOrder = 3,
		tag = "row gap-small size-full-0 auto-y padding-x-medium"
	}, v36)
	t5.Content = createElement2(Content, t6, createElement3(Provider, t7, createElement4(v48, t8, t9)))

	return createElement(Root, t4, t5)
end

return React.memo(React.forwardRef(Coachmark))
