local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization

require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)

local Common = Modules.AvatarExperience.Common
local NavigationUtils = require(Common.Components.RoactNavigation.NavigationUtils)
local withMappedNavigationParams = require(Common.Components.RoactNavigation.withMappedNavigationParams)
local ModalWindow = require(CorePackages.Packages.UIBlox).App.Dialog.Modal.ModalWindow
local Foundation = require(CorePackages.Packages.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local Button = Foundation.Button
local InputSize = Foundation.Enums.InputSize
local FillBehavior = Foundation.Enums.FillBehavior

function ItemInfoRowPrompt(t1: {[any]: any}) -- line: 44
	-- upvalues: useLocalization (copy), React (copy), NavigationUtils (copy), View (copy), FoundationText (copy), Button (copy), FillBehavior (copy), InputSize (copy), ModalWindow (copy)
	local v16 = useLocalization({
		message = t1.message,
		confirmButtonText = t1.confirmButtonText
	})
	local v17 = React.useCallback(function() -- line: 50
		-- upvalues: NavigationUtils (copy), t1 (copy)
		NavigationUtils.closeFocusedScreen(t1.navigation)
	end, { t1.navigation })

	return React.createElement(ModalWindow, {
		isFullHeight = false,
		screenSize = t1.screenSize
	}, ((function() -- line: 54
		-- upvalues: React (copy), View (copy), FoundationText (copy), v16 (copy), Button (copy), FillBehavior (copy), InputSize (copy), v17 (copy)
		return {
			container = React.createElement(View, {
				tag = "size-full-0 auto-y padding-xlarge col gap-large"
			}, {
				Text = React.createElement(FoundationText, {
					tag = "size-full-0 auto-y text-align-x-left text-body-large text-wrap",
					RichText = true,
					LayoutOrder = 2,
					Text = v16.message
				}),
				Footer = React.createElement(View, {
					tag = "row size-full-0 auto-y",
					LayoutOrder = 3
				}, {
					Button = React.createElement(Button, {
						tag = "size-full-0 auto-y",
						fillBehavior = FillBehavior.Fill,
						text = v16.confirmButtonText,
						size = InputSize.Large,
						onActivated = v17
					})
				})
			})
		}
	end)()))
end

return withMappedNavigationParams(ItemInfoRowPrompt)
