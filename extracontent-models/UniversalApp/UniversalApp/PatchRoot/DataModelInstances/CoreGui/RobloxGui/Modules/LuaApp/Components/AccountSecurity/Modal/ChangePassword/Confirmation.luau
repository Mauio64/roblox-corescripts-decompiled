local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local Lock = require(Modules.LuaApp.Components.AccountSecurity.Common.Lock)
local ModalBase = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalBase)
local ModalBodyText = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalBodyText)
local withLocalization = require(Modules.LuaApp.withLocalization)
local t1 = {
	description = "Feature.AccountSecurityPrompt.Description.ChangeYourPasswordSuccess",
	header = "Feature.AccountSecurityPrompt.Header.Success"
}
local v9 = Roact.PureComponent:extend("ChangePassword" .. script.Name)

function v9.render(_) -- line: 19
	-- upvalues: withLocalization (copy), t1 (copy), Roact (copy), ModalBase (copy), Lock (copy), ModalBodyText (copy)
	return withLocalization(t1)(function(p2) -- line: 20
		-- upvalues: Roact (copy), ModalBase (copy), Lock (copy), ModalBodyText (copy)
		return Roact.createElement(ModalBase, {
			title = p2.header,
			makeBodyFragment = function(p3) -- line: 23
				-- upvalues: Roact (copy), Lock (copy), ModalBodyText (copy), p2 (copy)
				return Roact.createFragment({
					Lock = Roact.createElement(Lock, {
						layoutOrder = 1
					}),
					ModalBodyText = Roact.createElement(ModalBodyText, {
						layoutOrder = 2,
						contentWidth = p3,
						text = p2.description
					})
				})
			end
		})
	end)
end

return v9
