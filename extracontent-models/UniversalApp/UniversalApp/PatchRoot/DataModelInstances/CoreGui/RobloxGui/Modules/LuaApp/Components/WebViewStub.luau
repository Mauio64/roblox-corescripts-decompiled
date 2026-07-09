local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local isRunningInStudio = require(CorePackages.Workspace.Packages.AppCommonLib).isRunningInStudio
local EngineFeature = game:GetEngineFeature("WebViewRedesignEnabled")

local function renderPage(t1: {[any]: any}, p1) -- line: 20
	-- upvalues: isRunningInStudio (copy), Roact (copy), TopBar (copy), EngineFeature (copy)
	local v11 = t1.isVisible or false

	if isRunningInStudio() then
		local BackgroundDefault = p1.Theme.BackgroundDefault

		return Roact.createElement("Frame", {
			Visible = v11,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = BackgroundDefault.Color,
			BackgroundTransparency = BackgroundDefault.Transparency
		}, {
			TopBar = Roact.createElement(TopBar.Container, {
				titleText = "WebViewStub",
				leftItem = TopBar.BackButton
			})
		})
	end

	local Overlay = p1.Theme.Overlay

	return Roact.createElement("TextButton", {
		Text = "",
		Active = false,
		AutoButtonColor = false,
		Selectable = false,
		Visible = v11,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = if not EngineFeature then Overlay.Color else p1.Theme.BackgroundDefault.Color,
		BackgroundTransparency = if not EngineFeature then Overlay.Transparency else 0
	})
end

return function(p2) -- line: 54
	-- upvalues: withStyle (copy), renderPage (copy)
	return withStyle(function(p3) -- line: 55
		-- upvalues: renderPage (copy), p2 (copy)
		return renderPage(p2, p3)
	end)
end
