local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local Toast = UIBlox.App.Dialog.Toast
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local ContentProvider = game:GetService("ContentProvider")
local renderWithCoreScriptsStyleProvider = require(RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)

local extended = Roact.PureComponent:extend("LuobuWarningToastComponent")
local formatByKey = RobloxTranslator:FormatByKey("InGame.CommonUI.Message.LuobuGameJoinWarning")

function extended:init()
	self.state = { isLoaded = false }

	task.spawn(function()
		local image = Images["icons/status/alert"].Image
		pcall(function()
			ContentProvider:PreloadAsync({ image })
		end)
		self:setState({ isLoaded = true })
	end)

	function self.getToastContent()
		return {
			iconImage = Images["icons/status/alert"],
			iconColorStyle = { Color = Color3.new(1, 1, 1), Transparency = 0 },
			toastTitle = formatByKey
		}
	end
end

function extended.render(p)
	if not p.state.isLoaded then
		return nil
	end

	return renderWithCoreScriptsStyleProvider({
		RobloxCaptureNotificationGui = Roact.createElement("ScreenGui", {
			AutoLocalize = false,
			DisplayOrder = 9,
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}, {
			Content = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				WarningToast = Roact.createElement(Toast, {
					duration = 5,
					show = true,
					toastContent = p.getToastContent()
				})
			})
		})
	})
end

return extended
