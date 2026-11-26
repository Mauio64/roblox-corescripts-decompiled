local module = require("@luauforge/bundled/gmo")
local module2 = require("@luauforge/bundled/gmp")
local enums = module2.Enums
local module3 = require("@luauforge/bundled/gms")
local getRbxthumbWithTypeSizeAndOptions = module3.Utils.getRbxthumbWithTypeSizeAndOptions
local constants = module3.Utils.Constants
local useLocalization = require("@luauforge/bundled/gmt").Hooks.useLocalization
require("@luauforge/bundled/gmu")

return function(props)
	local v5 = useLocalization({
		signedOut = "Authentication.AccountPicker.Label.SignedOut"
	})

	local enableSignedOutAccounts = props.enableSignedOutAccounts

	local children = {}

	if #props.accounts == 0 then
		props.onClose()
	end

	for i, account in ipairs(props.accounts) do
		local username = account.username
		local v6 = username == nil and "" or username

		local createElement = module.createElement
		local view = module2.View

		local createElement2 = module.createElement
		local view2 = module2.View

		local children3 = {
			Avatar = module.createElement(
				module2.View,
				{
					tag = "col shrink size-1200-1200 radius-full self-center",
					LayoutOrder = 0
				},
				{
					AvatarContainer = module.createElement(
						module2.View,
						{
							Size = UDim2.new(0, 48, 0, 48),
							tag = "radius-circle bg-surface-200"
						},
						{
							AvatarImage = module.createElement(module2.Image, {
								Size = UDim2.new(1, 0, 1, 0),
								Image = getRbxthumbWithTypeSizeAndOptions(
									tostring(account.user_id),
									constants.RbxthumbTypes.AvatarHeadShot,
									150
								),
								tag = "radius-circle"
							})
						}
					)
				}
			),
			AccountInfo = module.createElement(
				module2.View,
				{ tag = "col fill auto-y items-start", LayoutOrder = 1 },
				{
					DisplayName = module.createElement(module2.Text, {
						Text = account.display_name or v6,
						tag = "auto-y size-full-0 text-title-large text-align-x-left",
						LayoutOrder = 0,
						TextTruncate = Enum.TextTruncate.SplitWord
					}),
					Username = module.createElement(module2.Text, {
						Text = "@" .. v6,
						tag = "auto-y size-full-0 text-body-small text-align-x-left",
						LayoutOrder = 1,
						TextTruncate = Enum.TextTruncate.SplitWord
					})
				}
			),
			SignedOutPill = 0,
			DeleteButton = 0
		}

		local v9 = if enableSignedOutAccounts and not account.has_valid_session then module.createElement(
			module2.View,
			{
				tag = "col auto-xy padding-x-small padding-y-xsmall radius-small bg-action-alert",
				LayoutOrder = 2
			},
			{
				PillText = module.createElement(module2.Text, {
					Text = v5.signedOut,
					tag = "auto-xy text-caption-large text-align-x-center text-title-medium"
				})
			}
		) else nil
		children3.SignedOutPill = v9

		children3.DeleteButton = module.createElement(
			module2.View,
			{ tag = "col auto-xy size-full-0 items-end", LayoutOrder = 3 },
			{
				DeleteIcon = module.createElement(module2.IconButton, {
					icon = enums.IconName.TrashCan,
					size = enums.InputSize.Medium,
					onActivated = function()
						props.setRemoveAccount(account)
					end
				})
			}
		)
		children[i] = createElement(view, {
			tag = {
				["size-full-0 auto-y items-center padding-bottom-small"] = true,
				col = enableSignedOutAccounts,
				["row padding-x-small"] = not enableSignedOutAccounts
			},
			LayoutOrder = i
		}, {
			AccountCard = createElement2(view2, {
				tag = {
					["row size-full-0 auto-y wrap gap-medium radius-medium align-y-center"] = true,
					["padding-y-small padding-left-small"] = enableSignedOutAccounts,
					["padding-y-medium padding-left-medium"] = not enableSignedOutAccounts
				},
				BackgroundTransparency = 1
			}, children3)
		})
	end

	if enableSignedOutAccounts then
		return module.createElement(module.Fragment, nil, children)
	end

	return module.createElement(module2.View, {
		tag = "col auto-xy size-full-0 auto-y padding-small"
	}, {
		ScrollView = module.createElement(module2.ScrollView, {
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.XY,
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				scrollBarVisibility = module2.Enums.ScrollBarVisibility.None
			},
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			AccountElements = module.createElement(
				module2.View,
				{ tag = "col auto-x size-full-0", LayoutOrder = 2 },
				children
			)
		})
	})
end
