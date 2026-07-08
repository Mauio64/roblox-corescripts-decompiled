local CorePackages = game:GetService("CorePackages")
local StarterPlayer = game:GetService("StarterPlayer")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local v8 = Roact.PureComponent:extend("WheelText")

function v8.getWheelText(p1) -- line: 15
	-- upvalues: StarterPlayer (copy), RobloxTranslator (copy), Constants (copy)
	local currentEmotes = p1.props.emotesPage.currentEmotes
	local locale = p1.props.locale
	local numberEmotesLoaded = p1.props.emotesPage.numberEmotesLoaded

	if next(currentEmotes) == nil then
		if StarterPlayer.UserEmotesEnabled and numberEmotesLoaded == 0 then
			return RobloxTranslator:FormatByKeyForLocale(Constants.LocalizationKeys.NoEmotesEquipped, locale)
		end

		return RobloxTranslator:FormatByKeyForLocale(Constants.LocalizationKeys.EmotesDisabled, locale)
	end

	local v14 = currentEmotes[p1.props.emotesWheel.focusedSegmentIndex]

	if v14 then
		return v14
	end

	return RobloxTranslator:FormatByKeyForLocale(Constants.LocalizationKeys.SelectAnEmote, locale)
end
function v8.render(p2) -- line: 38
	-- upvalues: Constants (copy), Roact (copy)
	local v16 = Constants.Layouts[p2.props.layout]
	local v17 = p2:getWheelText()

	return Roact.createElement("TextLabel", {
		BackgroundTransparency = 1,
		TextScaled = true,
		ZIndex = 5,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(Constants.InnerCircleSizeRatio, -Constants.TextPadding, Constants.InnerCircleSizeRatio, -Constants.TextPadding),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Text = v17,
		TextSize = v16.MiddleTextSize,
		TextColor3 = Constants.Colors.White,
		Font = v16.MiddleTextFont
	}, {
		TextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
			MaxTextSize = v16.MiddleTextSize
		})
	})
end

local function mapStateToProps(p3) -- line: 65
	return {
		emotesWheel = p3.emotesWheel,
		emotesPage = p3.emotesPage,
		layout = p3.layout,
		locale = p3.locale
	}
end

return RoactRodux.connect(mapStateToProps, nil)(v8)
