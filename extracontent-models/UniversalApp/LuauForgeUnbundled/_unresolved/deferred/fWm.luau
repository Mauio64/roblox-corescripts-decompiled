local module = require("@luauforge/deferred/fUU")

local fragment = module.Fragment
local useState = module.useState
local useCallback = module.useCallback

local module2 = require("@luauforge/deferred/fUV")
local checkbox = module2.Checkbox
local inputSize = module2.Enums.InputSize

local module3 = require("@luauforge/deferred/fVR")

require("@luauforge/deferred/fUY")

local useNotApprovedPageContext = require("@luauforge/deferred/fVq").useNotApprovedPageContext

local function UnderstandRuleContinueCta(props)
	local translations = useNotApprovedPageContext().translations
	local state, setState = useState(false)

	local v5 = useCallback(function(p2)
		setState(p2)
	end, {})

	return module.createElement(fragment, nil, {
		AcknowledgementCheckbox = module.createElement(checkbox, {
			isChecked = state,
			size = inputSize.Small,
			onActivated = v5,
			label = translations.acknowledgementCheckboxLabel,
			LayoutOrder = 1
		}),
		ContinueButton = module.createElement(module3, {
			moderationDetail = props.moderationDetail,
			dispatch = props.dispatch,
			isDisabled = not state,
			LogoutThunk = props.LogoutThunk,
			goToNextPage = props.goToNextPage,
			hasNavigatedForward = props.hasNavigatedForward,
			layoutOrder = 2
		})
	})
end

return module.memo(UnderstandRuleContinueCta)
