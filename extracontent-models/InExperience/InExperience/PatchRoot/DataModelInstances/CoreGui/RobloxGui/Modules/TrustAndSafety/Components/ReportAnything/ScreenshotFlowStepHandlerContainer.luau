local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local ScreenshotFlowStepHandler = require(script.Parent.ScreenshotFlowStepHandler)
local renderWithCoreScriptsStyleProvider = require(script.Parent.Parent.Parent.Parent.Common.renderWithCoreScriptsStyleProvider)
local v5 = Roact.PureComponent:extend("ScreenshotFlowStepHandlerContainer")

function v5.render(p1) -- line: 13
	-- upvalues: renderWithCoreScriptsStyleProvider (copy), Roact (copy), ScreenshotFlowStepHandler (copy)
	return renderWithCoreScriptsStyleProvider({
		ScreenshotFlowStepHandlerContainer = Roact.createElement(ScreenshotFlowStepHandler, p1.props)
	})
end

return v5
