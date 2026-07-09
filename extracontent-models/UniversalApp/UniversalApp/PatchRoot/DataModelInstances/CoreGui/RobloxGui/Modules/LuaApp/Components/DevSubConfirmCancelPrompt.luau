local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AlertWindow = require(Modules.LuaApp.Components.AlertWindow)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local PatchDevSub = require(Modules.LuaApp.Thunks.PatchDevSub)
local SetDevSub = require(Modules.LuaApp.Actions.SetDevSub)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local v13 = Roact.PureComponent:extend("DevSubConfirmCancelPrompt")
local withLocalization = require(Modules.LuaApp.withLocalization)
local withStyle = UIBlox.Style.withStyle

function v13.render(p1) -- line: 20
	-- upvalues: withLocalization (copy), withStyle (copy), Roact (copy), AlertWindow (copy)
	local containerWidth = p1.props.containerWidth
	local onConfirm = p1.props.onConfirm
	local onBack = p1.props.onBack
	local networking = p1.props.networking
	local devSub = p1.props.devSub

	return withLocalization({
		titleText = "Feature.DevSubs.Action.CancelSubscription",
		messageText = "Feature.DevSubs.Message.ConfirmCancellation",
		confirmButtonText = "CommonUI.Controls.Action.Confirm",
		cancelButtonText = "CommonUI.Controls.Action.Back"
	})(function(p2) -- line: 32
		-- upvalues: withStyle (copy), Roact (copy), AlertWindow (copy), containerWidth (copy), onConfirm (copy), networking (copy), devSub (copy), onBack (copy)
		return withStyle(function(p3) -- line: 33
			-- upvalues: p2 (copy), Roact (copy), AlertWindow (copy), containerWidth (copy), onConfirm (copy), networking (copy), devSub (copy), onBack (copy)
			local titleText = p2.titleText
			local messageText = p2.messageText
			local confirmButtonText = p2.confirmButtonText
			local cancelButtonText = p2.cancelButtonText

			return Roact.createElement(AlertWindow, {
				titleTextSize = 22,
				hasCancelButton = true,
				containerWidth = containerWidth,
				titleText = titleText,
				titleFont = p3.Font.Title.Font,
				messageText = messageText,
				messageFont = p3.Font.Body.Font,
				buttonFont = p3.Font.Header1.Font,
				confirmButtonText = confirmButtonText,
				onConfirm = function() -- line: 49
					-- upvalues: onConfirm (copy), networking (copy), devSub (copy)
					onConfirm(networking, devSub)
				end,
				cancelButtonText = cancelButtonText,
				onCancel = onBack
			})
		end)
	end)
end

local v16 = RoactRodux.connect(nil, function(p4) -- line: 61
	-- upvalues: CloseCentralOverlay (copy), PatchDevSub (copy), SetDevSub (copy), Cryo (copy)
	return {
		onBack = function() -- line: 63
			-- upvalues: p4 (copy), CloseCentralOverlay (copy)
			p4(CloseCentralOverlay())
		end,
		onConfirm = function(p5, p6) -- line: 66
			-- upvalues: p4 (copy), CloseCentralOverlay (copy), PatchDevSub (copy), SetDevSub (copy), Cryo (copy)
			p4(CloseCentralOverlay())
			p4(PatchDevSub.Patch(p5, p6.id, false))
			p4(SetDevSub(Cryo.Dictionary.join(p6, {
				isAutoRenewing = false
			})))
		end
	}
end)(v13)

return RoactServices.connect({
	networking = RoactNetworking
})(v16)
