local CorePackages = game:GetService("CorePackages")

local Foundation = require(CorePackages.Packages.Foundation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local withStyle = UIBlox.Style.withStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local backToTopClickEvent = require("@luauforge/bundled/dwD").Events.backToTopClickEvent

local module = require("@luauforge/bundled/ecR")
local module2 = require("@luauforge/bundled/edA")

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
		local v10 = {}
		v10.Size = UDim2.new(0.5, 0, 0, 30)
		v10.Position = UDim2.new(0.25, 0, 0, 20)
		v10.BackgroundTransparency = 1
		v10.BorderSizePixel = 0
		v10.Text = "Feature.GamePage.Action.BackToTop"
		local v11 = if not foundationFontFaceMigration then props.Font.Body.Font else nil
		v10.Font = v11

		local v12 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
		v10.FontFace = v12

		v10.TextSize = props.Font.BaseSize * props.Font.Body.RelativeSize
		v10.TextColor3 = props.Theme.TextEmphasis.Color
		v10.TextTransparency = props.Theme.TextEmphasis.Transparency
		v10.TextXAlignment = Enum.TextXAlignment.Center
		v10.TextYAlignment = Enum.TextYAlignment.Center
		local activated = module.Event.Activated
		v10[activated] = if fFlagLuaAppSupportHomeBackToTop then fn else backToTopCallback
		v10.SelectionImageObject = v5
		return createElement("Frame", v7, {
			BackToTopButton = createElement2(module2, v10)
		})
	end)
end

return EndOfScroll
