local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local ParentParent = script.Parent.Parent.Parent
local FTUXSlideshowData = require(ParentParent.Resources.FTUXSlideshowData)

require(ParentParent.Enums.PlatformEnum)

local function Title(t1: {[any]: any}) -- line: 19
	-- upvalues: useStyle (copy), FTUXSlideshowData (copy), withLocalization (copy), React (copy), UIBlox (copy)
	local v10 = useStyle()
	local Theme = v10.Theme
	local Font = v10.Font
	local title = FTUXSlideshowData[t1.platform][t1.currentIndex].title

	return withLocalization({
		titleText = title
	})(function(p1) -- line: 30
		-- upvalues: React (copy), UIBlox (copy), Font (copy), Theme (copy)
		return React.createElement(UIBlox.App.Text.StyledTextLabel, {
			layoutOrder = 1,
			text = p1.titleText,
			fontStyle = Font.SubHeader1,
			colorStyle = Theme.TextEmphasis,
			textXAlignment = Enum.TextXAlignment.Left,
			size = UDim2.new(1, 0, 0.031, 0)
		})
	end)
end

return Title
