local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local React = require(NotApprovedPageParent.React)
local useCallback = React.useCallback
local useRef = React.useRef
local useState = React.useState
local Foundation = require(NotApprovedPageParent.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local View = Foundation.View

require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils)

local ReactivationCoachmark = require(NotApprovedPage.Components.cta.ReactivationCoachmark)
local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext
local FFlagEnableNapReactivationNotice = require(NotApprovedPage.Flags.FFlagEnableNapReactivationNotice)

local function ContinueButtonCta(p1) -- line: 30
	-- upvalues: useNotApprovedPageContext (copy), useState (copy), useRef (copy), useCallback (copy), FFlagEnableNapReactivationNotice (copy), React (copy), View (copy), Button (copy), ButtonVariant (copy), InputSize (copy), ReactivationCoachmark (copy)
	local translations = useNotApprovedPageContext().translations
	local v18, v19 = useState(nil)
	local v20 = useRef(nil)
	local v21 = useCallback(function(p2) -- line: 38
		-- upvalues: v20 (copy), v19 (copy)
		v20.current = p2
		v19(p2)
	end, {})

	if FFlagEnableNapReactivationNotice then
		return React.createElement(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = p1.layoutOrder or 1,
			ref = v21
		}, {
			Button = React.createElement(Button, {
				testId = "continue-button",
				text = translations.continueButton,
				onActivated = p1.goToNextPage,
				variant = ButtonVariant.Emphasis,
				size = InputSize.Medium,
				isDisabled = p1.isDisabled or false,
				width = UDim.new(1, 0)
			}),
			Coachmark = v18 and React.createElement(ReactivationCoachmark, {
				moderationDetail = p1.moderationDetail,
				anchorRef = v20,
				hasNavigatedForward = p1.hasNavigatedForward
			})
		})
	end

	return React.createElement(Button, {
		testId = "continue-button",
		text = translations.continueButton,
		onActivated = p1.goToNextPage,
		variant = ButtonVariant.Emphasis,
		size = InputSize.Medium,
		isDisabled = p1.isDisabled or false,
		width = UDim.new(1, 0),
		LayoutOrder = p1.layoutOrder or 1
	})
end

return React.memo(ContinueButtonCta)
