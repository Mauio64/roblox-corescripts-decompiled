local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local buttonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local module = require("@luauforge/bundled/dzD")
local module2 = require("@luauforge/bundled/igI")

local module3 = require("@luauforge/bundled/dFu")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module4 = require("@luauforge/bundled/ehB")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

return function(p2)
	local v5 = useDispatch()

	local v6 = useLocalization({
		LearnMoreText = "Feature.LocaleRestriction.Label.LearnMore",
		TitleText = "Feature.LocaleRestriction.Title.RobloxUnavailable",
		BodyText = "Feature.LocaleRestriction.Description.RobloxUnavailable"
	})

	local function openBrowser()
		local v7 = {
			name = module3.GenericWebPage,
			detail = "https://en.help.roblox.com/hc/articles/360000313606",
			extraProps = { title = v6.TitleText }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v7))
		else
			v5(module4(v7))
		end
	end

	local screenSize = p2.screenSize

	local v7 = useStyle()
	local theme = v7.Theme
	local font = v7.Font

	local globalGuiInset = p2.globalGuiInset
	globalGuiInset.bottom = module2()

	local udim = UDim2.fromOffset(0, globalGuiInset.top)
	local udim2 = UDim2.fromOffset(screenSize.X, screenSize.Y - globalGuiInset.top - globalGuiInset.bottom)

	local element = React.createElement(partialPageModal, {
		title = v6.TitleText,
		screenSize = screenSize,
		buttonHeight = 48,
		buttonStackProps = {
			buttons = {
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						isDisabled = false,
						onActivated = openBrowser,
						text = v6.LearnMoreText
					}
				}
			}
		}
	}, {
		Body = React.createElement(
			"Frame",
			{
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 60),
				BackgroundColor3 = theme.BackgroundUIDefault.Color,
				LayoutOrder = 1
			},
			{
				CustomInner = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = v6.BodyText,
					TextColor3 = theme.TextDefault.Color,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextScaled = true,
					FontFace = normalizeFontFace(v7.Tokens.Typography.BodyLarge.Font),
					Size = UDim2.new(1, 0, 1, 0)
				}, {
					UITextSizeConstraint = React.createElement("UITextSizeConstraint", {
						MaxTextSize = font.BaseSize * font.Body.RelativeSize
					})
				})
			}
		)
	})

	return React.createElement(
		"ScreenGui",
		{
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = module.DisplayOrder.AntiAddictionPrompt,
			IgnoreGuiInset = true
		},
		{
			OverlayFrame = React.createElement("ImageButton", {
				AutoButtonColor = false,
				Size = UDim2.new(1, 0, 1, 0),
				ImageTransparency = 1,
				BackgroundColor3 = theme.Overlay.Color,
				BackgroundTransparency = theme.Overlay.Transparency,
				BorderSizePixel = 0,
				Selectable = false
			}, {
				Overlay = React.createElement(
					"Frame",
					{
						Position = udim,
						Size = udim2,
						BorderSizePixel = 0,
						BackgroundTransparency = 1
					},
					{ Content = element }
				)
			})
		}
	)
end
