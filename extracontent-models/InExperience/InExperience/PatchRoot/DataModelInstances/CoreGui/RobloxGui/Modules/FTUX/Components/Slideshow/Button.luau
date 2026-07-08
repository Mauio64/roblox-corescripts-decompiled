local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle
local ParentParent = script.Parent.Parent.Parent
local FTUXSlideshowData = require(ParentParent.Resources.FTUXSlideshowData)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization

require(ParentParent.Enums.PlatformEnum)

local ButtonEnum = require(ParentParent.Enums.ButtonEnum)

local function SlideshowButton(t1: {[any]: any}) -- line: 23
	-- upvalues: useStyle (copy), FTUXSlideshowData (copy), withLocalization (copy), ButtonType (copy), ButtonEnum (copy), React (copy), Button (copy)
	local Font = useStyle().Font
	local v14 = FTUXSlideshowData[t1.platform]
	local currentIndex = t1.currentIndex
	local increaseCurrentIndex = t1.increaseCurrentIndex
	local button = v14[currentIndex].button

	return withLocalization({
		skip = "CoreScripts.VRFTUX.Action.Skip",
		next = "CoreScripts.VRFTUX.Action.Next"
	})(function(p1) -- line: 36
		-- upvalues: ButtonType (copy), button (copy), ButtonEnum (copy), React (copy), Button (copy), Font (copy), increaseCurrentIndex (copy)
		local Secondary = ButtonType.Secondary
		local skip = p1.skip

		if button == ButtonEnum.NextButton then
			Secondary = ButtonType.PrimaryContextual
			skip = p1.next
		end

		return React.createElement(Button, {
			layoutOrder = 4,
			buttonType = Secondary,
			text = skip,
			fontStyle = Font.Body,
			size = UDim2.new(1, 0, 0.6, 0),
			onActivated = increaseCurrentIndex
		})
	end)
end

return SlideshowButton
