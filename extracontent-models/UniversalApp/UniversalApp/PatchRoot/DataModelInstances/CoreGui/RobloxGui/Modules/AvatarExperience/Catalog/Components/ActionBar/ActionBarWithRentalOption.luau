local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local View = Foundation.View
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local getIconRichText = Foundation.Utility.getIconRichText
local IconName = Foundation.Enums.IconName

require(Modules.AvatarExperience.Common.Types)
require(Modules.AvatarExperience.Catalog.Components.ActionBar.BuyActionBar.useBuyActionBarButtonProps)

local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local Display = require(CorePackages.Workspace.Packages.Display)
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local FFlagAXMISEnableMultiShopping = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMISEnableMultiShopping

function ActionBarWithRentalOption(t1: {[any]: any}) -- line: 34
	-- upvalues: useTokens (copy), useLocalization (copy), FFlagEnableLeftNavOnConsole (copy), useSignalState (copy), Display (copy), React (copy), View (copy), FoundationText (copy), FFlagAXMISEnableMultiShopping (copy), getIconRichText (copy), IconName (copy)
	local v16 = useTokens()
	local v17 = useLocalization({
		buy = "Feature.Catalog.Action.Buy",
		rent = "Feature.Catalog.Action.Rent"
	})
	local v18 = if not FFlagEnableLeftNavOnConsole then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	local price = nil
	local price2 = nil

	if t1.timedOptions then
		for _, v22 in t1.timedOptions do
			if v22.days == 3 then
				price = v22.price
			elseif v22.days == 0 then
				price2 = v22.price
			end
		end
	end

	return React.createElement(View, {
		tag = "size-full-0",
		Size = UDim2.fromScale(1, 1)
	}, {
		ActionBarFrame = React.createElement(View, {
			tag = "row padding-x-xlarge padding-top-large bg-surface-0 gap-medium",
			Size = UDim2.new(1, not FFlagEnableLeftNavOnConsole and 0 or v18.right, 0, v16.Size.Size_1800 + (FFlagEnableLeftNavOnConsole and v18.bottom or 0)),
			Position = UDim2.new(0, 0, 1, -v16.Size.Size_1800),
			padding = if not FFlagEnableLeftNavOnConsole then nil else {
				right = UDim.new(0, v18.right),
				bottom = UDim.new(0, v18.bottom)
			}
		}, {
			BuyButton = React.createElement(View, {
				tag = "col fill radius-medium bg-action-emphasis align-x-center align-y-center",
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, v16.Size.Size_1000),
				onActivated = t1.buttonProps.onActivated
			}, {
				Label = React.createElement(FoundationText, {
					RichText = true,
					tag = not FFlagAXMISEnableMultiShopping and "text-heading-small content-action-emphasis auto-xy" or "text-title-large content-action-emphasis auto-xy",
					Text = `{ v17.buy } { getIconRichText(IconName.Robux) } { price2 or "" }`
				})
			}),
			RentalButton = React.createElement(View, {
				tag = "col fill radius-medium bg-action-standard align-x-center align-y-center",
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, v16.Size.Size_1000),
				onActivated = t1.rentalButtonProps.onActivated
			}, {
				Label = React.createElement(FoundationText, {
					RichText = true,
					tag = not FFlagAXMISEnableMultiShopping and "text-heading-small content-default auto-xy" or "text-title-large content-default auto-xy",
					Text = `{ v17.rent } { getIconRichText(IconName.Robux) } { price or "" }`
				})
			})
		})
	})
end

return ActionBarWithRentalOption
