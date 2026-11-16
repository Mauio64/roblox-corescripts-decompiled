local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local DividerWithText = require(AuthCommon.Components.DividerWithText)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

return function(props)
	local v = useTokens()
	local onActivated = React.useCallback(function()
		if props.onActivated then
			props.onActivated()
		end

		if ThirdPartyUserService then
			ThirdPartyUserService:ShowAccountPicker()
		end
	end, { props.onActivated })

	local v2 = useLocalization({
		dividerText = props.dividerTextKey,
		labelText = props.labelTextKey
	})

	local selection = {
		Selectable = not props.isDisabled,
		NextSelectionUp = props.nextSelectionUp
	}

	if props.labelTextKey then
		local scale = v.Config.UI.Scale
		local tag = props.isDisabled and "content-inverse-default" or "content-emphasis"
		return React.createElement(View, {
			LayoutOrder = props.layoutOrder,
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 10 * scale)
			},
			tag = "auto-xy"
		}, {
			Label = React.createElement(Text, {
				LayoutOrder = 1,
				Text = v2.labelText,
				tag = "auto-xy text-title-medium content-default"
			}),
			SwitchAccountButton = React.createElement(View, {
				LayoutOrder = 2,
				Size = UDim2.fromOffset(0, v.Size.Size_1200),
				padding = Vector2.new(13 * scale, 0),
				ref = props.buttonRef,
				testId = "--auth-platform-account-switch-button",
				selection = selection,
				isDisabled = props.isDisabled,
				onActivated = onActivated,
				tag = "row align-y-center gap-small auto-x radius-medium bg-over-media-0"
			}, {
				Image = React.createElement(Image, {
					LayoutOrder = 1,
					Image = "rbxasset://textures/ui/Shell/Icons/PlatformLogo.png",
					Size = UDim2.fromOffset(v.Size.Size_600, v.Size.Size_600),
					tag = tag
				}),
				TextWrapper = React.createElement(View, {
					LayoutOrder = 2,
					tag = "auto-xy padding-right-xsmall"
				}, {
					Text = React.createElement(Text, {
						Text = props.thirdPartyUserName,
						tag = "auto-xy text-label-large " .. tag
					})
				})
			})
		})
	else
		local v3, v4

		if props.isDisabled then
			v3 = "stroke-muted"
			v4 = "content-inverse-default"
		else
			v3 = "stroke-action-subtle"
			v4 = "content-default"
		end

		return React.createElement(
			View,
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
					font = v.Typography.CaptionSmall.Font,
					fontSize = v.Typography.CaptionSmall.FontSize,
					color3 = v.Color.Content.Muted.Color3,
					transparency = v.Color.Content.Muted.Transparency,
					text = not v2 and "" or v2.dividerText,
					padding = v.Size.Size_800
				}),
				SwitchAccountButton = React.createElement(View, {
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, v.Size.Size_1200),
					tag = "row gap-medium align-y-center align-x-center radius-medium " .. v3,
					ref = props.buttonRef,
					testId = "--auth-platform-account-switch-button",
					selection = selection,
					isDisabled = props.isDisabled,
					onActivated = onActivated
				}, {
					Image = React.createElement(Image, {
						LayoutOrder = 0,
						Image = "rbxasset://textures/ui/Shell/Icons/PlatformLogo.png",
						Size = UDim2.fromOffset(v.Size.Size_400, v.Size.Size_400),
						tag = "align-x-center align-x-left align-y-center " .. v4
					}),
					Text = React.createElement(Text, {
						LayoutOrder = 1,
						Text = props.thirdPartyUserName,
						tag = "auto-xy " .. v4
					})
				})
			}
		)
	end
end
