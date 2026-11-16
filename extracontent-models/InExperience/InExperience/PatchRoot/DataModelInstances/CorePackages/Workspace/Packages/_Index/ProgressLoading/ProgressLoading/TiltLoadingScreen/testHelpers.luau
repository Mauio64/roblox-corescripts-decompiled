local parent = script:FindFirstAncestor("ProgressLoading").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local InExperienceLocales = require(parent.InExperienceLocales)

local LocalizationService = game:GetService("LocalizationService")
local TestHelpers = {}

function TestHelpers.makeAnimationBindings()
	return {
		keyart = {
			rotation = React.createBinding(15),
			sizeScale = React.createBinding(1),
			coverTransparency = React.createBinding(1)
		},
		frame = {
			rotation = React.createBinding(-15),
			sizeScale = React.createBinding(1),
			groupTransparency = React.createBinding(0)
		},
		title = {
			reveal = React.createBinding(1),
			slide = React.createBinding(UDim.new(0, 0))
		},
		creator = {
			reveal = React.createBinding(1),
			slide = React.createBinding(UDim.new(0, 0))
		},
		verified = { reveal = React.createBinding(1) }
	}
end

function TestHelpers.makeStatusPanelProps(items)
	local statusPanelProps = {
		status = "",
		statusText = "",
		queuePosition = nil,
		queueTreatment = nil,
		followUserId = 0,
		isSubjectToChinaPolicies = false,
		onAutoJoinNewServer = function() end,
		onJoinNewServer = function() end,
		onJoinTheLine = function() end,
		onShowConnectionHealth = function() end
	}

	if items then
		for k, item in items do
			statusPanelProps[k] = item
		end
	end

	return statusPanelProps
end

function TestHelpers.renderWithFoundation(callback, subject)
	return callback(React.createElement(
		Foundation.FoundationProvider,
		{ colorMode = Foundation.Enums.ColorMode.Dark },
		{
			Localization = React.createElement(
				Localization.LocalizationProvider,
				{
					localization = InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
				},
				{ Subject = subject }
			)
		}
	))
end

return TestHelpers
