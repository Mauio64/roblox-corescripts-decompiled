local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useModalFocus = require("@luauforge/bundled/ghc").useModalFocus

local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize

local v5 = {
	SignInBlocked = "SignInBlocked",
	FaeDownAge = "FaeDownAge",
	SelfDeclared = "SelfDeclared"
}

local v6 = {
	[v5.SignInBlocked] = {
		title = "Authentication.Pioneer.Heading.GameUnavailable",
		description = "Authentication.Pioneer.Description.MinimumAgeNotMet",
		hasWarningIcon = true
	},
	[v5.FaeDownAge] = {
		title = "Authentication.Pioneer.Heading.PlayOnRoblox",
		description = "Authentication.Pioneer.Description.ProgressSavedOnRoblox",
		hasWarningIcon = false
	},
	[v5.SelfDeclared] = {
		title = "Authentication.Pioneer.Heading.PlayOnRoblox",
		description = "Authentication.Pioneer.Description.AccountReadyOnRoblox",
		hasWarningIcon = true
	}
}

return {
	BlockedState = v5,
	PioneerAgeRestrictedView = function(p2)
		local v7 = useModalFocus()
		local v8 = Foundation.Hooks.useTokens()
		local v9 = v6[p2.blockedState] or v6[v5.SignInBlocked]

		local v10 = useLocalization({ title = v9.title, description = v9.description })

		local createElement = React.createElement
		local root = dialog.Root
		local v11 = {
			size = dialogSize.Small,
			hasBackdrop = true,
			disablePortal = not p2.portalToFoundationOverlay,
			ref = v7
		}

		local createElement2 = React.createElement
		local view = Foundation.View

		local createElement3 = React.createElement
		local view2 = Foundation.View

		local v16 = if v9.hasWarningIcon then React.createElement(Foundation.Icon, {
			name = Foundation.Enums.IconName.TriangleExclamation,
			variant = Foundation.Enums.IconVariant.Filled,
			size = Foundation.Enums.IconSize.Medium,
			style = v8.Color.System.Warning,
			LayoutOrder = 1,
			testId = "pioneer-age-restricted-warning-icon"
		}) else nil
		return createElement(root, v11, {
			Body = createElement2(view, {
				tag = "col gap-small size-full-0 auto-y padding-top-large"
			}, {
				Heading = createElement3(
					view2,
					{
						LayoutOrder = 1,
						tag = "row align-y-center gap-small size-full-0 auto-y"
					},
					{
						WarningIcon = v16,
						Title = React.createElement(Foundation.Text, {
							LayoutOrder = 2,
							Text = v10.title,
							tag = "fill auto-y text-heading-small text-wrap text-align-x-left content-emphasis"
						})
					}
				),
				Description = React.createElement(dialog.Text, {
					LayoutOrder = 2,
					Text = v10.description
				})
			})
		})
	end
}
