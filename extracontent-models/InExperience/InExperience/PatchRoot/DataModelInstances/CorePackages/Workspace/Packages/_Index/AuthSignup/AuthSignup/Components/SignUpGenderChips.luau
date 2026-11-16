local parent = script:FindFirstAncestor("AuthSignup").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AuthCommon = require(parent.AuthCommon)
local UserGender = AuthCommon.Enums.UserGender
local formatBoldRichText = AuthCommon.Utils.formatBoldRichText

local View = Foundation.View
local Chip = Foundation.Chip
local InputLabel = Foundation.InputLabel
local InputLabelSize = Foundation.Enums.InputLabelSize
local ChipSize = Foundation.Enums.ChipSize
local IconName = Foundation.Enums.IconName

local function SignUpGenderChips(props)
	local onGenderSelected = props.onGenderSelected

	local createElement = React.createElement
	local v = { tag = "col gap-small size-full-0 auto-y", LayoutOrder = props.LayoutOrder }

	local createElement2 = React.createElement
	local text

	if props.isLabelBold then
		text = formatBoldRichText(props.label)
	else
		text = props.label
	end

	return createElement(View, v, {
		Label = createElement2(InputLabel, {
			Text = text,
			RichText = props.isLabelBold,
			size = InputLabelSize.Medium,
			LayoutOrder = 1
		}),
		Options = React.createElement(View, { tag = "row gap-small auto-xy", LayoutOrder = 2 }, {
			Female = React.createElement(Chip, {
				text = props.femaleText,
				leading = IconName.HeadFemale,
				size = ChipSize.Large,
				isChecked = props.gender == UserGender.Female,
				onActivated = function()
					onGenderSelected(UserGender.Female)
				end,
				LayoutOrder = 1,
				testId = "--auth-signup-gender-female"
			}),
			Male = React.createElement(Chip, {
				text = props.maleText,
				leading = IconName.HeadMale,
				size = ChipSize.Large,
				isChecked = props.gender == UserGender.Male,
				onActivated = function()
					onGenderSelected(UserGender.Male)
				end,
				LayoutOrder = 2,
				testId = "--auth-signup-gender-male"
			})
		})
	})
end

return SignUpGenderChips
