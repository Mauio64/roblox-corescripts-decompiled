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
	makeStatusPanelProps = function(p1) -- line: 37
		local t1 = {
			status = "",
			statusText = "",
			queuePosition = nil,
			queueTreatment = nil,
			followUserId = 0,
			isSubjectToChinaPolicies = false,
			onAutoJoinNewServer = function() -- line: 45
			end,
			onJoinNewServer = function() -- line: 46
			end,
			onJoinTheLine = function() -- line: 47
			end,
			onShowConnectionHealth = function() -- line: 48
			end
		}

		if p1 then
			for v9, v10 in p1 do
				t1[v9] = v10
			end
		end

		return t1
	end,
	renderWithFoundation = function(p2: ((...any) -> ...any), p3) -- line: 58
		-- upvalues: React (copy), Foundation (copy), Localization (copy), InExperienceLocales (copy), LocalizationService (copy)
		return p2(React.createElement(Foundation.FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark
		}, {
			Localization = React.createElement(Localization.LocalizationProvider, {
				localization = InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
			}, {
				Subject = p3
			})
		}))
	end
}
