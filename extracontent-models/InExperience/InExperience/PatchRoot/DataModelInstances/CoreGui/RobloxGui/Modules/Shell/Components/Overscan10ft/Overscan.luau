local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local defineFastFlag = game:DefineFastFlag("FontFaceConsoleOverscan", false)

local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Style = require(CorePackages.Workspace.Packages.Style)
local useDesignTokens = Style.useDesignTokens
local useStyle = UIBlox.Core.Style.useStyle

local GlobalSettings = require(Modules.Shell.GlobalSettings)
local LocalizedStrings = require(Modules.Shell.LocalizedStrings)
local Localization = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Navigation = require(CorePackages.Workspace.Packages.Navigation)
local useNavigation = Navigation.useNavigation

local ControllerHint = require(Modules.Shell.Components.Overscan.ControllerHint)
local Edges = require(script.Parent.Edges)

local function Overscan(props)
	local v = useNavigation()

	local onUnmount = props.onUnmount or v.goBack

	local v2 = useLocalization({
		accept = "CommonUI.Controls.Action.Accept",
		cancel = "CommonUI.Controls.Action.Cancel"
	})

	local v3 = useDesignTokens(function(p)
		return { buttonHeight = p.Size.Size_1200, marginBetween = p.Size.Size_300 }
	end)

	local v4 = useStyle()

	local ref = React.useRef(nil)

	local createElement = React.createElement
	local v5 = {
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 1,
		BackgroundTransparency = props.BackgroundTransparency,
		BackgroundColor3 = Color3.new(1 / 85, 1 / 85, 1 / 85)
	}
	local children = { [1] = nil, [1] = nil, [1] = nil, [1] = nil, [1] = nil, (React.createElement("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new(1 / 85, 1 / 85, 1 / 85),
			BorderSizePixel = 1,
			Visible = props.ImageVisible,
			Image = "rbxasset://textures/ui/Shell/ScreenAdjustment/Background.png"
		})) }

	local createElement2 = React.createElement
	local v6 = {
		Position = UDim2.new(0, 230, 0, 205),
		BackgroundTransparency = 1,
		Font = 0,
		FontFace = 0,
		FontSize = 0,
		TextColor3 = 0,
		TextXAlignment = 0,
		Text = 0
	}
	local font

	if not defineFastFlag then
		font = GlobalSettings.LightFont
	end

	v6.Font = font
	local fontFace

	if defineFastFlag then
		fontFace = normalizeFontFace(GlobalSettings.LightFont)
	end

	v6.FontFace = fontFace
	v6.FontSize = GlobalSettings.HeaderSize
	v6.TextColor3 = GlobalSettings.WhiteTextColor
	v6.TextXAlignment = Enum.TextXAlignment.Left
	v6.Text = LocalizedStrings:LocStringUA("Xbox.Old.ScreenSizeWord")
	children.Title = createElement2("TextLabel", v6)

	local createElement3 = React.createElement
	local v7 = {
		Position = UDim2.new(0, 230, 0, 243),
		BackgroundTransparency = 1,
		Font = 0,
		FontFace = 0,
		FontSize = 0,
		TextColor3 = 0,
		TextXAlignment = 0,
		Text = 0
	}
	local font2

	if not defineFastFlag then
		font2 = GlobalSettings.RegularFont
	end

	v7.Font = font2
	local fontFace2

	if defineFastFlag then
		fontFace2 = normalizeFontFace(GlobalSettings.RegularFont)
	end

	v7.FontFace = fontFace2
	v7.FontSize = GlobalSettings.ButtonSize
	v7.TextColor3 = GlobalSettings.WhiteTextColor
	v7.TextXAlignment = Enum.TextXAlignment.Left
	v7.Text = LocalizedStrings:LocStringUA("Xbox.Old.ResizeScreenPrompt")
	children.Prompt = createElement3("TextLabel", v7)

	children.Controller = React.createElement(ControllerHint)

	children.Actions = React.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(0.4, 0),
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, -201)
		},
		{ React.createElement(ButtonStack, {
				buttonHeight = v3.buttonHeight,
				marginBetween = v3.marginBetween,
				forcedFillDirection = Enum.FillDirection.Horizontal,
				buttons = {
					{
						buttonType = ButtonType.Secondary,
						props = {
							text = v2.cancel,
							fontStyle = v4.Font.Header1,
							onActivated = onUnmount
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							text = v2.accept,
							fontStyle = v4.Font.Header1,
							onActivated = function()
								if ref.current then
									ref.current.onAccept()
								end
							end
						}
					}
				}
			}) }
	)

	children.EdgeSelector = React.createElement(Edges, { onSetEdges = onUnmount, ref = ref })
	return createElement("Frame", v5, children)
end

return Overscan
