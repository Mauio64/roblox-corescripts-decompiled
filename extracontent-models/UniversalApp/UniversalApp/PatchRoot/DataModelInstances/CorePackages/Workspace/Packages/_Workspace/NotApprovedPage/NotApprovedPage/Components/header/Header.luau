local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local React = require(NotApprovedPageParent.React)
local Foundation = require(NotApprovedPageParent.Foundation)
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local BuilderIcons = require(NotApprovedPageParent.BuilderIcons)
local CircleSlash = BuilderIcons.Icon.CircleSlash
local IconVariant = BuilderIcons.IconVariant
local TriangleExclamation = BuilderIcons.Icon.TriangleExclamation
local BackButton = require(NotApprovedPage.Components.header.BackButton)
local HeaderPopoverMenu = require(NotApprovedPage.Components.header.HeaderPopoverMenu)
local HeaderProgressBar = require(NotApprovedPage.Components.HeaderProgressBar)

require(NotApprovedPage.Common.Types)

local usePageNavigation = require(NotApprovedPage.Contexts.PageNavigationContext).usePageNavigation
local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext
local Constants = require(NotApprovedPageParent.NotApprovedPageShared).Constants
local INTERVENTION_TYPES = Constants.INTERVENTION_TYPES
local PUNISHMENT_TYPE_TO_INTERVENTION_MAP = Constants.PUNISHMENT_TYPE_TO_INTERVENTION_MAP

local function Header(t1: {[any]: any}) -- line: 43
	-- upvalues: useTokens (copy), usePageNavigation (copy), useNotApprovedPageContext (copy), PUNISHMENT_TYPE_TO_INTERVENTION_MAP (copy), INTERVENTION_TYPES (copy), CircleSlash (copy), TriangleExclamation (copy), React (copy), View (copy), Icon (copy), IconSize (copy), IconVariant (copy), FoundationText (copy), HeaderPopoverMenu (copy), BackButton (copy), HeaderProgressBar (copy)
	local v24 = useTokens()
	local v25 = usePageNavigation()
	local translations = useNotApprovedPageContext().translations
	local isFirstPage = v25.isFirstPage
	local totalPages = v25.totalPages
	local punishmentTypeDescription = t1.moderationDetail.punishmentTypeDescription
	local verificationCategory = t1.moderationDetail.verificationCategory
	local v31 = PUNISHMENT_TYPE_TO_INTERVENTION_MAP[punishmentTypeDescription] or INTERVENTION_TYPES.Banned
	local v32 = v31 == INTERVENTION_TYPES.Warning
	local v33 = v31 == INTERVENTION_TYPES.Deleted
	local v34 = verificationCategory and verificationCategory ~= ""
	local v35 = if not v34 then translations[punishmentTypeDescription] else translations.genericSuspended

	if not v35 or v35 == "" then
		v35 = translations.genericSuspended
	end

	local v36 = if not v33 then TriangleExclamation else CircleSlash
	local v37 = if not v32 or v34 then v24.Color.System.Alert else v24.Color.System.Warning

	if isFirstPage then
		return React.createElement(View, {
			tag = "size-full-0 auto-y row flex-between items-center gap-medium padding-xxlarge"
		}, {
			LeftContent = React.createElement(View, {
				tag = "auto-xy row gap-small items-center wrap shrink",
				LayoutOrder = 1
			}, {
				PunishmentIcon = React.createElement(Icon, {
					LayoutOrder = 1,
					name = v36,
					size = IconSize.Large,
					variant = IconVariant.Regular,
					style = v37
				}),
				PunishmentLabel = React.createElement(FoundationText, {
					tag = "auto-xy text-heading-small content-emphasis text-wrap text-align-x-left",
					LayoutOrder = 2,
					Text = v35
				})
			}),
			RightContent = React.createElement(View, {
				tag = "auto-xy shrink-0",
				LayoutOrder = 2
			}, {
				PopoverMenu = React.createElement(HeaderPopoverMenu, {
					LogoutThunk = t1.LogoutThunk
				})
			})
		})
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-xlarge items-start padding-y-xxlarge padding-right-xxlarge"
	}, {
		BackButtonContainer = React.createElement(View, {
			tag = "auto-xy padding-left-medium",
			LayoutOrder = 1
		}, {
			BackButton = React.createElement(BackButton)
		}),
		ProgressBarContainer = totalPages > 2 and React.createElement(View, {
			tag = "size-full-0 auto-y padding-left-xxlarge",
			LayoutOrder = 2
		}, {
			ProgressBar = React.createElement(HeaderProgressBar)
		})
	})
end

return React.memo(Header)
