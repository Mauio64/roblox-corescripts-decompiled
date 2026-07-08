local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ShareGame = Modules.Settings.Pages.ShareGame
local Constants = require(ShareGame.Constants)
local GameInviteEvents = require(CorePackages.Workspace.Packages.GameInvite).GameInviteEvents
local Header = require(ShareGame.Components.Header)
local ConversationList = require(ShareGame.Components.ConversationList)
local ErrorToaster = require(ShareGame.Components.ErrorToaster)
local BackButton = require(ShareGame.Components.BackButton)
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local Theme = require(RobloxGui.Modules.Settings.Theme)
local GetFFlagEnableNewInviteMenu = require(Modules.Flags.GetFFlagEnableNewInviteMenu)
local GetFFlagEnableNewInviteSendEndpoint = require(Modules.Flags.GetFFlagEnableNewInviteSendEndpoint)
local uDim = UDim.new(0.8, 320)
local uDim2 = UDim.new(0.7, 500)
local uDim3 = UDim.new(0.8, 440)
local color3 = Color3.fromRGB(41, 41, 41)
local v22 = Roact.PureComponent:extend("ModalShareGamePageFrame")

v22.defaultProps = {
	isVisible = true
}

function v22.init(p1) -- line: 53
	-- upvalues: Constants (copy), Theme (copy), Text (copy), Roact (copy)
	p1.state = {
		promptMessageFitsFrame = true
	}

	function p1.onCustomTextAreaSizeChange(p2) -- line: 58
		-- upvalues: p1 (copy), Constants (copy), Theme (copy), Text (copy)
		local deviceLayout = p1.props.deviceLayout
		local v48 = Constants.LayoutSpecific[deviceLayout]
		local promptMessage = p1.props.promptMessage
		local v50 = Theme.textSize(v48.PAGE_TITLE_TEXT_SIZE)

		p1:setState({
			promptMessageFitsFrame = promptMessage and Text.GetTextWidth(promptMessage, Theme.font(Enum.Font.SourceSans), v50) < p2.AbsoluteSize.X
		})
	end

	p1.customTextAreaRef = Roact.createRef()

	function p1.onClosePage() -- line: 71
		-- upvalues: p1 (copy)
		p1.props.closePage()

		if p1.props.onAfterClosePage then
			p1.props.onAfterClosePage()
		end
	end
end
function v22.didMount(p3) -- line: 79
	-- upvalues: GetFFlagEnableNewInviteMenu (copy), GetFFlagEnableNewInviteSendEndpoint (copy), Constants (copy), GameInviteEvents (copy)
	if GetFFlagEnableNewInviteMenu() and p3.customTextAreaRef.current then
		p3.onCustomTextAreaSizeChange(p3.customTextAreaRef.current)
	end

	if GetFFlagEnableNewInviteSendEndpoint() and p3.props.promptMessage and p3.props.analytics then
		p3.props.analytics:sendEvent(Constants.Triggers.DeveloperMultiple, GameInviteEvents.CustomTextShown)
	end
end
function v22.render(p4) -- line: 92
	-- upvalues: GetFFlagEnableNewInviteMenu (copy), uDim3 (copy), uDim (copy), Constants (copy), uDim2 (copy), Theme (copy), Roact (copy), color3 (copy), CoreGui (copy), ErrorToaster (copy), Header (copy), BackButton (copy), ConversationList (copy)
	local analytics = p4.props.analytics
	local deviceLayout = p4.props.deviceLayout
	local zIndex = p4.props.zIndex
	local searchAreaActive = p4.props.searchAreaActive
	local searchText = p4.props.searchText
	local isVisible = p4.props.isVisible
	local v32 = GetFFlagEnableNewInviteMenu()
	local v33 = if not v32 then uDim else uDim3
	local v34 = v32 and (p4.props.deviceInfo and p4.props.deviceInfo.DeviceLayout == Constants.DeviceLayout.PHONE_LANDSCAPE)
	local vector2 = Vector2.new(0.5, 0.5)
	local uDim2_2 = UDim2.new(v33.Scale, 0, uDim2.Scale, 0)
	local vector2_2 = Vector2.new(v33.Offset, uDim2.Offset)
	local uDim2_3 = UDim2.new(0.5, 0, 0.425, 0)

	if v34 then
		vector2 = Vector2.new(0.5, 1)
		uDim2_2 = UDim2.new(v33.Scale, 0, 1, 0)
		vector2_2 = Vector2.new(v33.Offset, 1e999)
		uDim2_3 = UDim2.new(0.5, 0, 1, 4)
	end

	local v39 = Constants.LayoutSpecific[deviceLayout]
	local promptMessage = p4.props.promptMessage
	local v41 = Theme.textSize(v39.PAGE_TITLE_TEXT_SIZE)
	local v42 = v32 and (promptMessage and p4.state.promptMessageFitsFrame)
	local v43 = not v42 and 10 or v41 + 10
	local v44 = not v32 and 60 or 40 + v43

	return Roact.createElement("ImageButton", {
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/LuaChat/9-slice/btn-control-sm.png",
		ImageTransparency = 0.1,
		AnchorPoint = vector2,
		ImageColor3 = color3,
		Modal = isVisible,
		Position = uDim2_3,
		Size = uDim2_2,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(Vector2.new(3, 3), Vector2.new(3, 3))
	}, {
		sizeConstraint = Roact.createElement("UISizeConstraint", {
			MaxSize = vector2_2
		}),
		uiPadding2 = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 15),
			PaddingRight = UDim.new(0, 15),
			PaddingBottom = UDim.new(0, 15)
		}),
		content = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			ZIndex = zIndex
		}, {
			toasterPortal = Roact.createElement(Roact.Portal, {
				target = CoreGui
			}, {
				Toaster = Roact.createElement(ErrorToaster)
			}),
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding = if not v32 then nil else Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 10)
			}),
			Header = Roact.createElement(Header, {
				layoutOrder = 0,
				toggleSearchIcon = true,
				deviceLayout = deviceLayout,
				size = UDim2.new(1, 0, 0, not v32 and 60 or 40),
				zIndex = zIndex,
				closePage = p4.onClosePage,
				searchAreaActive = searchAreaActive,
				iconType = BackButton.IconType.Cross
			}),
			CustomText = v32 and Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, v43),
				TextYAlignment = Enum.TextYAlignment.Top,
				TextSize = v41,
				TextColor3 = Constants.Color.WHITE,
				Font = Theme.font(Enum.Font.SourceSans),
				BackgroundTransparency = 1,
				Text = not v42 and "" or promptMessage,
				[Roact.Change.AbsoluteSize] = p4.onCustomTextAreaSizeChange,
				[Roact.Ref] = p4.customTextAreaRef
			}),
			ConversationList = Roact.createElement(ConversationList, {
				topPadding = 10,
				layoutOrder = 1,
				entryHeight = 62,
				entryPadding = 18,
				analytics = analytics,
				size = UDim2.new(1, 0, 1, -v44),
				zIndex = zIndex,
				searchText = searchText,
				isVisible = isVisible,
				trigger = Constants.Triggers.DeveloperMultiple,
				inviteMessageId = p4.props.inviteMessageId,
				launchData = p4.props.launchData
			})
		})
	})
end

return (RoactRodux.connect(function(p5) -- line: 211
	return {
		deviceInfo = p5.DeviceInfo
	}
end)(v22))
