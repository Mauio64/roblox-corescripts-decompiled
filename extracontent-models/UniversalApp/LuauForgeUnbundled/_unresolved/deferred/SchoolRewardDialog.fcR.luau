local module = require("@luauforge/deferred/eko")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local useLocalization = require("@luauforge/deferred/ekQ").Hooks.useLocalization

local module3 = require("@luauforge/deferred/eku")
local module4 = require("@luauforge/deferred/ekv")

local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View
local image = Foundation.Image
local button = Foundation.Button

local useTokens = Foundation.Hooks.useTokens

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize

local function SchoolRewardDialog(p2)
	local v5 = useTokens()
	local v6 = useLocalization({
		action = module4.DialogOkActionButton,
		title = module4.RewardDialogTitle,
		body = module4.RewardDialogBody
	})

	local v7 = module3.SchoolRewardDialog.HERO_HEIGHT * v5.Config.UI.Scale

	local v8 = module.useCallback(function(p3)
		if p3 then
			p3.ScrollBarThickness = 0
		end
	end, {})

	return module.createElement(
		sheet.Root,
		{
			onClose = p2.onDismiss,
			preferCenterSheet = true,
			testId = "schools-reward-dialog"
		},
		{
			Content = module.createElement(sheet.Content, { scrollingFrameRef = v8 }, {
				Illustration = module.createElement(
					view,
					{
						LayoutOrder = 1,
						tag = "col items-center size-full-0 auto-y padding-bottom-medium"
					},
					{
						Art = module.createElement(image, {
							Image = p2.mediaImage,
							ScaleType = Enum.ScaleType.Fit,
							Size = UDim2.new(1, 0, 0, v7)
						})
					}
				),
				Body = module.createElement(
					view,
					{ LayoutOrder = 2, tag = "col gap-xsmall size-full-0 auto-y" },
					{
						Title = module.createElement(text, {
							LayoutOrder = 1,
							Text = v6.title,
							tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left content-emphasis"
						}),
						Description = module.createElement(text, {
							LayoutOrder = 2,
							Text = v6.body,
							tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
						})
					}
				)
			}),
			Actions = module.createElement(sheet.Actions, nil, {
				Ok = module.createElement(button, {
					LayoutOrder = 1,
					text = v6.action,
					size = inputSize.Large,
					variant = buttonVariant.Emphasis,
					fillBehavior = fillBehavior.Fill,
					onActivated = p2.onDismiss
				})
			})
		}
	)
end

return SchoolRewardDialog
