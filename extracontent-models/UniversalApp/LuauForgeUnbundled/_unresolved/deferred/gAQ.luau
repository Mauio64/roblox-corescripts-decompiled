local VRService = game:GetService("VRService")

local module = require("@luauforge/deferred/gzS")
local useCallback = module.useCallback
local useEffect = module.useEffect
local useRef = module.useRef
local useState = module.useState
local useMemo = module.useMemo

local module2 = require("@luauforge/deferred/gzT")
local coachmark = module2.Coachmark
local overlayProvider = module2.OverlayProvider
local popoverSide = module2.Enums.PopoverSide
local popoverAlign = module2.Enums.PopoverAlign

local module3 = require("@luauforge/deferred/gAR")
local focusNavigableSurfaceIdentifierEnum = module3.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = module3.FocusNavigationEventNameEnum
require("@luauforge/deferred/gAS")
local useAppFocusRoot = module3.useAppFocusRoot

local constants = require("@luauforge/deferred/gzN").Constants
local module4 = require("@luauforge/deferred/gzM")
local module5 = require("@luauforge/deferred/gAT")
local module6 = require("@luauforge/deferred/gAU")
local module7 = require("@luauforge/deferred/gAV")
require("@luauforge/deferred/gzP")
local useNotApprovedPageContext = require("@luauforge/deferred/gAo").useNotApprovedPageContext

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
	local v10 = module4(
			PUNISHMENT_TYPE_TO_INTERVENTION_MAP[punishmentTypeDescription],
			endDate,
			verificationCategory
		)
		and not (v8 or module6(commutationEligibility) or props.hasNavigatedForward or state)

	local v11 = useCallback(function()
		setState(true)
	end, {})

	local v12 = useMemo(function()
		local v13 = {}
		v13[focusNavigationEventNameEnum.NavigateBack] = {
			handler = module7.onRelease(function(p2)
				p2.cancelled = true
				v11()
			end)
		}

		return v13
	end, { v11 })

	local v13 = useAppFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		isFocusable = v10,
		customEventHandlers = v12
	})

	local v14 = useCallback(function(current)
		v5.current = current

		if type(v13) == "function" then
			v13(current)
		end
	end, { v13 })

	useEffect(function()
		if v5.current then
			v5.current.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			v5.current.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
			v5.current.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
			v5.current.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			v5.current.SelectionGroup = true
		end
	end, { v10 })

	return module.createElement(overlayProvider, { gui = v7 }, {
		Coachmark = module.createElement(coachmark, {
			title = translations.reactivationNoticeHeading,
			text = translations.reactivationNoticeDescription,
			isOpen = v10,
			side = popoverSide.Top,
			align = popoverAlign.Center,
			anchorRef = props.anchorRef,
			onClose = v11,
			ref = v14
		})
	})
end

return module.memo(ReactivationCoachmark)
