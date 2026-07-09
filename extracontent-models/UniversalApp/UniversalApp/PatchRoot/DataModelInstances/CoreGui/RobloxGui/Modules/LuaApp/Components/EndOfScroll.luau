local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Roact = require(Modules.Common.Roact)
local LocalizedTextButton = require(Modules.LuaApp.Components.LocalizedTextButton)

local function EndOfScroll(p1) -- line: 18
	-- upvalues: useSelectionCursor (copy), CursorKind (copy), withStyle (copy), Roact (copy), LocalizedTextButton (copy)
	local backToTopCallback = p1.backToTopCallback
	local p1LayoutOrder = p1.LayoutOrder
	local v13 = useSelectionCursor(CursorKind.RoundedRect)
	local v14 = p1.bottomPadding or 0

	return withStyle(function(p2) -- line: 25
		-- upvalues: Roact (copy), v14 (copy), p1LayoutOrder (copy), LocalizedTextButton (copy), backToTopCallback (copy), v13 (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 70 + v14),
			LayoutOrder = p1LayoutOrder
		}, {
			BackToTopButton = Roact.createElement(LocalizedTextButton, {
				Size = UDim2.new(0.5, 0, 0, 30),
				Position = UDim2.new(0.25, 0, 0, 20),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = "Feature.GamePage.Action.BackToTop",
				Font = p2.Font.Body.Font,
				TextSize = p2.Font.BaseSize * p2.Font.Body.RelativeSize,
				TextColor3 = p2.Theme.TextEmphasis.Color,
				TextTransparency = p2.Theme.TextEmphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				[Roact.Event.Activated] = backToTopCallback,
				SelectionImageObject = v13
			})
		})
	end)
end

return EndOfScroll
