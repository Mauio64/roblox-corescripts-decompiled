local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local renderWithCoreScriptsStyleProvider = require(RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)
local ParentParent = script.Parent.Parent
local SetScreenSize = require(ParentParent.Actions.SetScreenSize)
local ReportMenu = require(ParentParent.Components.ReportMenu)
local ReportDialog = require(ParentParent.Components.ReportDialog)
local ReportCategoryDialog = require(ParentParent.Components.ReportCategoryDialog)
local ReportSentDialog = require(ParentParent.Components.ReportSentDialog)
local Toast = require(ParentParent.Components.Toast)
local VoiceStateContext = require(RobloxGui.Modules.VoiceChat.VoiceStateContext)
local v15 = Roact.PureComponent:extend("TrustAndSafetyApp")

v15.validateProps = t.strictInterface({
	setScreenSize = t.callback,
	visible = t.boolean
})

function v15.init(_) -- line: 30
end
function v15.render(p2) -- line: 32
	-- upvalues: Roact (copy), VoiceStateContext (copy), ReportCategoryDialog (copy), ReportMenu (copy), ReportDialog (copy), ReportSentDialog (copy), Toast (copy), renderWithCoreScriptsStyleProvider (copy)
	local v18 = Roact.createElement(VoiceStateContext.Provider, {}, {
		Gui = Roact.createElement("ScreenGui", {
			AutoLocalize = false,
			DisplayOrder = 8,
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			[Roact.Change.AbsoluteSize] = p2.props.setScreenSize
		}, {
			Content = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Visible = p2.props.visible
			}, {
				ReportCategoryDialog = Roact.createElement(ReportCategoryDialog),
				ReportMenu = Roact.createElement(ReportMenu),
				ReportDialog = Roact.createElement(ReportDialog),
				ReportSentDialog = Roact.createElement(ReportSentDialog),
				Toast = Roact.createElement(Toast)
			})
		})
	})

	return renderWithCoreScriptsStyleProvider({
		VoiceStateContextProvider = v18
	})
end

return RoactRodux.UNSTABLE_connect2(function(p3, _) -- line: 60
	return {
		visible = p3.displayOptions.visible
	}
end, function(p5) -- line: 64
	-- upvalues: SetScreenSize (copy)
	return {
		setScreenSize = function(p6) -- line: 66
			-- upvalues: p5 (copy), SetScreenSize (copy)
			p5(SetScreenSize(p6.AbsoluteSize))
		end
	}
end)(v15)
