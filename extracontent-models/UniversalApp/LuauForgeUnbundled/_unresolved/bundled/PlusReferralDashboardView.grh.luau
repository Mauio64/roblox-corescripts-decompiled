local module = require("@luauforge/bundled/grg")
local module2 = require("@luauforge/bundled/gri")
local view = module2.View
local scrollView = module2.ScrollView
local visibility = module2.Enums.Visibility
local iconName = module2.Enums.IconName

local GuiService = game:GetService("GuiService")

local module3 = require("@luauforge/bundled/grj")
local module4 = require("@luauforge/bundled/grk")
local module5 = require("@luauforge/bundled/gro")
local module6 = require("@luauforge/bundled/grq")
local module7 = require("@luauforge/bundled/grs")
local module8 = require("@luauforge/bundled/grl")

local function PlusReferralDashboardView(props)
	local v5 = GuiService.ViewportDisplaySize ~= Enum.DisplaySize.Small

	local element = module.createElement(view, {
		tag = "col size-full",
		sizeConstraint = v5 and {
			MaxSize = Vector2.new(module8.CONTENT_MAX_WIDTH, 1e999)
		} or nil
	}, {
		ScrollContent = module.createElement(scrollView, {
			LayoutOrder = 1,
			scroll = {
				scrollBarVisibility = visibility.None,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(0, 0)
			},
			flexItem = { FlexMode = Enum.UIFlexMode.Fill },
			Size = UDim2.fromScale(1, 1)
		}, {
			Content = module.createElement(
				view,
				{
					tag = "col gap-xxlarge size-full-0 auto-y padding-x-xlarge padding-bottom-xxlarge",
					LayoutOrder = 1
				},
				{
					Hero = module.createElement(module4, {
						titlePrefix = props.titlePrefix,
						titleAmount = props.titleAmount,
						description = props.description,
						layoutOrder = 1
					}),
					Rewards = module.createElement(module5, {
						youGet = {
							label = props.youGet.label,
							iconName = iconName.Robux,
							title = props.youGet.title,
							description = props.youGet.description
						},
						theyGet = {
							label = props.theyGet.label,
							iconName = iconName.Robux,
							title = props.theyGet.title,
							description = props.theyGet.description
						},
						layoutOrder = 2
					}),
					ReferralHistory = module.createElement(module6, {
						heading = props.referralHistoryHeading,
						successfulReferralsLabel = props.successfulReferralsLabel,
						robuxEarnedLabel = props.robuxEarnedLabel,
						successfulReferrals = props.successfulReferrals,
						robuxEarned = props.robuxEarned,
						pendingRobuxLabel = props.pendingRobuxLabel,
						pendingRobux = props.pendingRobux,
						layoutOrder = 3
					})
				}
			)
		}),
		ActionBar = module.createElement(module7, {
			buttonText = props.referButton,
			onActivated = props.onReferActivated,
			isDisabled = props.isReferDisabled,
			bottomInset = props.bottomInset,
			layoutOrder = 2
		})
	})

	if v5 then
		return module.createElement(view, { tag = "col size-full bg-surface-0" }, {
			TopBar = module.createElement(module3, {
				topInset = props.topInset,
				onClose = props.onClose,
				layoutOrder = 0
			}),
			CenteredContent = module.createElement(view, {
				tag = "col align-x-center size-full",
				flexItem = { FlexMode = Enum.UIFlexMode.Fill },
				LayoutOrder = 1
			}, { Content = element })
		})
	end

	return module.createElement(view, { tag = "col size-full bg-surface-0" }, {
		TopBar = module.createElement(module3, {
			topInset = props.topInset,
			onClose = props.onClose,
			layoutOrder = 0
		}),
		Content = module.createElement(view, {
			tag = "col size-full",
			flexItem = { FlexMode = Enum.UIFlexMode.Fill },
			LayoutOrder = 1
		}, { Inner = element })
	})
end

return PlusReferralDashboardView
