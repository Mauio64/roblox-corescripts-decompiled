local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation")

local DividerWithText = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/DividerWithText")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Localization").Hooks.useLocalization
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local view = Foundation.View
local text = Foundation.Text
local image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

return function(props)
	local v5 = useTokens()
	local v6 = React.useCallback(function()
		if props.onActivated then
			props.onActivated()
		end

		if ThirdPartyUserService then
			ThirdPartyUserService:ShowAccountPicker()
		end
	end, { props.onActivated })

	local v7 = useLocalization({
		dividerText = props.dividerTextKey,
		labelText = props.labelTextKey
	})

	local v8 = {
		Selectable = not props.isDisabled,
		NextSelectionUp = props.nextSelectionUp
	}

	if props.labelTextKey then
		local scale = v5.Config.UI.Scale
		local v9 = props.isDisabled and "content-inverse-default" or "content-emphasis"
		return React.createElement(view, {
			LayoutOrder = props.layoutOrder,
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 10 * scale)
			},
			tag = "auto-xy"
		}, {
			Label = React.createElement(text, {
				LayoutOrder = 1,
				Text = v7.labelText,
				tag = "auto-xy text-title-medium content-default"
			}),
			SwitchAccountButton = React.createElement(view, {
				LayoutOrder = 2,
				Size = UDim2.fromOffset(0, v5.Size.Size_1200),
				padding = Vector2.new(13 * scale, 0),
				ref = props.buttonRef,
				testId = "--auth-platform-account-switch-button",
				selection = v8,
				isDisabled = props.isDisabled,
				onActivated = v6,
				tag = "row align-y-center gap-small auto-x radius-medium bg-over-media-0"
			}, {
				Image = React.createElement(image, {
					LayoutOrder = 1,
					Image = "rbxasset://textures/ui/Shell/Icons/PlatformLogo.png",
					Size = UDim2.fromOffset(v5.Size.Size_600, v5.Size.Size_600),
					tag = v9
				}),
				TextWrapper = React.createElement(
					view,
					{ LayoutOrder = 2, tag = "auto-xy padding-right-xsmall" },
					{
						Text = React.createElement(text, {
							Text = props.thirdPartyUserName,
							tag = "auto-xy text-label-large " .. v9
						})
					}
				)
			})
		})
	else
		local v9, v10

		if props.isDisabled then
			v9 = "stroke-muted"
			v10 = "content-inverse-default"
		else
			v9 = "stroke-action-subtle"
			v10 = "content-default"
		end

		return React.createElement(
			view,
			{
				LayoutOrder = props.layoutOrder,
				tag = "col align-x-center gap-xxlarge size-full-0 auto-xy"
			},
			{
				Divider = React.createElement(DividerWithText, {
					layoutOrder = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					size = UDim2.new(1, 0, 0, 0),
					width = 0,
					height = 0,
					font = v5.Typography.CaptionSmall.Font,
					fontSize = v5.Typography.CaptionSmall.FontSize,
					color3 = v5.Color.Content.Muted.Color3,
					transparency = v5.Color.Content.Muted.Transparency,
					text = not v7 and "" or v7.dividerText,
					padding = v5.Size.Size_800
				}),
				SwitchAccountButton = React.createElement(view, {
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, v5.Size.Size_1200),
					tag = "row gap-medium align-y-center align-x-center radius-medium " .. v9,
					ref = props.buttonRef,
					testId = "--auth-platform-account-switch-button",
					selection = v8,
					isDisabled = props.isDisabled,
					onActivated = v6
				}, {
					Image = React.createElement(image, {
						LayoutOrder = 0,
						Image = "rbxasset://textures/ui/Shell/Icons/PlatformLogo.png",
						Size = UDim2.fromOffset(v5.Size.Size_400, v5.Size.Size_400),
						tag = "align-x-center align-x-left align-y-center " .. v10
					}),
					Text = React.createElement(text, {
						LayoutOrder = 1,
						Text = props.thirdPartyUserName,
						tag = "auto-xy " .. v10
					})
				})
			}
		)
	end
end
