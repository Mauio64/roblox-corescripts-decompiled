local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle

local module = require("@luauforge/bundled/fox")
local isRunningInStudio = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isRunningInStudio

local engineFeature = game:GetEngineFeature("WebViewRedesignEnabled")
local engineFeature2 = game:GetEngineFeature("GuiObjectInputSink")

local function renderPage(p2, p3)
	local isVisible = p2.isVisible or false

	if isRunningInStudio() then
		local backgroundDefault = p3.Theme.BackgroundDefault
		return Roact.createElement(
			"Frame",
			{
				Visible = isVisible,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = backgroundDefault.Color,
				BackgroundTransparency = backgroundDefault.Transparency
			},
			{
				TopBar = Roact.createElement(module.Container, {
					titleText = "WebViewStub",
					leftItem = module.BackButton
				})
			}
		)
	end

	if engineFeature2 then
		local overlay = p3.Theme.Overlay

		local createElement = Roact.createElement
		local v6 = {
			Visible = isVisible,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = 0,
			BackgroundTransparency = 0,
			InputSink = 0
		}

		local v7 = if engineFeature then p3.Theme.BackgroundDefault.Color else overlay.Color
		v6.BackgroundColor3 = v7

		v6.BackgroundTransparency = engineFeature and 0 or overlay.Transparency
		v6.InputSink = Enum.InputSink.Activate
		return createElement("Frame", v6)
	else
		local overlay = p3.Theme.Overlay

		local createElement = Roact.createElement
		local v6 = {
			Visible = isVisible,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = 0,
			BackgroundTransparency = 0,
			Text = "",
			Active = false,
			AutoButtonColor = false,
			Selectable = false
		}

		local v7 = if engineFeature then p3.Theme.BackgroundDefault.Color else overlay.Color
		v6.BackgroundColor3 = v7

		v6.BackgroundTransparency = engineFeature and 0 or overlay.Transparency
		return createElement("TextButton", v6)
	end
end

return function(p2)
	return withStyle(function(p3)
		return renderPage(p2, p3)
	end)
end
