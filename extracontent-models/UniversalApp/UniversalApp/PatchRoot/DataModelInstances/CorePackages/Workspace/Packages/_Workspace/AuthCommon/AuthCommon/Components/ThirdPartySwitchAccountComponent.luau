local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local React = require(AuthCommonParent.React)
local Foundation = require(AuthCommonParent.Foundation)
local DividerWithText = require(AuthCommon.Components.DividerWithText)
local useLocalization = require(AuthCommonParent.Localization).Hooks.useLocalization
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local View = Foundation.View
local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

return function(t1: {[any]: any}) -- line: 22
	-- upvalues: useTokens (copy), React (copy), ThirdPartyUserService (copy), useLocalization (copy), View (copy), DividerWithText (copy), FoundationImage (copy), FoundationText (copy)
	local v13 = useTokens()
	local v14 = React.useCallback(function() -- line: 24
		-- upvalues: ThirdPartyUserService (copy)
		if ThirdPartyUserService then
			ThirdPartyUserService:ShowAccountPicker()
		end
	end, {})
	local v15 = useLocalization({
		dividerText = t1.dividerTextKey
	})
	local s1, s2

	if t1.isDisabled then
		s1 = "stroke-muted"
		s2 = "content-inverse-default"
	else
		s1 = "stroke-action-subtle"
		s2 = "content-default"
	end

	return React.createElement(View, {
		tag = "col gap-xxlarge align-x-center auto-xy size-full-0",
		LayoutOrder = t1.layoutOrder
	}, {
		Divider = React.createElement(DividerWithText, {
			layoutOrder = 1,
			width = 0,
			height = 0,
			AutomaticSize = Enum.AutomaticSize.XY,
			size = UDim2.new(1, 0, 0, 0),
			font = v13.Typography.CaptionSmall.Font,
			fontSize = v13.Typography.CaptionSmall.FontSize,
			color3 = v13.Color.Content.Muted.Color3,
			transparency = v13.Color.Content.Muted.Transparency,
			text = not v15 and "" or v15.dividerText,
			padding = v13.Size.Size_800
		}),
		SwitchAccountButton = React.createElement(View, {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v13.Size.Size_1200),
			tag = "row gap-medium align-y-center align-x-center radius-medium " .. s1,
			selection = {
				Selectable = not t1.isDisabled
			},
			isDisabled = t1.isDisabled,
			onActivated = v14
		}, {
			Image = React.createElement(FoundationImage, {
				LayoutOrder = 0,
				Image = "rbxasset://textures/ui/Shell/Icons/PlatformLogo.png",
				Size = UDim2.fromOffset(v13.Size.Size_400, v13.Size.Size_400),
				tag = "align-x-center align-x-left align-y-center " .. s2
			}),
			Text = React.createElement(FoundationText, {
				LayoutOrder = 1,
				Text = t1.thirdPartyUserName,
				tag = "auto-xy " .. s2
			})
		})
	})
end
