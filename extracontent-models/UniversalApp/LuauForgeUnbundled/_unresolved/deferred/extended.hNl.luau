local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)

local module = require("@luauforge/deferred/hNc")
local module2 = require("@luauforge/deferred/hNd")
local module3 = require("@luauforge/deferred/hNe")
local module4 = require("@luauforge/bundled/edC")

local v5 = {
	description = "Feature.AccountSecurityPrompt.Description.ChangeYourPasswordSuccess",
	header = "Feature.AccountSecurityPrompt.Header.Success"
}

local extended = Roact.PureComponent:extend("ChangePasswordConfirmation")

function extended.render(p2)
	return module4(v5)(function(p3)
		return Roact.createElement(module2, {
			title = p3.header,
			makeBodyFragment = function(p4)
				return Roact.createFragment({
					Lock = Roact.createElement(module, { layoutOrder = 1 }),
					ModalBodyText = Roact.createElement(module3, {
						layoutOrder = 2,
						contentWidth = p4,
						text = p3.description
					})
				})
			end
		})
	end)
end

return extended
