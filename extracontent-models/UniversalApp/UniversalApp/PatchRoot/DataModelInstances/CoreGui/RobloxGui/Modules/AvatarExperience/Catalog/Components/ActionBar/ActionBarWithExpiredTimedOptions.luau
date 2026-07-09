local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local ActionButton = require(Modules.AvatarExperience.Catalog.Components.ActionBar.ActionButton)
local View = Foundation.View
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local useStyle = UIBlox.Core.Style.useStyle

function ActionBarWithExpiredTimedOptions(t1: {[any]: any}) -- line: 24
	-- upvalues: useTokens (copy), useLocalization (copy), useStyle (copy), React (copy), FoundationText (copy), ActionButton (copy), View (copy)
	local v13 = useTokens()
	local v14 = useLocalization({
		expiredItemsPlural = {
			"Feature.Durables.BottomBar.Repurchase.ExpiredItemsPlural",
			number = t1.expiredItemCount
		},
		expiredItemsSingular = {
			"Feature.Durables.BottomBar.Repurchase.ExpiredItemsSingular",
			number = t1.expiredItemCount
		}
	})
	local v15 = if t1.expiredItemCount ~= 1 then v14.expiredItemsPlural else v14.expiredItemsSingular
	local t2 = {
		buttonText = "View",
		buttonIcon = nil,
		buttonIconPadding = 0,
		buttonIconSize = 0,
		buttonIsDisabled = false,
		buttonIsLoading = false,
		buttonColor = v13.Color.ActionEmphasis.Background.Color3,
		buttonTextColor = v13.Color.ActionEmphasis.Foreground.Color3,
		onActivated = t1.onViewPressed
	}
	local v17 = useStyle()
	local t3 = {
		ExpiredLabel = React.createElement(FoundationText, {
			tag = "text-title-large content-emphasis auto-xy anchor-center-left",
			LayoutOrder = 1,
			Position = UDim2.new(0, v13.Size.Size_200, 0.5, 0),
			Text = v15
		}),
		ActionButton = React.createElement(ActionButton, {
			LayoutOrder = 2,
			Size = UDim2.new(0.5, -v13.Size.Size_250, 0, v13.Size.Size_1000),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -v13.Size.Size_200, 0.5, 0),
			Font = v17.Font,
			buttonProps = t2
		})
	}

	return React.createElement(View, {
		tag = "size-full-0 anchor-bottom-left",
		ZIndex = 3,
		Size = UDim2.new(1, 0, 0, v13.Size.Size_1500),
		Position = UDim2.new(0, 0, 1, 0)
	}, {
		TopBorder = React.createElement(View, {
			ZIndex = 2,
			backgroundStyle = v13.Color.Stroke.Default,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, -1)
		}),
		ActionBarFrame = React.createElement(View, {
			tag = "bg-surface-0 padding-y-small padding-x-small",
			Size = UDim2.fromScale(1, 1)
		}, {
			ExpiredLabel = t3.ExpiredLabel,
			ActionButton = t3.ActionButton
		})
	})
end

return ActionBarWithExpiredTimedOptions
