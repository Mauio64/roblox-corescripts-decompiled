local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useStyle = UIBlox.Core.Style.useStyle
local GlobalSettings = require(Modules.Shell.GlobalSettings)
local LocalizedStrings = require(Modules.Shell.LocalizedStrings)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local ControllerHint = require(Modules.Shell.Components.Overscan.ControllerHint)
local Edges = require(script.Parent.Edges)

local function Overscan(t1: {[any]: any}) -- line: 27
	-- upvalues: useNavigation (copy), useLocalization (copy), useDesignTokens (copy), useStyle (copy), React (copy), GlobalSettings (copy), LocalizedStrings (copy), ControllerHint (copy), ButtonStack (copy), ButtonType (copy), Edges (copy)
	local v17 = useNavigation()
	local v18 = t1.onUnmount or v17.goBack
	local v19 = useLocalization({
		accept = "CommonUI.Controls.Action.Accept",
		cancel = "CommonUI.Controls.Action.Cancel"
	})
	local v20 = useDesignTokens(function(p1) -- line: 37
		return {
			buttonHeight = p1.Size.Size_1200,
			marginBetween = p1.Size.Size_300
		}
	end)
	local v21 = useStyle()
	local v22 = React.useRef(nil)

	return React.createElement("Frame", {
		BorderSizePixel = 1,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = t1.BackgroundTransparency,
		BackgroundColor3 = Color3.new(0.011764705882352941, 0.011764705882352941, 0.011764705882352941)
	}, {
		React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 1,
			Image = "rbxasset://textures/ui/Shell/ScreenAdjustment/Background.png",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(0.011764705882352941, 0.011764705882352941, 0.011764705882352941),
			Visible = t1.ImageVisible
		}),
		Title = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 230, 0, 205),
			Font = GlobalSettings.LightFont,
			FontSize = GlobalSettings.HeaderSize,
			TextColor3 = GlobalSettings.WhiteTextColor,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = LocalizedStrings:LocStringUA("Xbox.Old.ScreenSizeWord")
		}),
		Prompt = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 230, 0, 243),
			Font = GlobalSettings.RegularFont,
			FontSize = GlobalSettings.ButtonSize,
			TextColor3 = GlobalSettings.WhiteTextColor,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = LocalizedStrings:LocStringUA("Xbox.Old.ResizeScreenPrompt")
		}),
		Controller = React.createElement(ControllerHint),
		Actions = React.createElement("Frame", {
			Size = UDim2.fromScale(0.4, 0),
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, -201)
		}, { React.createElement(ButtonStack, {
			buttonHeight = v20.buttonHeight,
			marginBetween = v20.marginBetween,
			forcedFillDirection = Enum.FillDirection.Horizontal,
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						text = v19.cancel,
						fontStyle = v21.Font.Header1,
						onActivated = v18
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						text = v19.accept,
						fontStyle = v21.Font.Header1,
						onActivated = function() -- line: 108
							-- upvalues: v22 (copy)
							if v22.current then
								v22.current.onAccept()
							end
						end
					}
				}
			}
		}) }),
		EdgeSelector = React.createElement(Edges, {
			onSetEdges = v18,
			ref = v22
		})
	})
end

return Overscan
