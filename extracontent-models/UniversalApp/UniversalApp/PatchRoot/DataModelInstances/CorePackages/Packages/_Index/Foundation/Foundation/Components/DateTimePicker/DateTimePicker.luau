local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local DateTimePickerBeta = require(script.Parent.DateTimePickerBeta)
require(script.Parent.DateTimePickerProps)
local DateTimePickerVariant = require(Foundation.Enums.DateTimePickerVariant)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = { variant = DateTimePickerVariant.Single, testId = "--foundation-date-time-picker" }

local function DateTimePicker(p)
	return React.createElement(DateTimePickerBeta, withDefaults(p, v))
end

return React.memo(DateTimePicker)
