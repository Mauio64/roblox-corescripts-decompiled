local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AlertWindow = require(Modules.LuaApp.Components.AlertWindow)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local withLocalization = require(Modules.LuaApp.withLocalization)
local withStyle = UIBlox.Style.withStyle
local t = require(CorePackages.Packages.t)
local v11 = Roact.PureComponent:extend("PurchaseDeveloperProductSuccessPrompt")

v11.validateProps = t.strictInterface({
	productName = t.string,
	containerWidth = t.number,
	defaultChildRef = t.optional(t.any),
	focusController = t.optional(t.any),
	closeCentralOverlayThunk = t.optional(t.callback),
	closePrompt = t.callback
})

function v11.render(p1) -- line: 28
	-- upvalues: withStyle (copy), withLocalization (copy), Roact (copy), AlertWindow (copy)
	local containerWidth = p1.props.containerWidth
	local closePrompt = p1.props.closePrompt
	local productName = p1.props.productName

	return withStyle(function(p2) -- line: 33
		-- upvalues: withLocalization (copy), productName (copy), Roact (copy), AlertWindow (copy), containerWidth (copy), closePrompt (copy)
		return withLocalization({
			titleText = "Feature.DeveloperProducts.Heading.Success",
			buttonText = "Feature.DeveloperProducts.Message.BackToStore",
			messageText = {
				"Feature.DeveloperProducts.Message.PurchaseSucceed",
				productName = productName
			}
		})(function(p3) -- line: 38
			-- upvalues: Roact (copy), AlertWindow (copy), containerWidth (copy), p2 (copy), closePrompt (copy)
			return Roact.createElement(AlertWindow, {
				isConfirming = false,
				hasCancelButton = false,
				containerWidth = containerWidth,
				titleText = p3.titleText,
				titleFont = p2.Font.Header1.Font,
				messageText = p3.messageText,
				messageFont = p2.Font.Body.Font,
				buttonFont = p2.Font.Header2.Font,
				confirmButtonText = p3.buttonText,
				onConfirm = closePrompt
			})
		end)
	end)
end

return (RoactRodux.connect(nil, function(p4) -- line: 55
	-- upvalues: CloseCentralOverlay (copy)
	return {
		closePrompt = function() -- line: 57
			-- upvalues: p4 (copy), CloseCentralOverlay (copy)
			p4(CloseCentralOverlay())
		end
	}
end)(v11))
