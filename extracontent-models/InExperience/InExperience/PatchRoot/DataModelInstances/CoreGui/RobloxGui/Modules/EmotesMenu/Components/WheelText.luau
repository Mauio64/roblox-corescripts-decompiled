local CorePackages = game:GetService("CorePackages")
local StarterPlayer = game:GetService("StarterPlayer")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local parent = script.Parent.Parent

local Constants = require(parent.Constants)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local FFlagFixEmotesMenuAvailability = require(parent.Flags.FFlagFixEmotesMenuAvailability)

local extended = Roact.PureComponent:extend("WheelText")

function extended:getWheelText()
	local currentEmotes = self.props.emotesPage.currentEmotes
	local locale = self.props.locale
	local numberEmotesLoaded = self.props.emotesPage.numberEmotesLoaded

	if next(currentEmotes) == nil then
		if StarterPlayer.UserEmotesEnabled and (FFlagFixEmotesMenuAvailability or numberEmotesLoaded == 0) then
			return RobloxTranslator:FormatByKeyForLocale(Constants.LocalizationKeys.NoEmotesEquipped, locale)
		end

		return RobloxTranslator:FormatByKeyForLocale(Constants.LocalizationKeys.EmotesDisabled, locale)
	else
		local currentEmote = currentEmotes[self.props.emotesWheel.focusedSegmentIndex]

		if currentEmote then
			return currentEmote
		end

		return RobloxTranslator:FormatByKeyForLocale(Constants.LocalizationKeys.SelectAnEmote, locale)
	end
end

function extended:render()
	local layout = Constants.Layouts[self.props.layout]
	local wheelText = self:getWheelText()

	return Roact.createElement("TextLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(
			Constants.InnerCircleSizeRatio,
			-Constants.TextPadding,
			Constants.InnerCircleSizeRatio,
			-Constants.TextPadding
		),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundTransparency = 1,
		Text = wheelText,
		TextScaled = true,
		TextSize = layout.MiddleTextSize,
		TextColor3 = Constants.Colors.White,
		Font = layout.MiddleTextFont,
		ZIndex = 5
	}, {
		TextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
			MaxTextSize = layout.MiddleTextSize
		})
	})
end

local function mapStateToProps(data)
	return {
		emotesWheel = data.emotesWheel,
		emotesPage = data.emotesPage,
		layout = data.layout,
		locale = data.locale
	}
end

return RoactRodux.connect(mapStateToProps, nil)(extended)
