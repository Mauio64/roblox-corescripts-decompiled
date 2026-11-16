local module = require("@luauforge/deferred/fUU")
local fragment = module.Fragment
local useState = module.useState
local useEffect = module.useEffect

local module2 = require("@luauforge/deferred/fUV")
local checkbox = module2.Checkbox
local inputSize = module2.Enums.InputSize

require("@luauforge/deferred/fUY")

local useNotApprovedPageContext = require("@luauforge/deferred/fVq").useNotApprovedPageContext

local module3 = require("@luauforge/deferred/fWb")
local module4 = require("@luauforge/deferred/fWd")
local module5 = require("@luauforge/deferred/fUO")
local module6 = require("@luauforge/deferred/fWh")
local module7 = require("@luauforge/deferred/fUZ")

local constants = require("@luauforge/deferred/fUP").Constants
local EVENT_TYPES = constants.EVENT_TYPES
local INTERVENTION_TYPES = constants.INTERVENTION_TYPES
local PUNISHMENT_TYPE_TO_INTERVENTION_MAP = constants.PUNISHMENT_TYPE_TO_INTERVENTION_MAP

local function ProceedActionsCta(props)
	local translations = useNotApprovedPageContext().translations

	local moderationDetail = props.moderationDetail
	local endDate = moderationDetail.endDate
	local punishmentTypeDescription = moderationDetail.punishmentTypeDescription
	local verificationCategory = moderationDetail.verificationCategory

	local v5 = PUNISHMENT_TYPE_TO_INTERVENTION_MAP[punishmentTypeDescription]
	local v6 = module5(v5, endDate, verificationCategory)

	local state, setState = useState(false)
	local state2, setState2 = useState(false)

	useEffect(function()
		if v5 ~= INTERVENTION_TYPES.Banned then
			return
		end

		local thread = task.delay(60, function()
			setState2(function(p2): boolean
				return not p2
			end)
		end)

		return function()
			if thread and typeof(thread) == "thread" then
				task.cancel(thread)
			end
		end
	end, { state2, punishmentTypeDescription })

	local v7 = module.useCallback(function(p2)
		setState(p2)
		module7({ eventType = EVENT_TYPES.CheckboxChecked })
	end, {})

	local v8 = not v6
	local v9 = module6(endDate)

	return module.createElement(fragment, nil, {
		SuspensionDurationAlert = v8 and module.createElement(module3, {
			timeRemaining = v9,
			layoutOrder = 1
		}),
		AgreeCheckbox = not v8 and module.createElement(checkbox, {
			isChecked = state,
			size = inputSize.Small,
			onActivated = v7,
			label = translations.acknowledgementCheckboxLabel,
			LayoutOrder = 2
		}),
		ReactivationButton = module.createElement(module4, {
			moderationDetail = moderationDetail,
			layoutOrder = 3,
			LogoutThunk = props.LogoutThunk,
			isAgreed = state,
			canReactivate = v6,
			sendPageEvent = props.sendPageEvent
		})
	})
end

return module.memo(ProceedActionsCta)
