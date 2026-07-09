local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local VRService = game:GetService("VRService")
local React = require(NotApprovedPageParent.React)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState
local useMemo = React.useMemo
local Foundation = require(NotApprovedPageParent.Foundation)
local Coachmark = Foundation.Coachmark
local OverlayProvider = Foundation.OverlayProvider
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local FocusNavigationUtils = require(NotApprovedPageParent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

require(NotApprovedPageParent.ReactFocusNavigation)

local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot
local Constants = require(NotApprovedPageParent.NotApprovedPageShared).Constants
local canReactivate = require(NotApprovedPage.Utils.canReactivate)
local getVRSurfaceGui = require(NotApprovedPage.Utils.getVRSurfaceGui)
local hasAnyCommutation = require(NotApprovedPage.Utils.hasAnyCommutation)
local InputHandlers = require(NotApprovedPageParent.InputHandlers)

require(NotApprovedPage.Common.Types)

local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext
local PUNISHMENT_TYPE_TO_INTERVENTION_MAP = Constants.PUNISHMENT_TYPE_TO_INTERVENTION_MAP

local function ReactivationCoachmark(t1: {[any]: any}) -- line: 52
	-- upvalues: useRef (copy), useState (copy), useNotApprovedPageContext (copy), VRService (copy), getVRSurfaceGui (copy), PUNISHMENT_TYPE_TO_INTERVENTION_MAP (copy), canReactivate (copy), hasAnyCommutation (copy), useCallback (copy), useMemo (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), useAppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), useEffect (copy), React (copy), OverlayProvider (copy), Coachmark (copy), PopoverSide (copy), PopoverAlign (copy)
	local v28 = useRef(nil)
	local v29, v30 = useState(false)
	local v31 = useNotApprovedPageContext()
	local translations = v31.translations
	local commutationEligibility = v31.commutationEligibility
	local v34 = if not VRService.VREnabled then nil else getVRSurfaceGui()
	local moderationDetail = t1.moderationDetail
	local punishmentTypeDescription = moderationDetail.punishmentTypeDescription
	local endDate = moderationDetail.endDate
	local verificationCategory = moderationDetail.verificationCategory
	local v39 = verificationCategory and verificationCategory ~= ""
	local v40 = PUNISHMENT_TYPE_TO_INTERVENTION_MAP[punishmentTypeDescription]
	local v41 = canReactivate(v40, endDate, verificationCategory) and (not v39 and (not hasAnyCommutation(commutationEligibility) and (not t1.hasNavigatedForward and not v29)))
	local v42 = useCallback(function() -- line: 78
		-- upvalues: v30 (copy)
		v30(true)
	end, {})
	local v43 = useMemo(function() -- line: 82
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v42 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p1) -- line: 85
					-- upvalues: v42 (copy)
					p1.cancelled = true
					v42()
				end)
			}
		}
	end, { v42 })
	local v44 = useAppFocusRoot({
		isAutoFocusRoot = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isFocusable = v41,
		customEventHandlers = v43
	})
	local v45 = useCallback(function(p2) -- line: 105
		-- upvalues: v28 (copy), v44 (copy)
		v28.current = p2

		if type(v44) == "function" then
			v44(p2)
		end
	end, { v44 })

	useEffect(function() -- line: 113
		-- upvalues: v28 (copy)
		if v28.current then
			v28.current.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			v28.current.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
			v28.current.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
			v28.current.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			v28.current.SelectionGroup = true
		end
	end, { v41 })

	return React.createElement(OverlayProvider, {
		gui = v34
	}, {
		Coachmark = React.createElement(Coachmark, {
			title = translations.reactivationNoticeHeading,
			text = translations.reactivationNoticeDescription,
			isOpen = v41,
			side = PopoverSide.Top,
			align = PopoverAlign.Center,
			anchorRef = t1.anchorRef,
			onClose = v42,
			ref = v45
		})
	})
end

return React.memo(ReactivationCoachmark)
