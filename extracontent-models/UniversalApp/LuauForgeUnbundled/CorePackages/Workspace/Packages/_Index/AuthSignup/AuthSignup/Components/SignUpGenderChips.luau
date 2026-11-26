local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Foundation")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/AuthCommon")
local userGender = AuthCommon.Enums.UserGender
local formatBoldRichText = AuthCommon.Utils.formatBoldRichText

local view = Foundation.View
local chip = Foundation.Chip
local inputLabel = Foundation.InputLabel
local inputLabelSize = Foundation.Enums.InputLabelSize
local chipSize = Foundation.Enums.ChipSize
local iconName = Foundation.Enums.IconName

local function SignUpGenderChips(props)
	local onGenderSelected = props.onGenderSelected

	local createElement = React.createElement
	local v6 = {
		tag = "col gap-small size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement
	local v9 = if props.isLabelBold then formatBoldRichText(props.label) else props.label
	return createElement(view, v6, {
		Label = createElement2(inputLabel, {
			Text = v9,
			RichText = props.isLabelBold,
			size = inputLabelSize.Medium,
			LayoutOrder = 1
		}),
		Options = React.createElement(view, {
			tag = "row gap-small auto-xy",
			LayoutOrder = 2
		}, {
			Female = React.createElement(chip, {
				text = props.femaleText,
				leading = iconName.HeadFemale,
				size = chipSize.Large,
				isChecked = props.gender == userGender.Female,
				onActivated = function()
					onGenderSelected(userGender.Female)
				end,
				LayoutOrder = 1,
				testId = "--auth-signup-gender-female"
			}),
			Male = React.createElement(chip, {
				text = props.maleText,
				leading = iconName.HeadMale,
				size = chipSize.Large,
				isChecked = props.gender == userGender.Male,
				onActivated = function()
					onGenderSelected(userGender.Male)
				end,
				LayoutOrder = 2,
				testId = "--auth-signup-gender-male"
			})
		})
	})
end

return SignUpGenderChips
