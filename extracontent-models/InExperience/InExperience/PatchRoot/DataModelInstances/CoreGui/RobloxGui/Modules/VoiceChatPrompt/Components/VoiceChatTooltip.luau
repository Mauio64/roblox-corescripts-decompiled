local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

require(CorePackages.Workspace.Packages.SharedFlags)

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Utility = require(RobloxGui.Modules.Settings.Utility)

local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle

local FIntVoiceChatTooltipDelay = require(RobloxGui.Modules.Flags.FIntVoiceChatTooltipDelay)
local Constants = require(RobloxGui.Modules.TopBar.Constants)
local TopBarHeight = Constants.TopBarHeight

local function VoiceChatTooltip(data)
	local v = useStyle()
	local ref = React.useRef(nil)
	local onClose = data.onClose

	React.useEffect(function()
		if data.showPrompt then
			ref.current = GuiService.MenuOpened:Connect(function()
				if ref.current then
					ref.current:Disconnect()
					ref.current = nil
					onClose()
				end
			end)
			task.delay(FIntVoiceChatTooltipDelay, function()
				if ref.current then
					ref.current:Disconnect()
					ref.current = nil
				end

				if data.showPrompt then
					onClose()
				end
			end)
		end

		return function()
			if ref.current then
				ref.current:Disconnect()
				ref.current = nil
			end
		end
	end, { data.showPrompt })

	Utility:IsSmallTouchScreen()
	local v2 = 64
	local v3 = Constants.useDisplayScaleState(TopBarHeight)

	return withTooltip({
		headerText = data.titleText,
		minContentWidth = 240,
		renderCustomComponents = function(_)
			return Roact.createElement(StyledTextLabel, {
				text = data.subtitleText,
				textTruncate = Enum.TextTruncate.None,
				textXAlignment = Enum.TextXAlignment.Left,
				fontStyle = v.Font.CaptionSmall,
				colorStyle = v.Theme.TextDefault,
				layoutOrder = 0,
				automaticSize = Enum.AutomaticSize.XY
			})
		end,
		onClose = onClose,
		backgroundColor = v.Theme.BackgroundUIDefault.Color,
		backgroundTransparency = v.Theme.BackgroundUIDefault.Transparency
	}, {
		guiTarget = CoreGui,
		active = data.showPrompt,
		DisplayOrder = 10,
		preferredOrientation = TooltipOrientation.Bottom
	}, function(p)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, v2, 0, v3),
			[React.Change.AbsoluteSize] = p,
			[React.Change.AbsolutePosition] = p
		})
	end)
end

return VoiceChatTooltip
