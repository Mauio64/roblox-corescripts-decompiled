local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

require(CorePackages.Workspace.Packages.SharedFlags)

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Utility = require(RobloxGui.Modules.Settings.Utility)
local GetFFlagEnableConnectDisconnectInSettingsAndChrome = require(RobloxGui.Modules.Flags.GetFFlagEnableConnectDisconnectInSettingsAndChrome)
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local FIntVoiceChatTooltipDelay = require(RobloxGui.Modules.Flags.FIntVoiceChatTooltipDelay)
local Constants = require(RobloxGui.Modules.TopBar.Constants)
local TopBarHeight = Constants.TopBarHeight

local function VoiceChatTooltip(t1: {[any]: any}) -- line: 35
	-- upvalues: useStyle (copy), React (copy), GuiService (copy), FIntVoiceChatTooltipDelay (copy), Utility (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), TopBarHeight (copy), Constants (copy), Roact (copy), StyledTextLabel (copy), CoreGui (copy), TooltipOrientation (copy), withTooltip (copy)
	local v19 = useStyle()
	local v20 = React.useRef(nil)
	local onClose = t1.onClose

	React.useEffect(function() -- line: 41
		-- upvalues: t1 (copy), v20 (copy), GuiService (copy), onClose (copy), FIntVoiceChatTooltipDelay (copy)
		if t1.showPrompt then
			v20.current = GuiService.MenuOpened:Connect(function() -- line: 43
				-- upvalues: v20 (copy), onClose (copy)
				if v20.current then
					v20.current:Disconnect()
					v20.current = nil
					onClose()
				end
			end)
			task.delay(FIntVoiceChatTooltipDelay, function() -- line: 50
				-- upvalues: v20 (copy), t1 (copy), onClose (copy)
				if v20.current then
					v20.current:Disconnect()
					v20.current = nil
				end

				if t1.showPrompt then
					onClose()
				end
			end)
		end

		return function() -- line: 61
			-- upvalues: v20 (copy)
			if v20.current then
				v20.current:Disconnect()
				v20.current = nil
			end
		end
	end, { t1.showPrompt })

	local v22 = not Utility:IsSmallTouchScreen() and 64 or 64

	if GetFFlagEnableConnectDisconnectInSettingsAndChrome() then
		local _ = TopBarHeight
	end

	local u24 = Constants.useDisplayScaleState(TopBarHeight)
	local t2 = {
		minContentWidth = 240,
		headerText = t1.titleText,
		renderCustomComponents = function(_) -- line: 83
			-- upvalues: Roact (copy), StyledTextLabel (copy), t1 (copy), v19 (copy)
			return Roact.createElement(StyledTextLabel, {
				layoutOrder = 0,
				text = t1.subtitleText,
				textTruncate = Enum.TextTruncate.None,
				textXAlignment = Enum.TextXAlignment.Left,
				fontStyle = v19.Font.CaptionSmall,
				colorStyle = v19.Theme.TextDefault,
				automaticSize = Enum.AutomaticSize.XY
			})
		end,
		onClose = onClose,
		backgroundColor = v19.Theme.BackgroundUIDefault.Color,
		backgroundTransparency = v19.Theme.BackgroundUIDefault.Transparency
	}
	local t3 = {
		DisplayOrder = 10,
		guiTarget = CoreGui,
		active = t1.showPrompt,
		preferredOrientation = TooltipOrientation.Bottom
	}

	return withTooltip(t2, t3, function(p2) -- line: 106
		-- upvalues: Roact (copy), v22 (copy), u24 (ref), React (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, v22, 0, u24),
			[React.Change.AbsoluteSize] = p2,
			[React.Change.AbsolutePosition] = p2
		})
	end)
end

return VoiceChatTooltip
