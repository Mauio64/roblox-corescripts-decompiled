local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local module = require("@luauforge/deferred/hWp")
local module2 = require("@luauforge/bundled/fCM")
local module3 = require("@luauforge/deferred/hXw")
local module4 = require("@luauforge/bundled/hUz")
local Cryo = require(CorePackages.Packages.Cryo)

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module5 = require("@luauforge/bundled/egx")

local extended = Roact.PureComponent:extend("DevSubConfirmCancelPrompt")

local module6 = require("@luauforge/bundled/egZ")
local withStyle = UIBlox.Style.withStyle

function extended.render(p2)
	local containerWidth = p2.props.containerWidth
	local onConfirm = p2.props.onConfirm
	local onBack = p2.props.onBack
	local networking = p2.props.networking
	local devSub = p2.props.devSub

	return module6({
		titleText = "Feature.DevSubs.Action.CancelSubscription",
		messageText = "Feature.DevSubs.Message.ConfirmCancellation",
		confirmButtonText = "CommonUI.Controls.Action.Confirm",
		cancelButtonText = "CommonUI.Controls.Action.Back"
	})(function(data)
		return withStyle(function(p3)
			local titleText = data.titleText
			local messageText = data.messageText
			local confirmButtonText = data.confirmButtonText
			local cancelButtonText = data.cancelButtonText

			return Roact.createElement(module, {
				containerWidth = containerWidth,
				titleText = titleText,
				titleFont = p3.Font.Title.Font,
				titleTextSize = 22,
				messageText = messageText,
				messageFont = p3.Font.Body.Font,
				buttonFont = p3.Font.Header1.Font,
				confirmButtonText = confirmButtonText,
				onConfirm = function()
					onConfirm(networking, devSub)
				end,
				hasCancelButton = true,
				cancelButtonText = cancelButtonText,
				onCancel = onBack
			})
		end)
	end)
end

local v5 = RoactRodux.connect(nil, function(callback)
	return {
		onBack = function()
			callback(module2())
		end,
		onConfirm = function(p2, p3)
			callback(module2())
			callback(module3.Patch(p2, p3.id, false))
			callback(module4(Cryo.Dictionary.join(p3, { isAutoRenewing = false })))
		end
	}
end)(extended)

return roactServices.connect({ networking = module5 })(v5)
