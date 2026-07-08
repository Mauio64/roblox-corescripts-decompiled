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
local v11 = Roact.PureComponent:extend("LuobuWarningToastComponent")
local v12 = RobloxTranslator:FormatByKey("InGame.CommonUI.Message.LuobuGameJoinWarning")

function v11.init(p1) -- line: 18
	-- upvalues: Images (copy), ContentProvider (copy), v12 (copy)
	p1.state = {
		isLoaded = false
	}
	task.spawn(function() -- line: 23
		-- upvalues: Images (copy), ContentProvider (copy), p1 (copy)
		local v16 = Images["icons/status/alert"].Image

		pcall(function() -- line: 25
			-- upvalues: ContentProvider (copy), v16 (copy)
			ContentProvider:PreloadAsync({ v16 })
		end)
		p1:setState({
			isLoaded = true
		})
	end)

	function p1.getToastContent() -- line: 33
		-- upvalues: Images (copy), v12 (copy)
		return {
			iconImage = Images["icons/status/alert"],
			iconColorStyle = {
				Transparency = 0,
				Color = Color3.new(1, 1, 1)
			},
			toastTitle = v12
		}
	end
end
function v11.render(p2) -- line: 45
	-- upvalues: Roact (copy), Toast (copy), renderWithCoreScriptsStyleProvider (copy)
	if not p2.state.isLoaded then
		return nil
	end

	local v15 = Roact.createElement("ScreenGui", {
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
				toastContent = p2.getToastContent()
			})
		})
	})

	return renderWithCoreScriptsStyleProvider({
		RobloxCaptureNotificationGui = v15
	})
end

return v11
