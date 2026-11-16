local VRService = game:GetService("VRService")

local module = require("@luauforge/deferred/fUU")
local useCallback = module.useCallback
local useEffect = module.useEffect
local useRef = module.useRef
local useState = module.useState
local useMemo = module.useMemo

local module2 = require("@luauforge/deferred/fUV")
local coachmark = module2.Coachmark
local overlayProvider = module2.OverlayProvider
local popoverSide = module2.Enums.PopoverSide
local popoverAlign = module2.Enums.PopoverAlign

local module3 = require("@luauforge/deferred/fVT")
local focusNavigableSurfaceIdentifierEnum = module3.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = module3.FocusNavigationEventNameEnum
require("@luauforge/deferred/fVU")
local useAppFocusRoot = module3.useAppFocusRoot

local constants = require("@luauforge/deferred/fUP").Constants
local module4 = require("@luauforge/deferred/fUO")
local module5 = require("@luauforge/deferred/fVV")
local module6 = require("@luauforge/deferred/fVW")
local module7 = require("@luauforge/deferred/fVX")
require("@luauforge/deferred/fUR")
local useNotApprovedPageContext = require("@luauforge/deferred/fVq").useNotApprovedPageContext

local PUNISHMENT_TYPE_TO_INTERVENTION_MAP = constants.PUNISHMENT_TYPE_TO_INTERVENTION_MAP

local function ReactivationCoachmark(props)
	local v5 = useRef(nil)
	local state, setState = useState(false)

	local v6 = useNotApprovedPageContext()
	local translations = v6.translations
	local commutationEligibility = v6.commutationEligibility

	local v7 = if VRService.VREnabled then module5() else nil

	local moderationDetail = props.moderationDetail
	local punishmentTypeDescription = moderationDetail.punishmentTypeDescription
	local endDate = moderationDetail.endDate
	local verificationCategory = moderationDetail.verificationCategory
	local v8 = verificationCategory and verificationCategory ~= ""
	local v9 = module4(
			PUNISHMENT_TYPE_TO_INTERVENTION_MAP[punishmentTypeDescription],
			endDate,
			verificationCategory
		)
		and not (v8 or module6(commutationEligibility) or props.hasNavigatedForward or state)

	local v10 = useCallback(function()
		setState(true)
	end, {})

	local v11 = useMemo(function()
		local v12 = {}
		v12[focusNavigationEventNameEnum.NavigateBack] = {
			handler = module7.onRelease(function(p2)
				p2.cancelled = true
				v10()
			end)
		}

		return v12
	end, { v10 })

	local v12 = useAppFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		isFocusable = v9,
		customEventHandlers = v11
	})

	local v13 = useCallback(function(current)
		v5.current = current

		if type(v12) == "function" then
			v12(current)
		end
	end, { v12 })

	useEffect(function()
		if v5.current then
			v5.current.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			v5.current.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
			v5.current.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
			v5.current.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			v5.current.SelectionGroup = true
		end
	end, { v9 })

	return module.createElement(overlayProvider, { gui = v7 }, {
		Coachmark = module.createElement(coachmark, {
			title = translations.reactivationNoticeHeading,
			text = translations.reactivationNoticeDescription,
			isOpen = v9,
			side = popoverSide.Top,
			align = popoverAlign.Center,
			anchorRef = props.anchorRef,
			onClose = v10,
			ref = v13
		})
	})
end

return module.memo(ReactivationCoachmark)
