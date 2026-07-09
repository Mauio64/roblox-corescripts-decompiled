local Parent = script:FindFirstAncestor("EngagementScreen").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local useDesignTokens = require(Parent.Style).useDesignTokens
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local DividerWithText = require(Parent.AuthCommon).Components.DividerWithText
local SwitchAccountButton = require(script.Parent.SwitchAccountButton)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local AppLogging = require(Parent.RoactServiceTags).AppLogging
local TelemetryConfigs = require(Parent.AuthAnalytics).TelemetryConfigs

local function EngagementScreen(t1: {[any]: any}) -- line: 23
	-- upvalues: useDesignTokens (copy), useLocalization (copy), useRoactService (copy), AppLogging (copy), React (copy), TelemetryConfigs (copy), Button (copy), ButtonType (copy), StandardButtonSize (copy), DividerWithText (copy), SwitchAccountButton (copy)
	local v16 = useDesignTokens(function(p1) -- line: 24
		return {
			headerFontStyle = p1.Typography.HeadingSmall,
			footerFontStyle = p1.Typography.CaptionSmall,
			defaultTextColor = p1.Color.Content.Default,
			mutedTextColor = p1.Color.Content.Muted,
			engagementScreen = p1.LuaApps.EngagementScreen
		}
	end)
	local headerFontStyle = v16.headerFontStyle
	local v18 = useLocalization({
		continue = "CommonUI.Features.Label.EngagementScreen.Continue",
		orYouCan = "CommonUI.Features.Labels.OrYouCan"
	})
	local v19 = useRoactService(AppLogging)
	local v20 = React.useCallback(function() -- line: 41
		-- upvalues: v19 (copy), TelemetryConfigs (copy), t1 (copy)
		pcall(function() -- line: 42
			-- upvalues: v19 (copy), TelemetryConfigs (copy)
			v19:logRobloxTelemetryCounter(TelemetryConfigs.EngagementScreenContinueButtonClickedConfig, 1)
		end)
		t1.onContinue()
	end, {
		t1.onContinue,
		v19
	})

	React.useLayoutEffect(function() -- line: 49
		-- upvalues: v19 (copy), TelemetryConfigs (copy)
		v19:logEventOnce("engagement_screen_did_mount")
		v19:logRobloxTelemetryCounter(TelemetryConfigs.EngagementScreenMountTelemetryConfig, 1)
	end, { v19 })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, if not t1.renderBackground then nil else t1.renderBackground(), React.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		Position = v16.engagementScreen.robloxLogoTextImagePosition,
		Size = v16.engagementScreen.robloxLogoTextImageSize,
		Image = v16.engagementScreen.robloxLogoTextImageUrl,
		AnchorPoint = Vector2.new(0.5, 0.5)
	}), React.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = v16.engagementScreen.buttonContainerPosition,
		Size = UDim2.new(0, v16.engagementScreen.containerWidth, 0, v16.engagementScreen.containerHeight),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}, React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, v16.engagementScreen.buttonPadding)
	}), React.createElement(Button, {
		layoutOrder = 1,
		buttonType = ButtonType.PrimarySystem,
		text = v18.continue,
		fontStyle = headerFontStyle,
		standardSize = StandardButtonSize.Regular,
		onActivated = v20
	}), if not t1.onSwitchAccounts then nil else React.createElement(React.Fragment, nil, React.createElement(DividerWithText, {
		layoutOrder = 2,
		width = 0,
		height = 0,
		size = UDim2.new(0, v16.engagementScreen.dividerWidth, 0, v16.engagementScreen.dividerHeight),
		font = v16.footerFontStyle.Font,
		fontSize = v16.footerFontStyle.FontSize,
		color3 = v16.mutedTextColor.Color3,
		transparency = v16.mutedTextColor.Transparency,
		text = v18.orYouCan,
		padding = v16.engagementScreen.dividerPadding
	}), React.createElement(SwitchAccountButton, {
		layoutOrder = 3,
		fontStyle = headerFontStyle,
		onActivated = t1.onSwitchAccounts
	}))))
end

return EngagementScreen
