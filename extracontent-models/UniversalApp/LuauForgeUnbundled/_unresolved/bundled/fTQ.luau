local module = require("@luauforge/bundled/dwL")
local module2 = require("@luauforge/bundled/edO")
local module3 = require("@luauforge/bundled/edP")
local birthday = require("@game/CorePackages/Workspace/Packages/AuthCommon").Models.Birthday

return function(p2)
	return function(object)
		module.isType(
			p2.onClose,
			"function",
			"props.onClose passed down to OpenCentralOverlayForSignUpBirthdayPicker"
		)

		if p2.initialBirthday then
			module.assert(
				birthday.is(p2.initialBirthday),
				"props.initialBirthday passed down to OpenCentralOverlayForSignUpBirthdayPicker"
			)
		end

		object:dispatch(module3(module2.SignUpBirthdayPickerOverlay, p2))
	end
end
