local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local React = require(NotApprovedPageParent.React)
local Fragment = React.Fragment
local useState = React.useState
local useCallback = React.useCallback
local Foundation = require(NotApprovedPageParent.Foundation)
local Checkbox = Foundation.Checkbox
local InputSize = Foundation.Enums.InputSize
local ContinueButtonCta = require(NotApprovedPage.Components.cta.ContinueButtonCta)

require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils)

local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext

local function UnderstandImportanceContinueCta(p1) -- line: 25
	-- upvalues: useNotApprovedPageContext (copy), useState (copy), useCallback (copy), React (copy), Fragment (copy), Checkbox (copy), InputSize (copy), ContinueButtonCta (copy)
	local translations = useNotApprovedPageContext().translations
	local v15, v16 = useState(false)
	local v17 = useCallback(function(b1: boolean) -- line: 29
		-- upvalues: v16 (copy)
		v16(b1)
	end, {})

	return React.createElement(Fragment, nil, {
		AcknowledgementCheckbox = React.createElement(Checkbox, {
			LayoutOrder = 1,
			isChecked = v15,
			size = InputSize.Small,
			onActivated = v17,
			label = translations.acknowledgementCheckboxLabel
		}),
		ContinueButton = React.createElement(ContinueButtonCta, {
			layoutOrder = 2,
			moderationDetail = p1.moderationDetail,
			dispatch = p1.dispatch,
			isDisabled = not v15,
			LogoutThunk = p1.LogoutThunk,
			goToNextPage = p1.goToNextPage
		})
	})
end

return React.memo(UnderstandImportanceContinueCta)
