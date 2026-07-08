local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local ParentParent = script.Parent.Parent.Parent
local FTUXSlideshowData = require(ParentParent.Resources.FTUXSlideshowData)
local Button = require(ParentParent.Components.Slideshow.Button)

require(ParentParent.Enums.PlatformEnum)

local function EndItem(t1: {[any]: any}) -- line: 21
	-- upvalues: useStyle (copy), FTUXSlideshowData (copy), withLocalization (copy), React (copy), Button (copy), UIBlox (copy)
	local v11 = useStyle()
	local Theme = v11.Theme
	local Font = v11.Font
	local v14 = FTUXSlideshowData[t1.platform]

	return withLocalization({
		footerText = "CoreScripts.VRFTUX.Label.Footer"
	})(function(p1) -- line: 31
		-- upvalues: t1 (copy), v14 (copy), React (copy), Button (copy), UIBlox (copy), Font (copy), Theme (copy)
		return t1.currentIndex ~= #v14 and React.createElement(Button, {
			platform = t1.platform,
			currentIndex = t1.currentIndex,
			increaseCurrentIndex = t1.increaseCurrentIndex
		}) or React.createElement(UIBlox.App.Text.StyledTextLabel, {
			layoutOrder = 2,
			text = p1.footerText,
			fontStyle = Font.CaptionHeader,
			colorStyle = Theme.TextEmphasis,
			textXAlignment = Enum.TextXAlignment.Center,
			textYAlignment = Enum.TextYAlignment.Center,
			size = UDim2.new(1, 0, 1, 0)
		})
	end)
end

return EndItem
