local GuiService = game:GetService("GuiService")
local IXPService = game:GetService("IXPService")
local UserInputService = game:GetService("UserInputService")

local appUserLayers = require("@luauforge/deferred/gzL").AppUserLayers
local module = require("@luauforge/deferred/gzM")
local constants = require("@luauforge/deferred/gzN").Constants
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChat/Cryo")
local module3 = require("@luauforge/deferred/gzR")
local module4 = require("@luauforge/deferred/gBl")
local module5 = require("@luauforge/deferred/gBm")
local module6 = require("@luauforge/deferred/gAf")
local module7 = require("@luauforge/deferred/gBs")
local notApprovedPageProvider = require("@luauforge/deferred/gAo").NotApprovedPageProvider
local pageAnalyticsProvider = require("@luauforge/deferred/gzU").PageAnalyticsProvider
local module8 = require("@luauforge/deferred/gBt")
local pageNavigationProvider = require("@luauforge/deferred/gzY").PageNavigationProvider
local roactNetworking = require("@luauforge/deferred/gAz").RoactNetworking
local module9 = require("@luauforge/deferred/gzX")
local module10 = require("@luauforge/deferred/gBu")
local module11 = require("@luauforge/deferred/gBv")
require("@luauforge/deferred/gzP")

local module12 = require("@luauforge/deferred/gzS")
local useEffect = module12.useEffect
local useState = module12.useState

local useAppPolicy = require("@luauforge/deferred/gBw").useAppPolicy
local useLocalization = require("@luauforge/deferred/gAn").Hooks.useLocalization
local useRoactService = require("@luauforge/deferred/gAA").useRoactService

local module13 = require("@luauforge/deferred/gAB")
local usePreferredInput = module13.usePreferredInput

local view = require("@luauforge/deferred/gzT").View

local module14 = require("@luauforge/deferred/gAd")
local fFlagKidsNotApprovedPageTreatment = module14.FFlagKidsNotApprovedPageTreatment
local fFlagNotApprovedPageIXPExposure = module14.FFlagNotApprovedPageIXPExposure
local module15 = require("@luauforge/deferred/gBx")

local EVENT_TYPES = constants.EVENT_TYPES
local TRANSLATION_KEYS = constants.TRANSLATION_KEYS

local function NotApprovedPageV2(props)
	local state, setState = useState(true)
	local state2, setState2 = useState(nil)
	local v5

	if fFlagKidsNotApprovedPageTreatment or module15 then
		v5 = useAppPolicy(function(p2)
			local getAccountType = p2.getAccountType

			if getAccountType then
				return (getAccountType())
			end

			return nil
		end)
	else
		v5 = nil
	end

	local v6 = fFlagKidsNotApprovedPageTreatment and v5 == "Kids"
	local y = UserInputService.StatusBarSize.Y
	local y2 = UserInputService.BottomBarSize.Y
	local v7 = GuiService:GetSafeZoneOffsets().bottom

	if y2 ~= 0 then
		v7 = y2
	end

	local moderationDetail = props.moderationDetail
	local interventionType = props.interventionType

	local v8 = useRoactService(roactNetworking)
	local v9 = usePreferredInput() == module13.Input.Directional

	useEffect(function()
		module4(v8):andThen(function(p2)
			if p2.responseBody then
				setState2(p2.responseBody)
			end
		end):catch(function(p2)
			setState2({ educational_pass_eligible = false })
		end):finally(function()
			setState(false)
		end)
	end, { v8 })

	useEffect(function()
		local v10 = if module15 then v5 == "Kids" else fFlagNotApprovedPageIXPExposure

		if v10 and game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
			IXPService:LogFlagLinkedUserLayerExposure(appUserLayers.NotApprovedPageUserIDLayer)
		end

		local v11 = {
			eventType = EVENT_TYPES.PageRendered,
			interventionId = moderationDetail.interventionId,
			verificationCategory = moderationDetail.verificationCategory,
			isReactivationEligible = tostring(module(
				interventionType,
				moderationDetail.endDate,
				moderationDetail.verificationCategory
			)),
			punishedUserId = moderationDetail.punishedUserId
		}

		if fFlagKidsNotApprovedPageTreatment then
			v11.isKidsTreatment = tostring(v6)
		end

		module9(v11)
	end, {
		interventionType,
		moderationDetail.endDate,
		moderationDetail.verificationCategory,
		moderationDetail.interventionId,
		moderationDetail.punishedUserId,
		v5,
		v6
	})
	local v10

	if v6 then
		v10 = Cryo.Dictionary.join(TRANSLATION_KEYS, module6.TRANSLATION_KEYS)
	else
		v10 = TRANSLATION_KEYS
	end

	module10(moderationDetail, v10)
	module11(moderationDetail, v10)
	local v11 = useLocalization(v10)

	local element = module12.createElement(module3, {
		moderationDetail = moderationDetail,
		LogoutThunk = props.LogoutThunk
	})

	if state then
		return module12.createElement(module7)
	end

	local createElement = module12.createElement

	local createElement2 = module12.createElement

	local createElement3 = module12.createElement

	local createElement4 = module12.createElement
	local v19 = {
		tag = "col align-x-center align-y-center size-full bg-surface-0",
		padding = { top = UDim.new(0, y), bottom = UDim.new(0, v7) }
	}

	local createElement5 = module12.createElement

	local v24 = if v9 then Vector2.new(800, 1000) else Vector2.new(600, 800)
	return createElement(
		notApprovedPageProvider,
		{
			translations = v11,
			moderationDetail = moderationDetail,
			commutationEligibility = state2,
			isKidsTreatment = v6
		},
		createElement2(
			pageNavigationProvider,
			{ moderationDetail = moderationDetail },
			createElement3(pageAnalyticsProvider, { isKidsTreatment = v6 }, createElement4(view, v19, {
				InnerContainer = createElement5(view, {
					tag = "col size-full stroke-standard stroke-default radius-large bg-surface-100",
					sizeConstraint = { MaxSize = v24 },
					LayoutOrder = 1
				}, {
					HeaderSection = module12.createElement(module5, {
						moderationDetail = moderationDetail,
						LogoutThunk = props.LogoutThunk,
						LayoutOrder = 1
					}),
					Content = module12.createElement(
						view,
						{ tag = "col grow size-full-0", LayoutOrder = 2 },
						module12.createElement(module8, {
							moderationDetail = moderationDetail,
							LogoutThunk = props.LogoutThunk,
							commutationEligibility = state2
						})
					),
					Footer = module12.createElement(
						view,
						{ tag = "col size-full-0 auto-y", LayoutOrder = 3 },
						{ FooterContent = element }
					)
				})
			}))
		)
	)
end

return module12.memo(NotApprovedPageV2)
