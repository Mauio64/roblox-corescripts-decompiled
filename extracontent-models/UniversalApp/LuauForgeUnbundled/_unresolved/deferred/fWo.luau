local module = require("@luauforge/deferred/fUU")

local module2 = require("@luauforge/deferred/fUV")
local icon = module2.Icon
local iconSize = module2.Enums.IconSize
local text = module2.Text
local useTokens = module2.Hooks.useTokens
local view = module2.View

local module3 = require("@luauforge/deferred/fWc")
local circleSlash = module3.Icon.CircleSlash
local iconVariant = module3.IconVariant
local triangleExclamation = module3.Icon.TriangleExclamation

local module4 = require("@luauforge/deferred/fWp")
local module5 = require("@luauforge/deferred/fWq")
local module6 = require("@luauforge/deferred/fWt")
require("@luauforge/deferred/fUR")
local usePageNavigation = require("@luauforge/deferred/fVa").usePageNavigation
local useNotApprovedPageContext = require("@luauforge/deferred/fVq").useNotApprovedPageContext

local constants = require("@luauforge/deferred/fUP").Constants
local INTERVENTION_TYPES = constants.INTERVENTION_TYPES
local PUNISHMENT_TYPE_TO_INTERVENTION_MAP = constants.PUNISHMENT_TYPE_TO_INTERVENTION_MAP

local function Header(p2)
	local v5 = useTokens()
	local v6 = usePageNavigation()
	local translations = useNotApprovedPageContext().translations

	local isFirstPage = v6.isFirstPage
	local totalPages = v6.totalPages

	local punishmentTypeDescription = p2.moderationDetail.punishmentTypeDescription
	local verificationCategory = p2.moderationDetail.verificationCategory

	local v7 = PUNISHMENT_TYPE_TO_INTERVENTION_MAP[punishmentTypeDescription] or INTERVENTION_TYPES.Banned
	local v8 = v7 == INTERVENTION_TYPES.Warning
	local v9 = v7 == INTERVENTION_TYPES.Deleted
	local v10 = verificationCategory and verificationCategory ~= ""
	local v11 = if v10 then translations.genericSuspended else translations[punishmentTypeDescription]

	if not v11 or v11 == "" then
		v11 = translations.genericSuspended
	end

	local v12 = if v9 then circleSlash else triangleExclamation
	local v13 = if v8 and not v10 then v5.Color.System.Warning else v5.Color.System.Alert

	if isFirstPage then
		return module.createElement(
			view,
			{
				tag = "size-full-0 auto-y row flex-between items-center gap-medium padding-xxlarge"
			},
			{
				LeftContent = module.createElement(
					view,
					{
						tag = "auto-xy row gap-small items-center wrap shrink",
						LayoutOrder = 1
					},
					{
						PunishmentIcon = module.createElement(icon, {
							name = v12,
							size = iconSize.Large,
							variant = iconVariant.Regular,
							style = v13,
							LayoutOrder = 1
						}),
						PunishmentLabel = module.createElement(text, {
							tag = "auto-xy text-heading-small content-emphasis text-wrap text-align-x-left",
							Text = v11,
							LayoutOrder = 2
						})
					}
				),
				RightContent = module.createElement(view, {
					tag = "auto-xy shrink-0",
					LayoutOrder = 2
				}, {
					PopoverMenu = module.createElement(module5, {
						LogoutThunk = p2.LogoutThunk
					})
				})
			}
		)
	end

	return module.createElement(
		view,
		{
			tag = "size-full-0 auto-y col gap-xlarge items-start padding-y-xxlarge padding-right-xxlarge"
		},
		{
			BackButtonContainer = module.createElement(
				view,
				{ tag = "auto-xy padding-left-medium", LayoutOrder = 1 },
				{ BackButton = module.createElement(module4) }
			),
			ProgressBarContainer = totalPages > 2 and module.createElement(
				view,
				{ tag = "size-full-0 auto-y padding-left-xxlarge", LayoutOrder = 2 },
				{ ProgressBar = module.createElement(module6) }
			)
		}
	)
end

return module.memo(Header)
