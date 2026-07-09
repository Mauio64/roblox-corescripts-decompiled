local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local GuiService = game:GetService("GuiService")
local IXPService = game:GetService("IXPService")
local UserInputService = game:GetService("UserInputService")
local canReactivate = require(NotApprovedPage.Utils.canReactivate)
local CtaButtonsContainer = require(NotApprovedPage.Components.cta.CtaButtonsContainer)
local GetCommutationEligibility = require(NotApprovedPage.Http.GetCommutationEligibility)
local Header = require(NotApprovedPage.Components.header.Header)
local LoadingSkeleton = require(NotApprovedPage.Components.LoadingSkeleton)
local NotApprovedPageProvider = require(NotApprovedPage.Contexts.NotApprovedPageContext).NotApprovedPageProvider
local PageAnalyticsProvider = require(NotApprovedPage.Contexts.PageAnalyticsContext).PageAnalyticsProvider
local PageItemsFromConfigs = require(NotApprovedPage.Components.pageItemConfigs.PageItemsFromConfigs)
local PageNavigationProvider = require(NotApprovedPage.Contexts.PageNavigationContext).PageNavigationProvider
local sendNotApprovedPageEvent = require(NotApprovedPage.Utils.sendNotApprovedPageEvent)
local setBadUtterancesTranslationKeys = require(NotApprovedPage.Utils.setBadUtterancesTranslationKeys)
local setViolationEvidenceTranslationKeys = require(NotApprovedPage.Utils.setViolationEvidenceTranslationKeys)

require(NotApprovedPage.Common.Types)

local Constants = require(NotApprovedPageParent.NotApprovedPageShared).Constants
local React = require(NotApprovedPageParent.React)
local useEffect = React.useEffect
local useState = React.useState
local AppUserLayers = require(NotApprovedPageParent.ExperimentLayers).AppUserLayers
local RoactNetworking = require(NotApprovedPageParent.RoactServiceTags).RoactNetworking
local useLocalization = require(NotApprovedPageParent.Localization).Hooks.useLocalization
local useRoactService = require(NotApprovedPageParent.RobloxAppHooks).useRoactService
local Responsive = require(NotApprovedPageParent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local View = require(NotApprovedPageParent.Foundation).View
local FFlagNotApprovedPageIXPExposure = require(NotApprovedPageParent.SharedFlags).FFlagNotApprovedPageIXPExposure
local EVENT_TYPES = Constants.EVENT_TYPES
local TRANSLATION_KEYS = Constants.TRANSLATION_KEYS

local function NotApprovedPageV2(t1: {[any]: any}) -- line: 60
	-- upvalues: useState (copy), UserInputService (copy), GuiService (copy), useRoactService (copy), RoactNetworking (copy), usePreferredInput (copy), Responsive (copy), useEffect (copy), GetCommutationEligibility (copy), FFlagNotApprovedPageIXPExposure (copy), IXPService (copy), AppUserLayers (copy), sendNotApprovedPageEvent (copy), EVENT_TYPES (copy), canReactivate (copy), TRANSLATION_KEYS (copy), setBadUtterancesTranslationKeys (copy), setViolationEvidenceTranslationKeys (copy), useLocalization (copy), React (copy), CtaButtonsContainer (copy), LoadingSkeleton (copy), NotApprovedPageProvider (copy), PageNavigationProvider (copy), PageAnalyticsProvider (copy), View (copy), Header (copy), PageItemsFromConfigs (copy)
	local v34, v35 = useState(true)
	local v36, v37 = useState(nil)
	local StatusBarSizeY = UserInputService.StatusBarSize.Y
	local BottomBarSizeY = UserInputService.BottomBarSize.Y
	local bottom = GuiService:GetSafeZoneOffsets().bottom
	local v41 = if BottomBarSizeY ~= 0 then BottomBarSizeY else bottom
	local moderationDetail = t1.moderationDetail
	local interventionType = t1.interventionType
	local v44 = useRoactService(RoactNetworking)
	local v45 = usePreferredInput() == Responsive.Input.Directional

	useEffect(function() -- line: 77
		-- upvalues: GetCommutationEligibility (copy), v44 (copy), v37 (copy), v35 (copy)
		GetCommutationEligibility(v44):andThen(function(p1) -- line: 79
			-- upvalues: v37 (copy)
			if p1.responseBody then
				v37(p1.responseBody)
			end
		end):catch(function(_) -- line: 84
			-- upvalues: v37 (copy)
			v37({
				educational_pass_eligible = false
			})
		end):finally(function() -- line: 90
			-- upvalues: v35 (copy)
			v35(false)
		end)
	end, { v44 })
	useEffect(function() -- line: 95
		-- upvalues: FFlagNotApprovedPageIXPExposure (copy), IXPService (copy), AppUserLayers (copy), sendNotApprovedPageEvent (copy), EVENT_TYPES (copy), moderationDetail (copy), canReactivate (copy), interventionType (copy)
		if FFlagNotApprovedPageIXPExposure and game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
			IXPService:LogFlagLinkedUserLayerExposure(AppUserLayers.NotApprovedPageUserIDLayer)
		end

		sendNotApprovedPageEvent({
			eventType = EVENT_TYPES.PageRendered,
			interventionId = moderationDetail.interventionId,
			verificationCategory = moderationDetail.verificationCategory,
			isReactivationEligible = tostring(canReactivate(interventionType, moderationDetail.endDate, moderationDetail.verificationCategory)),
			punishedUserId = moderationDetail.punishedUserId
		})
	end, {
		interventionType,
		moderationDetail.endDate,
		moderationDetail.verificationCategory,
		moderationDetail.interventionId,
		moderationDetail.punishedUserId
	})

	local v46 = TRANSLATION_KEYS

	setBadUtterancesTranslationKeys(moderationDetail, v46)
	setViolationEvidenceTranslationKeys(moderationDetail, v46)

	local v47 = useLocalization(v46)
	local v48 = React.createElement(CtaButtonsContainer, {
		moderationDetail = moderationDetail,
		LogoutThunk = t1.LogoutThunk
	})

	if v34 then
		return React.createElement(LoadingSkeleton)
	end

	return React.createElement(NotApprovedPageProvider, {
		translations = v47,
		moderationDetail = moderationDetail,
		commutationEligibility = v36
	}, React.createElement(PageNavigationProvider, {
		moderationDetail = moderationDetail
	}, React.createElement(PageAnalyticsProvider, nil, React.createElement(View, {
		tag = "size-full col align-x-center align-y-center bg-surface-0",
		padding = {
			top = UDim.new(0, StatusBarSizeY),
			bottom = UDim.new(0, v41)
		}
	}, {
		InnerContainer = React.createElement(View, {
			tag = "size-full col bg-surface-100 radius-large stroke-default stroke-standard",
			LayoutOrder = 1,
			sizeConstraint = {
				MaxSize = if not v45 then Vector2.new(600, 800) else Vector2.new(800, 1000)
			}
		}, {
			HeaderSection = React.createElement(Header, {
				LayoutOrder = 1,
				moderationDetail = moderationDetail,
				LogoutThunk = t1.LogoutThunk
			}),
			Content = React.createElement(View, {
				tag = "size-full-0 grow col",
				LayoutOrder = 2
			}, React.createElement(PageItemsFromConfigs, {
				moderationDetail = moderationDetail,
				LogoutThunk = t1.LogoutThunk,
				commutationEligibility = v36
			})),
			Footer = React.createElement(View, {
				tag = "size-full-0 auto-y col",
				LayoutOrder = 3
			}, {
				FooterContent = v48
			})
		})
	}))))
end

return React.memo(NotApprovedPageV2)
