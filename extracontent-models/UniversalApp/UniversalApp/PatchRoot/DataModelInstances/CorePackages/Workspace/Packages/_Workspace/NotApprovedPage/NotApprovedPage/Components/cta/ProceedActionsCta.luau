local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local React = require(NotApprovedPageParent.React)
local Fragment = React.Fragment
local useState = React.useState
local useEffect = React.useEffect
local Foundation = require(NotApprovedPageParent.Foundation)
local Checkbox = Foundation.Checkbox
local InputSize = Foundation.Enums.InputSize

require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils)

local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext
local SuspensionDurationAlert = require(NotApprovedPage.Components.SuspensionDurationAlert)
local ReactivationButton = require(NotApprovedPage.Components.ReactivationButton)
local canReactivate = require(NotApprovedPage.Utils.canReactivate)
local calculateTimeRemaining = require(NotApprovedPage.Utils.calculateTimeRemaining)
local sendNotApprovedPageEvent = require(NotApprovedPage.Utils.sendNotApprovedPageEvent)
local Constants = require(NotApprovedPageParent.NotApprovedPageShared).Constants
local EVENT_TYPES = Constants.EVENT_TYPES
local INTERVENTION_TYPES = Constants.INTERVENTION_TYPES
local PUNISHMENT_TYPE_TO_INTERVENTION_MAP = Constants.PUNISHMENT_TYPE_TO_INTERVENTION_MAP

local function ProceedActionsCta(p1) -- line: 39
	-- upvalues: useNotApprovedPageContext (copy), PUNISHMENT_TYPE_TO_INTERVENTION_MAP (copy), canReactivate (copy), useState (copy), useEffect (copy), INTERVENTION_TYPES (copy), React (copy), sendNotApprovedPageEvent (copy), EVENT_TYPES (copy), calculateTimeRemaining (copy), Fragment (copy), SuspensionDurationAlert (copy), Checkbox (copy), InputSize (copy), ReactivationButton (copy)
	local translations = useNotApprovedPageContext().translations
	local moderationDetail = p1.moderationDetail
	local endDate = moderationDetail.endDate
	local punishmentTypeDescription = moderationDetail.punishmentTypeDescription
	local verificationCategory = moderationDetail.verificationCategory
	local v27 = PUNISHMENT_TYPE_TO_INTERVENTION_MAP[punishmentTypeDescription]
	local v28 = canReactivate(v27, endDate, verificationCategory)
	local v29, v30 = useState(false)
	local v31, v32 = useState(false)

	useEffect(function() -- line: 58
		-- upvalues: v27 (copy), INTERVENTION_TYPES (copy), v32 (copy)
		if v27 ~= INTERVENTION_TYPES.Banned then
			return
		end

		local thread = task.delay(60, function() -- line: 64
			-- upvalues: v32 (copy)
			v32(function(p2) -- line: 65
				return not p2
			end)
		end)

		return function() -- line: 70
			-- upvalues: thread (copy)
			if thread and typeof(thread) == "thread" then
				task.cancel(thread)
			end
		end
	end, {
		v31,
		punishmentTypeDescription
	})

	local v33 = React.useCallback(function(b1: boolean) -- line: 77
		-- upvalues: v30 (copy), sendNotApprovedPageEvent (copy), EVENT_TYPES (copy)
		v30(b1)
		sendNotApprovedPageEvent({
			eventType = EVENT_TYPES.CheckboxChecked
		})
	end, {})
	local v34 = not v28
	local v35 = calculateTimeRemaining(endDate)

	return React.createElement(Fragment, nil, {
		SuspensionDurationAlert = v34 and React.createElement(SuspensionDurationAlert, {
			layoutOrder = 1,
			timeRemaining = v35
		}),
		AgreeCheckbox = not v34 and React.createElement(Checkbox, {
			LayoutOrder = 2,
			isChecked = v29,
			size = InputSize.Small,
			onActivated = v33,
			label = translations.acknowledgementCheckboxLabel
		}),
		ReactivationButton = React.createElement(ReactivationButton, {
			layoutOrder = 3,
			moderationDetail = moderationDetail,
			LogoutThunk = p1.LogoutThunk,
			isAgreed = v29,
			canReactivate = v28,
			sendPageEvent = p1.sendPageEvent
		})
	})
end

return React.memo(ProceedActionsCta)
