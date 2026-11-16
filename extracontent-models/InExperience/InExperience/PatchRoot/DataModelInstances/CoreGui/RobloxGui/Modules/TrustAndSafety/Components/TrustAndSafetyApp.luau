local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)

local renderWithCoreScriptsStyleProvider = require(RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)

local parent = script.Parent.Parent
local SetScreenSize = require(parent.Actions.SetScreenSize)
local ReportMenu = require(parent.Components.ReportMenu)
local ReportDialog = require(parent.Components.ReportDialog)
local ReportCategoryDialog = require(parent.Components.ReportCategoryDialog)

local ReportSentDialog = require(parent.Components.ReportSentDialog)
local Toast = require(parent.Components.Toast)
local VoiceStateContext = require(RobloxGui.Modules.VoiceChat.VoiceStateContext)

local extended = Roact.PureComponent:extend("TrustAndSafetyApp")

extended.validateProps = t.strictInterface({ setScreenSize = t.callback })

function extended.init(_) end

function extended.render(p)
	return renderWithCoreScriptsStyleProvider({
		VoiceStateContextProvider = Roact.createElement(VoiceStateContext.Provider, {}, {
			Gui = Roact.createElement("ScreenGui", {
				AutoLocalize = false,
				DisplayOrder = 8,
				IgnoreGuiInset = true,
				OnTopOfCoreBlur = true,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				[Roact.Change.AbsoluteSize] = p.props.setScreenSize
			}, {
				Content = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0)
				}, {
					ReportCategoryDialog = Roact.createElement(ReportCategoryDialog),
					ReportMenu = Roact.createElement(ReportMenu),
					ReportDialog = Roact.createElement(ReportDialog),
					ReportSentDialog = Roact.createElement(ReportSentDialog),
					Toast = Roact.createElement(Toast)
				})
			})
		})
	})
end

return RoactRodux.UNSTABLE_connect2(nil, function(callback)
	return {
		setScreenSize = function(p)
			callback(SetScreenSize(p.AbsoluteSize))
		end
	}
end)(extended)
