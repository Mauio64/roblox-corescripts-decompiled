local Parent = script:FindFirstAncestor("ProgressLoading").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.Localization)
local InExperienceLocales = require(Parent.InExperienceLocales)
local LocalizationService = game:GetService("LocalizationService")

return {
	makeAnimationBindings = function() -- line: 11
		-- upvalues: React (copy)
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
			verified = {
				reveal = React.createBinding(1)
			}
		}
	end,
	renderWithFoundation = function(p1: ((...any) -> ...any), p2) -- line: 37
		-- upvalues: React (copy), Foundation (copy), Localization (copy), InExperienceLocales (copy), LocalizationService (copy)
		return p1(React.createElement(Foundation.FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark
		}, {
			Localization = React.createElement(Localization.LocalizationProvider, {
				localization = InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
			}, {
				Subject = p2
			})
		}))
	end
}
