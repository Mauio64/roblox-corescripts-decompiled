local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Cryo = require(CorePackages.Packages.Cryo)
local Constants = require(Modules.LuaApp.Constants)
local FitChildren = require(Modules.LuaApp.FitChildren)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local PatchDevSub = require(Modules.LuaApp.Thunks.PatchDevSub)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local SetDevSub = require(Modules.LuaApp.Actions.SetDevSub)
local ListPicker = require(Modules.LuaApp.Components.ListPicker)
local FormBasedContextualMenu = require(Modules.LuaApp.Components.FormBasedContextualMenu)
local DevSubStatus = require(Modules.LuaApp.Enum.DevSubStatus)
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local v20 = Roact.PureComponent:extend("DevSubMoreMenu")
local DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH = Constants.DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH

function v20.render(p1) -- line: 33
	-- upvalues: FormFactor (copy), DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH (copy), DevSubStatus (copy), Roact (copy), FormBasedContextualMenu (copy), FitChildren (copy), ListPicker (copy)
	local localization = p1.props.localization
	local screenSize = p1.props.screenSize
	local formFactor = p1.props.formFactor
	local onCancelSubscription = p1.props.onCancelSubscription
	local onRenewSubscription = p1.props.onRenewSubscription
	local devSub = p1.props.devSub
	local anchorSpaceSize = p1.props.anchorSpaceSize
	local anchorSpacePosition = p1.props.anchorSpacePosition
	local v32 = formFactor == FormFactor.COMPACT and screenSize.X or DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH
	local networking = p1.props.networking
	local t1 = {}

	if devSub.isAutoRenewing then
		table.insert(t1, {
			text = localization:Format("Feature.DevSubs.Action.CancelSubscription"),
			onSelect = function() -- line: 56
				-- upvalues: onCancelSubscription (copy), devSub (copy)
				onCancelSubscription(devSub)
			end
		})
	end

	if not devSub.isAutoRenewing and devSub.status == DevSubStatus.Active then
		table.insert(t1, {
			text = localization:Format("Feature.DevSubs.Action.RenewSubscription"),
			onSelect = function() -- line: 67
				-- upvalues: onRenewSubscription (copy), networking (copy), devSub (copy)
				onRenewSubscription(networking, devSub)
			end
		})
	end

	return Roact.createElement(FormBasedContextualMenu, {
		enablePopUpCancelButton = false,
		anchorSpaceSize = anchorSpaceSize,
		anchorSpacePosition = anchorSpacePosition,
		itemWidth = v32
	}, {
		Content = Roact.createElement(FitChildren.FitFrame, {
			BackgroundTransparency = 1,
			fitAxis = FitChildren.FitAxis.Height,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			ListPicker = Roact.createElement(ListPicker, {
				layoutOrder = 1,
				maxHeight = 162,
				formFactor = formFactor,
				items = t1,
				width = v32
			})
		})
	})
end

local v22 = RoactRodux.connect(function(p2, _) -- line: 95
	return {
		formFactor = p2.FormFactor,
		screenSize = p2.ScreenSize
	}
end, function(p4) -- line: 100
	-- upvalues: CloseCentralOverlay (copy), SetCentralOverlay (copy), OverlayType (copy), PatchDevSub (copy), SetDevSub (copy), Cryo (copy)
	return {
		onCancelSubscription = function(p5) -- line: 102
			-- upvalues: p4 (copy), CloseCentralOverlay (copy), SetCentralOverlay (copy), OverlayType (copy)
			p4(CloseCentralOverlay())
			p4(SetCentralOverlay(OverlayType.DevSubConfirmCancel, {
				devSub = p5
			}))
		end,
		onRenewSubscription = function(p6, p7) -- line: 108
			-- upvalues: p4 (copy), CloseCentralOverlay (copy), PatchDevSub (copy), SetDevSub (copy), Cryo (copy)
			p4(CloseCentralOverlay())
			p4(PatchDevSub.Patch(p6, p7.id, true))
			p4(SetDevSub(Cryo.Dictionary.join(p7, {
				isAutoRenewing = true
			})))
		end
	}
end)(v20)

return (RoactServices.connect({
	localization = RoactLocalization,
	networking = RoactNetworking
})(v22))
