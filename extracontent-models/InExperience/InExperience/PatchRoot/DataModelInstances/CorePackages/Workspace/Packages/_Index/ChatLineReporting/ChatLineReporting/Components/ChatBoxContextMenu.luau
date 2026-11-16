local GuiService = game:GetService("GuiService")

local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local parent = ChatLineReporting.Parent
local UIBlox = require(parent.UIBlox)
local Otter = require(parent.Otter)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local CurrentCamera = game.Workspace.CurrentCamera
local Constants = require(ChatLineReporting.Common.Constants)
local React = require(parent.React)

local Images = UIBlox.App.ImageSet.Images
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection

local ChatLineReportRoot = require(ChatLineReporting.Components.ChatLineReportRoot)
local SharedFlags = require(parent.SharedFlags)
local GetFFlagMemoizeChatReportingMenu = SharedFlags.GetFFlagMemoizeChatReportingMenu

local motorOverrideOptions = {
	motorCallback = Otter.instant,
	open = { targetValue = 1 },
	close = { targetValue = 0 }
}

local v = { reportAbuse = "Feature.ReportAbuse.Action.EnterChatLineReporting" }

return function(props)
	local v2 = useLocalization(v)
	local screenSize

	if CurrentCamera then
		screenSize = CurrentCamera.ViewportSize
	else
		screenSize = Vector2.new(Constants.ViewportSize, Constants.ViewportSize)
	end

	local ref = React.useRef(nil)

	React.useEffect(function()
		if ref.current and ref.current.AbsolutePosition.X + ref.current.AbsoluteSize.X > screenSize.X then
			ref.current.AnchorPoint = Vector2.new(1, 0)
			ref.current.Position = UDim2.new(1, Constants.FramePositionXOffsetLeft, 0, Constants.FramePositionYOffset)
		end
	end, { ref, screenSize })

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(Constants.FrameSizeXScale, Constants.FrameSizeXOffset, 1, 0),
			Position = UDim2.new(1, Constants.FramePositionXOffset, 0, Constants.FramePositionYOffset),
			BackgroundTransparency = 1,
			ref = ref
		},
		{
			ContextualMenu = React.createElement(ContextualMenu, {
				buttonProps = {
					{
						icon = Images["icons/actions/feedback"],
						text = v2.reportAbuse,
						onActivated = function()
							if GuiService.MenuIsOpen then
								local menuClosedConnection = nil
								menuClosedConnection = GuiService.MenuClosed:Connect(function()
									local initialize = ChatLineReportRoot.initialize
									local v3

									if GetFFlagMemoizeChatReportingMenu() then
										v3 = props.getMessages()
									else
										v3 = props.messages
									end

									initialize(v3)

									menuClosedConnection:Disconnect()
								end)
							else
								local initialize = ChatLineReportRoot.initialize
								local v3

								if GetFFlagMemoizeChatReportingMenu() then
									v3 = props.getMessages()
								else
									v3 = props.messages
								end

								initialize(v3)
							end

							props.setContextMenuOpen(false)
						end
					}
				},
				elementHeight = Constants.TopBannerSize,
				closeBackgroundVisible = false,
				open = true,
				menuDirection = MenuDirection.Down,
				horizontalAlignment = Enum.HorizontalAlignment.Left,
				openPositionX = UDim.new(0, 0),
				openPositionY = UDim.new(0, 0),
				borderCornerRadius = Constants.ContextualMenuBorderRadius,
				motorOverrideOptions = motorOverrideOptions,
				background = {
					Transparency = props.backgroundTransparency,
					Color = props.backgroundColor3
				},
				screenSize = screenSize,
				onDismiss = function()
					props.setContextMenuOpen(false)
				end
			})
		}
	)
end
