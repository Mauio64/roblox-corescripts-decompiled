local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local ReportConfirmationContainer = require(script.Parent.ReportConfirmationContainer)
local renderWithCoreScriptsStyleProvider = require(script.Parent.Parent.Parent.Parent.Common.renderWithCoreScriptsStyleProvider)
local v6 = Roact.PureComponent:extend("ReportConfirmationScreen")

v6.validateProps = t.interface({
	closeMenu = t.callback,
	player = t.interface({
		DisplayName = t.string,
		Name = t.string,
		UserId = t.number
	})
})

function v6.render(p1) -- line: 21
	-- upvalues: renderWithCoreScriptsStyleProvider (copy), Roact (copy), ReportConfirmationContainer (copy)
	return renderWithCoreScriptsStyleProvider({
		reportConfirmationContainer = Roact.createElement(ReportConfirmationContainer, p1.props)
	})
end

return v6
