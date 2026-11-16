local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle

local parent = script.Parent.Parent.Parent
local FTUXSlideshowData = require(parent.Resources.FTUXSlideshowData)
local Localization = require(CorePackages.Workspace.Packages.Localization)
local withLocalization = Localization.withLocalization

require(parent.Enums.PlatformEnum)
local ButtonEnum = require(parent.Enums.ButtonEnum)

local function SlideshowButton(data)
	local font = useStyle().Font

	local v = FTUXSlideshowData[data.platform]
	local currentIndex = data.currentIndex
	local increaseCurrentIndex = data.increaseCurrentIndex
	local button2 = v[currentIndex].button

	return withLocalization({
		skip = "CoreScripts.VRFTUX.Action.Skip",
		next = "CoreScripts.VRFTUX.Action.Next"
	})(function(p)
		local buttonType = ButtonType.Secondary
		local text = p.skip

		if button2 == ButtonEnum.NextButton then
			buttonType = ButtonType.PrimaryContextual
			text = p.next
		end

		return React.createElement(button, {
			buttonType = buttonType,
			text = text,
			fontStyle = font.Body,
			layoutOrder = 4,
			size = UDim2.new(1, 0, 0.6, 0),
			onActivated = increaseCurrentIndex
		})
	end)
end

return SlideshowButton
