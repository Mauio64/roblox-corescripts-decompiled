local CorePackages = game:GetService("CorePackages")

local Foundation = require(CorePackages.Packages.Foundation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local withStyle = UIBlox.Style.withStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local backToTopClickEvent = require("@luauforge/bundled/dzG").Events.backToTopClickEvent

local module = require("@luauforge/bundled/ego")
local module2 = require("@luauforge/bundled/egX")

local fFlagLuaAppSupportHomeBackToTop = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSupportHomeBackToTop

local function EndOfScroll(data)
	local backToTopCallback = data.backToTopCallback
	local layoutOrder = data.LayoutOrder
	local v5 = useSelectionCursor(cursorKind.RoundedRect)

	local bottomPadding = data.bottomPadding or 0

	local fn = fFlagLuaAppSupportHomeBackToTop and function()
		if backToTopCallback then
			backToTopCallback()

			backToTopClickEvent(data.pageContext)
		end
	end or nil

	return withStyle(function(props)
		local createElement = module.createElement
		local v7 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 70 + bottomPadding),
			LayoutOrder = layoutOrder
		}

		local createElement2 = module.createElement
		local v10 = {
			["Size"] = UDim2.new(0.5, 0, 0, 30),
			Position = UDim2.new(0.25, 0, 0, 20),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "Feature.GamePage.Action.BackToTop",
			FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
			TextSize = props.Font.BaseSize * props.Font.Body.RelativeSize,
			TextColor3 = props.Theme.TextEmphasis.Color,
			TextTransparency = props.Theme.TextEmphasis.Transparency,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		}
		local activated = module.Event.Activated
		v10[activated] = if fFlagLuaAppSupportHomeBackToTop then fn else backToTopCallback
		v10.SelectionImageObject = v5
		return createElement("Frame", v7, {
			BackToTopButton = createElement2(module2, v10)
		})
	end)
end

return EndOfScroll
