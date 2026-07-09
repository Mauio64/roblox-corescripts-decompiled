local GuiService = game:GetService("GuiService")
local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local ChatLineReportingParent = ChatLineReporting.Parent
local UIBlox = require(ChatLineReportingParent.UIBlox)
local Otter = require(ChatLineReportingParent.Otter)
local useLocalization = require(ChatLineReportingParent.Localization).Hooks.useLocalization
local CurrentCamera = game.Workspace.CurrentCamera
local Constants = require(ChatLineReporting.Common.Constants)
local React = require(ChatLineReportingParent.React)
local Images = UIBlox.App.ImageSet.Images
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection
local ChatLineReportRoot = require(ChatLineReporting.Components.ChatLineReportRoot)
local SharedFlags = require(ChatLineReportingParent.SharedFlags)
local FFlagChatLineReportingFocusFixesEnabled = SharedFlags.FFlagChatLineReportingFocusFixesEnabled
local GetFFlagMemoizeChatReportingMenu = SharedFlags.GetFFlagMemoizeChatReportingMenu
local t1 = {
	motorCallback = Otter.instant,
	open = {
		targetValue = 1
	},
	close = {
		targetValue = 0
	}
}
local t2 = {
	reportAbuse = "Feature.ReportAbuse.Action.EnterChatLineReporting"
}

return function(p1) -- line: 35
	-- upvalues: useLocalization (copy), t2 (copy), CurrentCamera (copy), Constants (copy), React (copy), ContextualMenu (copy), Images (copy), FFlagChatLineReportingFocusFixesEnabled (copy), GuiService (copy), ChatLineReportRoot (copy), GetFFlagMemoizeChatReportingMenu (copy), MenuDirection (copy), t1 (copy)
	local v20 = useLocalization(t2)
	local v21 = if not CurrentCamera then Vector2.new(Constants.ViewportSize, Constants.ViewportSize) else CurrentCamera.ViewportSize
	local v22 = React.useRef(nil)

	React.useEffect(function() -- line: 42
		-- upvalues: v22 (copy), v21 (copy), Constants (copy)
		if v22.current and v22.current.AbsolutePosition.X + v22.current.AbsoluteSize.X > v21.X then
			v22.current.AnchorPoint = Vector2.new(1, 0)
			v22.current.Position = UDim2.new(1, Constants.FramePositionXOffsetLeft, 0, Constants.FramePositionYOffset)
		end
	end, {
		v22,
		v21
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(Constants.FrameSizeXScale, Constants.FrameSizeXOffset, 1, 0),
		Position = UDim2.new(1, Constants.FramePositionXOffset, 0, Constants.FramePositionYOffset),
		ref = v22
	}, {
		ContextualMenu = React.createElement(ContextualMenu, {
			closeBackgroundVisible = false,
			open = true,
			buttonProps = {{
				icon = Images["icons/actions/feedback"],
				text = v20.reportAbuse,
				onActivated = function() -- line: 67
					-- upvalues: FFlagChatLineReportingFocusFixesEnabled (copy), GuiService (copy), ChatLineReportRoot (copy), GetFFlagMemoizeChatReportingMenu (copy), p1 (copy)
					if FFlagChatLineReportingFocusFixesEnabled and GuiService.MenuIsOpen then
						local connection = nil

						connection = GuiService.MenuClosed:Connect(function() -- line: 73
							-- upvalues: ChatLineReportRoot (copy), GetFFlagMemoizeChatReportingMenu (copy), p1 (copy), connection (ref)
							ChatLineReportRoot.initialize(if not GetFFlagMemoizeChatReportingMenu() then p1.messages else p1.getMessages())
							connection:Disconnect()
						end)
					else
						ChatLineReportRoot.initialize(if not GetFFlagMemoizeChatReportingMenu() then p1.messages else p1.getMessages())
					end

					p1.setContextMenuOpen(false)
				end
			}},
			elementHeight = Constants.TopBannerSize,
			menuDirection = MenuDirection.Down,
			horizontalAlignment = Enum.HorizontalAlignment.Left,
			openPositionX = UDim.new(0, 0),
			openPositionY = UDim.new(0, 0),
			borderCornerRadius = Constants.ContextualMenuBorderRadius,
			motorOverrideOptions = t1,
			background = {
				Transparency = p1.backgroundTransparency,
				Color = p1.backgroundColor3
			},
			screenSize = v21,
			onDismiss = function() -- line: 52
				-- upvalues: p1 (copy)
				p1.setContextMenuOpen(false)
			end
		})
	})
end
