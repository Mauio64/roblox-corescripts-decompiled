local module = require("@luauforge/deferred/egU")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local useLocalization = require("@luauforge/deferred/ehw").Hooks.useLocalization

local module3 = require("@luauforge/deferred/ehb")

local dialog = Foundation.Dialog
local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize

local function CantFindSchoolDialog(p2)
	local v5 = useTokens()
	local v6 = useLocalization({
		title = module3.CantFindSchoolDialogTitle,
		body = module3.CantFindSchoolDialogBody,
		action = module3.DialogOkActionButton
	})

	local v7 = module.useMemo(function()
		local v8 = {
			LayoutOrder = 3,
			actions = {
				{
					text = v6.action,
					variant = buttonVariant.Emphasis,
					onActivated = p2.onDismiss
				}
			}
		}

		return module.createElement(dialog.Actions, v8)
	end, { v6.action, p2.onDismiss })

	return module.createElement(
		dialog.Root,
		{
			hasBackdrop = true,
			size = dialogSize.Small,
			testId = "schools-cant-find-school-dialog"
		},
		{
			Title = module.createElement(view, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y",
				padding = { top = UDim.new(0, v5.Size.Size_500) }
			}, {
				TitleText = module.createElement(text, {
					tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis",
					Text = v6.title
				})
			}),
			Content = module.createElement(dialog.Content, { LayoutOrder = 2 }, {
				Description = module.createElement(dialog.Text, { Text = v6.body })
			}),
			Actions = v7
		}
	)
end

return CantFindSchoolDialog
