local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Constants = require(Modules.LuaApp.Constants)
local getScreenBottomInset = require(Modules.LuaApp.getScreenBottomInset)
local AppPage = require(Modules.LuaApp.AppPage)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v15 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

return function(t1: {[any]: any}) -- line: 31
	-- upvalues: useDispatch (copy), useLocalization (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), NavigateDown (copy), useStyle (copy), getScreenBottomInset (copy), React (copy), PartialPageModal (copy), ButtonType (copy), Constants (copy)
	local v17 = useDispatch()
	local v18 = useLocalization({
		LearnMoreText = "Feature.LocaleRestriction.Label.LearnMore",
		TitleText = "Feature.LocaleRestriction.Title.RobloxUnavailable",
		BodyText = "Feature.LocaleRestriction.Description.RobloxUnavailable"
	})

	local function openBrowser() -- line: 40
		-- upvalues: AppPage (copy), v18 (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), v17 (copy), NavigateDown (copy)
		local t2 = {
			detail = "https://en.help.roblox.com/hc/articles/360000313606",
			name = AppPage.GenericWebPage,
			extraProps = {
				title = v18.TitleText
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v15.down(v15.fromLegacyPage(t2))

			return
		end

		v17(NavigateDown(t2))
	end

	local screenSize = t1.screenSize
	local v21 = useStyle()
	local Theme = v21.Theme
	local Font = v21.Font
	local globalGuiInset = t1.globalGuiInset

	globalGuiInset.bottom = getScreenBottomInset()

	local uDim2 = UDim2.fromOffset(0, globalGuiInset.top)
	local uDim2_2 = UDim2.fromOffset(screenSize.X, screenSize.Y - globalGuiInset.top - globalGuiInset.bottom)
	local v27 = React.createElement(PartialPageModal, {
		buttonHeight = 48,
		title = v18.TitleText,
		screenSize = screenSize,
		buttonStackProps = {
			buttons = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					isDisabled = false,
					onActivated = openBrowser,
					text = v18.LearnMoreText
				}
			}}
		}
	}, {
		Body = React.createElement("Frame", {
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 60),
			BackgroundColor3 = Theme.BackgroundUIDefault.Color
		}, {
			CustomInner = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextScaled = true,
				Text = v18.BodyText,
				TextColor3 = Theme.TextDefault.Color,
				TextXAlignment = Enum.TextXAlignment.Center,
				Font = Font.Body.Font,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				UITextSizeConstraint = React.createElement("UITextSizeConstraint", {
					MaxTextSize = Font.BaseSize * Font.Body.RelativeSize
				})
			})
		})
	})

	return React.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = Constants.DisplayOrder.AntiAddictionPrompt
	}, {
		OverlayFrame = React.createElement("ImageButton", {
			AutoButtonColor = false,
			ImageTransparency = 1,
			BorderSizePixel = 0,
			Selectable = false,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Theme.Overlay.Color,
			BackgroundTransparency = Theme.Overlay.Transparency
		}, {
			Overlay = React.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Position = uDim2,
				Size = uDim2_2
			}, {
				Content = v27
			})
		})
	})
end
