local module = require("@luauforge/deferred/gzS")
local useCallback = module.useCallback
local useRef = module.useRef
local useState = module.useState

local module2 = require("@luauforge/deferred/gzT")
local button = module2.Button
local buttonVariant = module2.Enums.ButtonVariant
local inputSize = module2.Enums.InputSize
local view = module2.View

require("@luauforge/deferred/gzW")

local module3 = require("@luauforge/deferred/gAQ")

local useNotApprovedPageContext = require("@luauforge/deferred/gAo").useNotApprovedPageContext

local module4 = require("@luauforge/deferred/gAW")

local function ContinueButtonCta(props)
	local translations = useNotApprovedPageContext().translations

	local state, setState = useState(nil)
	local v5 = useRef(nil)

	local v6 = useCallback(function(current)
		v5.current = current
		setState(current)
	end, {})

	if module4 then
		return module.createElement(view, {
			tag = "size-full-0 auto-y",
			LayoutOrder = props.layoutOrder or 1,
			ref = v6
		}, {
			Button = module.createElement(button, {
				text = translations.continueButton,
				onActivated = props.goToNextPage,
				variant = buttonVariant.Emphasis,
				size = inputSize.Medium,
				isDisabled = props.isDisabled or false,
				width = UDim.new(1, 0),
				testId = "continue-button"
			}),
			Coachmark = state and module.createElement(module3, {
				moderationDetail = props.moderationDetail,
				anchorRef = v5,
				hasNavigatedForward = props.hasNavigatedForward
			})
		})
	end

	return module.createElement(button, {
		text = translations.continueButton,
		onActivated = props.goToNextPage,
		variant = buttonVariant.Emphasis,
		size = inputSize.Medium,
		isDisabled = props.isDisabled or false,
		width = UDim.new(1, 0),
		LayoutOrder = props.layoutOrder or 1,
		testId = "continue-button"
	})
end

return module.memo(ContinueButtonCta)
