local GuiService = game:GetService("GuiService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent.Parent
local OpenEducationalPopup = require(parent.Thunks.OpenEducationalPopup)
local ExternalEventConnection = require(parent.Utility.ExternalEventConnection)
local InGameMenuPolicy = require(parent.InGameMenuPolicy)
local UserLocalStore = require(parent.Utility.UserLocalStore)
local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)

local extended = Roact.PureComponent:extend("NativeCloseEventConnector")

extended.validateProps = t.strictInterface({
	isEducationalPopupEnabled = t.boolean,
	maxDisplayCount = t.integer,
	openEducationalPopup = t.optional(t.callback)
})

function extended:init()
	function self.onNativeCloseConnect()
		if self.props.isEducationalPopupEnabled then
			RbxAnalyticsService:ReportCounter("LeaveGame_NativeClose", 1)

			local v = UserLocalStore.new()
			self.props.openEducationalPopup(GuiService, v, self.props.maxDisplayCount)
		end

		SendAnalytics(Constants.AnalyticsInGameMenuName, "LeaveGame_NativeClose", {})
	end
end

function extended.render(p)
	return Roact.createElement(ExternalEventConnection, {
		event = GuiService.NativeClose,
		callback = p.onNativeCloseConnect
	})
end

local v = InGameMenuPolicy.connect(function(p, _)
	return {
		isEducationalPopupEnabled = p.enableEducationalPopup(),
		maxDisplayCount = p.educationalPopupMaxDisplayCount()
	}
end)(extended)

return RoactRodux.UNSTABLE_connect2(nil, function(callback)
	return {
		openEducationalPopup = function(p, p2, p3)
			return callback(OpenEducationalPopup(p, p2, p3))
		end
	}
end)(v)
