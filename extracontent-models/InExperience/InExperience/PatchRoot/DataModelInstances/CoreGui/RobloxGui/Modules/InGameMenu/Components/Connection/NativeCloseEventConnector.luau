local GuiService = game:GetService("GuiService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent.Parent
local OpenEducationalPopup = require(ParentParent.Thunks.OpenEducationalPopup)
local ExternalEventConnection = require(ParentParent.Utility.ExternalEventConnection)
local InGameMenuPolicy = require(ParentParent.InGameMenuPolicy)
local UserLocalStore = require(ParentParent.Utility.UserLocalStore)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)
local v15 = Roact.PureComponent:extend("NativeCloseEventConnector")

v15.validateProps = t.strictInterface({
	isEducationalPopupEnabled = t.boolean,
	maxDisplayCount = t.integer,
	openEducationalPopup = t.optional(t.callback)
})

function v15.init(p1) -- line: 26
	-- upvalues: RbxAnalyticsService (copy), UserLocalStore (copy), GuiService (copy), SendAnalytics (copy), Constants (copy)
	function p1.onNativeCloseConnect() -- line: 27
		-- upvalues: p1 (copy), RbxAnalyticsService (copy), UserLocalStore (copy), GuiService (copy), SendAnalytics (copy), Constants (copy)
		if p1.props.isEducationalPopupEnabled then
			RbxAnalyticsService:ReportCounter("LeaveGame_NativeClose", 1)

			local v22 = UserLocalStore.new()

			p1.props.openEducationalPopup(GuiService, v22, p1.props.maxDisplayCount)
		end

		SendAnalytics(Constants.AnalyticsInGameMenuName, "LeaveGame_NativeClose", {})
	end
end
function v15.render(p2) -- line: 39
	-- upvalues: Roact (copy), ExternalEventConnection (copy), GuiService (copy)
	return Roact.createElement(ExternalEventConnection, {
		event = GuiService.NativeClose,
		callback = p2.onNativeCloseConnect
	})
end

local v16 = InGameMenuPolicy.connect(function(p3, _) -- line: 46
	return {
		isEducationalPopupEnabled = p3.enableEducationalPopup(),
		maxDisplayCount = p3.educationalPopupMaxDisplayCount()
	}
end)(v15)

return RoactRodux.UNSTABLE_connect2(nil, function(p5) -- line: 53
	-- upvalues: OpenEducationalPopup (copy)
	return {
		openEducationalPopup = function(p6, p7, p8) -- line: 55
			-- upvalues: p5 (copy), OpenEducationalPopup (copy)
			return p5(OpenEducationalPopup(p6, p7, p8))
		end
	}
end)(v16)
