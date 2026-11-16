local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local module = require("@luauforge/deferred/fvD")
local view = Foundation.View
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local useStyle = UIBlox.Core.Style.useStyle

function LUAUFORGE_MODULE_GLOBALS_gWW_ActionBarWithExpiredTimedOptions(p2)
	local v5 = useTokens()

	local v6 = useLocalization({
		expiredItemsPlural = {
			"Feature.Durables.BottomBar.Repurchase.ExpiredItemsPlural",
			number = p2.expiredItemCount
		},
		expiredItemsSingular = {
			"Feature.Durables.BottomBar.Repurchase.ExpiredItemsSingular",
			number = p2.expiredItemCount
		}
	})

	local v7 = if p2.expiredItemCount == 1 then v6.expiredItemsSingular else v6.expiredItemsPlural

	local v8 = {
		buttonText = "View",
		buttonIcon = nil,
		buttonIconPadding = 0,
		buttonIconSize = 0,
		buttonIsDisabled = false,
		buttonIsLoading = false,
		buttonColor = v5.Color.ActionEmphasis.Background.Color3,
		buttonTextColor = v5.Color.ActionEmphasis.Foreground.Color3,
		onActivated = p2.onViewPressed
	}

	local v9 = useStyle()

	local v10 = {
		ExpiredLabel = React.createElement(text, {
			tag = "text-title-large content-emphasis auto-xy anchor-center-left",
			Position = UDim2.new(0, v5.Size.Size_200, 0.5, 0),
			Text = v7,
			LayoutOrder = 1
		}),
		ActionButton = React.createElement(module, {
			Size = UDim2.new(0.5, -v5.Size.Size_250, 0, v5.Size.Size_1000),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -v5.Size.Size_200, 0.5, 0),
			LayoutOrder = 2,
			Font = v9.Font,
			buttonProps = v8
		})
	}

	return React.createElement(
		view,
		{
			tag = "size-full-0 anchor-bottom-left",
			Size = UDim2.new(1, 0, 0, v5.Size.Size_1500),
			Position = UDim2.new(0, 0, 1, 0),
			ZIndex = 3
		},
		{
			TopBorder = React.createElement(view, {
				backgroundStyle = v5.Color.Stroke.Default,
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 0, -1),
				ZIndex = 2
			}),
			ActionBarFrame = React.createElement(
				view,
				{
					tag = "bg-surface-0 padding-y-small padding-x-small",
					Size = UDim2.fromScale(1, 1)
				},
				{ ExpiredLabel = v10.ExpiredLabel, ActionButton = v10.ActionButton }
			)
		}
	)
end

return LUAUFORGE_MODULE_GLOBALS_gWW_ActionBarWithExpiredTimedOptions
