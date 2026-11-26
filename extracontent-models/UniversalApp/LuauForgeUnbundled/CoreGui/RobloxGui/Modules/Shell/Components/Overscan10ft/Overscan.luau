local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local defineFastFlag = game:DefineFastFlag("FontFaceConsoleOverscan", false)

local buttonStack = UIBlox.App.Button.ButtonStack
local buttonType = UIBlox.App.Button.Enum.ButtonType
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useStyle = UIBlox.Core.Style.useStyle

local GlobalSettings = require("@game/CoreGui/RobloxGui/Modules/Shell/GlobalSettings")
local LocalizedStrings = require("@game/CoreGui/RobloxGui/Modules/Shell/LocalizedStrings")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation

local ControllerHint = require("@game/CoreGui/RobloxGui/Modules/Shell/Components/Overscan/ControllerHint")
local Edges = require("@game/CoreGui/RobloxGui/Modules/Shell/Components/Overscan10ft/Edges")

local function Overscan(props)
	local v5 = useNavigation()

	local onUnmount = props.onUnmount or v5.goBack

	local v6 = useLocalization({
		accept = "CommonUI.Controls.Action.Accept",
		cancel = "CommonUI.Controls.Action.Cancel"
	})

	local v7 = useDesignTokens(function(p2)
		return { buttonHeight = p2.Size.Size_1200, marginBetween = p2.Size.Size_300 }
	end)

	local v8 = useStyle()

	local ref = React.useRef(nil)

	local createElement = React.createElement
	local v10 = {
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
	local v12 = {
		Position = UDim2.new(0, 230, 0, 205),
		BackgroundTransparency = 1,
		Font = 0,
		FontFace = 0,
		FontSize = 0,
		TextColor3 = 0,
		TextXAlignment = 0,
		Text = 0
	}

	local v13 = if not defineFastFlag then GlobalSettings.LightFont else nil
	v12.Font = v13
	local v14 = if defineFastFlag then normalizeFontFace(GlobalSettings.LightFont) else nil
	v12.FontFace = v14
	v12.FontSize = GlobalSettings.HeaderSize
	v12.TextColor3 = GlobalSettings.WhiteTextColor
	v12.TextXAlignment = Enum.TextXAlignment.Left
	v12.Text = LocalizedStrings:LocStringUA("Xbox.Old.ScreenSizeWord")
	children.Title = createElement2("TextLabel", v12)

	local createElement3 = React.createElement
	local v16 = {
		Position = UDim2.new(0, 230, 0, 243),
		BackgroundTransparency = 1,
		Font = 0,
		FontFace = 0,
		FontSize = 0,
		TextColor3 = 0,
		TextXAlignment = 0,
		Text = 0
	}

	local v17 = if not defineFastFlag then GlobalSettings.RegularFont else nil
	v16.Font = v17
	local v18 = if defineFastFlag then normalizeFontFace(GlobalSettings.RegularFont) else nil
	v16.FontFace = v18
	v16.FontSize = GlobalSettings.ButtonSize
	v16.TextColor3 = GlobalSettings.WhiteTextColor
	v16.TextXAlignment = Enum.TextXAlignment.Left
	v16.Text = LocalizedStrings:LocStringUA("Xbox.Old.ResizeScreenPrompt")
	children.Prompt = createElement3("TextLabel", v16)

	children.Controller = React.createElement(ControllerHint)

	children.Actions = React.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(0.4, 0),
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, -201)
		},
		{ React.createElement(buttonStack, {
				buttonHeight = v7.buttonHeight,
				marginBetween = v7.marginBetween,
				forcedFillDirection = Enum.FillDirection.Horizontal,
				buttons = {
					{
						buttonType = buttonType.Secondary,
						props = {
							text = v6.cancel,
							fontStyle = v8.Font.Header1,
							onActivated = onUnmount
						}
					},
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							text = v6.accept,
							fontStyle = v8.Font.Header1,
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

	children.EdgeSelector = React.createElement(Edges, {
		onSetEdges = onUnmount,
		ref = ref
	})
	return createElement("Frame", v10, children)
end

return Overscan
