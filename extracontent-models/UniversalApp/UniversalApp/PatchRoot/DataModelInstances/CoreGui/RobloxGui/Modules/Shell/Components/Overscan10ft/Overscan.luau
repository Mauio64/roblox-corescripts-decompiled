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
local FFlagAppShellMigrateLocales = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAppShellMigrateLocales
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local ControllerHint = require(Modules.Shell.Components.Overscan.ControllerHint)
local Edges = require(script.Parent.Edges)

local function Overscan(t1: {[any]: any}) -- line: 28
	-- upvalues: useNavigation (copy), useLocalization (copy), useDesignTokens (copy), useStyle (copy), React (copy), GlobalSettings (copy), FFlagAppShellMigrateLocales (copy), LocalizedStrings (copy), ControllerHint (copy), ButtonStack (copy), ButtonType (copy), Edges (copy)
	local v18 = useNavigation()
	local v19 = t1.onUnmount or v18.goBack
	local v20 = useLocalization({
		accept = "CommonUI.Controls.Action.Accept",
		cancel = "CommonUI.Controls.Action.Cancel"
	})
	local v21 = useDesignTokens(function(p1) -- line: 38
		return {
			buttonHeight = p1.Size.Size_1200,
			marginBetween = p1.Size.Size_300
		}
	end)
	local v22 = useStyle()
	local v23 = React.useRef(nil)

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
			Text = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ScreenSizeWord") else LocalizedStrings:LocStringUA("Xbox.Old.ScreenSizeWord")
		}),
		Prompt = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 230, 0, 243),
			Font = GlobalSettings.RegularFont,
			FontSize = GlobalSettings.ButtonSize,
			TextColor3 = GlobalSettings.WhiteTextColor,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = if not FFlagAppShellMigrateLocales then LocalizedStrings:LocalizedString("ResizeScreenPrompt") else LocalizedStrings:LocStringUA("Xbox.Old.ResizeScreenPrompt")
		}),
		Controller = React.createElement(ControllerHint),
		Actions = React.createElement("Frame", {
			Size = UDim2.fromScale(0.4, 0),
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, -201)
		}, { React.createElement(ButtonStack, {
			buttonHeight = v21.buttonHeight,
			marginBetween = v21.marginBetween,
			forcedFillDirection = Enum.FillDirection.Horizontal,
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						text = v20.cancel,
						fontStyle = v22.Font.Header1,
						onActivated = v19
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						text = v20.accept,
						fontStyle = v22.Font.Header1,
						onActivated = function() -- line: 113
							-- upvalues: v23 (copy)
							if v23.current then
								v23.current.onAccept()
							end
						end
					}
				}
			}
		}) }),
		EdgeSelector = React.createElement(Edges, {
			onSetEdges = v19,
			ref = v23
		})
	})
end

return Overscan
