local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ego")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module3 = require("@luauforge/bundled/egY")
local module4 = require("@luauforge/bundled/egx")
local Cryo = require(CorePackages.Packages.Cryo)

local module5 = require("@luauforge/bundled/dzD")
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")

local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local module7 = require("@luauforge/bundled/fCM")
local module8 = require("@luauforge/deferred/hXw")
local module9 = require("@luauforge/bundled/ehm")
local module10 = require("@luauforge/bundled/hUz")

local module11 = require("@luauforge/bundled/hPz")
local module12 = require("@luauforge/deferred/hWH")

local module13 = require("@luauforge/deferred/geB")

local module14 = require("@luauforge/bundled/ehl")

local extended = module.PureComponent:extend("DevSubMoreMenu")

local DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH = module5.DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH

function extended.render(p2)
	local localization = p2.props.localization
	local screenSize = p2.props.screenSize
	local formFactor2 = p2.props.formFactor
	local onCancelSubscription = p2.props.onCancelSubscription
	local onRenewSubscription = p2.props.onRenewSubscription
	local devSub = p2.props.devSub

	local anchorSpaceSize = p2.props.anchorSpaceSize
	local anchorSpacePosition = p2.props.anchorSpacePosition

	local x = formFactor2 == formFactor.COMPACT and screenSize.X or DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH

	local networking = p2.props.networking

	local v5 = {}

	if devSub.isAutoRenewing then
		table.insert(v5, {
			text = localization:Format("Feature.DevSubs.Action.CancelSubscription"),
			onSelect = function()
				onCancelSubscription(devSub)
			end
		})
	end

	if not devSub.isAutoRenewing and devSub.status == module13.Active then
		table.insert(v5, {
			text = localization:Format("Feature.DevSubs.Action.RenewSubscription"),
			onSelect = function()
				onRenewSubscription(networking, devSub)
			end
		})
	end

	return module.createElement(
		module12,
		{
			anchorSpaceSize = anchorSpaceSize,
			anchorSpacePosition = anchorSpacePosition,
			itemWidth = x,
			enablePopUpCancelButton = false
		},
		{
			Content = module.createElement(
				FitChildren.FitFrame,
				{
					BackgroundTransparency = 1,
					fitAxis = FitChildren.FitAxis.Height,
					Size = UDim2.new(1, 0, 0, 0)
				},
				{
					ListPicker = module.createElement(module11, {
						formFactor = formFactor2,
						items = v5,
						layoutOrder = 1,
						width = x,
						maxHeight = 162
					})
				}
			)
		}
	)
end

local v5 = useSheetNavigation.connect(function(p2, p3)
	return { formFactor = p2.FormFactor, screenSize = p2.ScreenSize }
end, function(callback)
	return {
		onCancelSubscription = function(p2)
			callback(module7())
			callback(module9(module14.DevSubConfirmCancel, { devSub = p2 }))
		end,
		onRenewSubscription = function(p2, p3)
			callback(module7())
			callback(module8.Patch(p2, p3.id, true))
			callback(module10(Cryo.Dictionary.join(p3, { isAutoRenewing = true })))
		end
	}
end)(extended)

return (roactServices.connect({ localization = module3, networking = module4 })(v5))
