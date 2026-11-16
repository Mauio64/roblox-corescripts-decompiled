local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Modules = CoreGui.RobloxGui.Modules

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local ShareGame = Modules.Settings.Pages.ShareGame
local Constants = require(ShareGame.Constants)
local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)
local GameInviteEvents = GameInvite.GameInviteEvents
local Header = require(ShareGame.Components.Header)
local ConversationList = require(ShareGame.Components.ConversationList)
local ErrorToaster = require(ShareGame.Components.ErrorToaster)
local BackButton = require(ShareGame.Components.BackButton)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Text = AppCommonLib.Text
local Theme = require(RobloxGui.Modules.Settings.Theme)

local GetFFlagEnableNewInviteMenu = require(Modules.Flags.GetFFlagEnableNewInviteMenu)
local GetFFlagEnableNewInviteSendEndpoint = require(Modules.Flags.GetFFlagEnableNewInviteSendEndpoint)

local udim = UDim.new(0.8, 320)
local udim2 = UDim.new(0.7, 500)

local udim3 = UDim.new(0.8, 440)

local color = Color3.fromRGB(41, 41, 41)

local extended = Roact.PureComponent:extend("ModalShareGamePageFrame")
extended.defaultProps = { isVisible = true }

function extended:init()
	self.state = { promptMessageFitsFrame = true }

	function self.onCustomTextAreaSizeChange(p)
		local deviceLayout = self.props.deviceLayout
		local v = Constants.LayoutSpecific[deviceLayout]
		local promptMessage = self.props.promptMessage
		local textSize = Theme.textSize(v.PAGE_TITLE_TEXT_SIZE)
		self:setState({
			promptMessageFitsFrame = promptMessage and Text.GetTextWidth(
				promptMessage,
				Theme.font(Enum.Font.SourceSans),
				textSize
			) < p.AbsoluteSize.X
		})
	end
	self.customTextAreaRef = Roact.createRef()

	function self.onClosePage()
		self.props.closePage()

		if self.props.onAfterClosePage then
			self.props.onAfterClosePage()
		end
	end
end

function extended.didMount(data)
	if GetFFlagEnableNewInviteMenu() and data.customTextAreaRef.current then
		data.onCustomTextAreaSizeChange(data.customTextAreaRef.current)
	end

	if GetFFlagEnableNewInviteSendEndpoint() and data.props.promptMessage and data.props.analytics then
		data.props.analytics:sendEvent(Constants.Triggers.DeveloperMultiple, GameInviteEvents.CustomTextShown)
	end
end

function extended.render(props)
	local analytics = props.props.analytics
	local deviceLayout = props.props.deviceLayout
	local zIndex = props.props.zIndex
	local searchAreaActive = props.props.searchAreaActive
	local searchText = props.props.searchText

	local isVisible = props.props.isVisible

	local customText = GetFFlagEnableNewInviteMenu()
	local v = if customText then udim3 else udim
	local v2 = customText
		and props.props.deviceInfo
		and props.props.deviceInfo.DeviceLayout == Constants.DeviceLayout.PHONE_LANDSCAPE

	local vector2 = Vector2.new(0.5, 0.5)
	local udim4 = UDim2.new(v.Scale, 0, udim2.Scale, 0)
	local vector2_2 = Vector2.new(v.Offset, udim2.Offset)
	local udim5 = UDim2.new(0.5, 0, 0.425, 0)

	if v2 then
		vector2 = Vector2.new(0.5, 1)
		udim4 = UDim2.new(v.Scale, 0, 1, 0)
		vector2_2 = Vector2.new(v.Offset, 1e999)
		udim5 = UDim2.new(0.5, 0, 1, 4)
	end

	local v3 = Constants.LayoutSpecific[deviceLayout]
	local promptMessage = props.props.promptMessage
	local textSize = Theme.textSize(v3.PAGE_TITLE_TEXT_SIZE)
	local promptMessageFitsFrame = customText and promptMessage and props.state.promptMessageFitsFrame
	local v4 = not promptMessageFitsFrame and 10 or textSize + 10

	local v5 = not customText and 60 or 40 + v4

	local createElement = Roact.createElement
	local v6 = {
		AnchorPoint = vector2,
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/LuaChat/9-slice/btn-control-sm.png",
		ImageColor3 = color,
		ImageTransparency = 0.1,
		Modal = isVisible,
		Position = udim5,
		Size = udim4,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(Vector2.new(3, 3), Vector2.new(3, 3))
	}

	local v7 = {
		sizeConstraint = Roact.createElement("UISizeConstraint", { MaxSize = vector2_2 }),
		uiPadding2 = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 15),
			PaddingRight = UDim.new(0, 15),
			PaddingBottom = UDim.new(0, 15)
		}),
		content = 0
	}

	local createElement2 = Roact.createElement
	local v8 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		ZIndex = zIndex
	}

	local children = {
		toasterPortal = Roact.createElement(Roact.Portal, { target = CoreGui }, {
			Toaster = Roact.createElement(ErrorToaster)
		}),
		Layout = Roact.createElement("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
		Padding = 0,
		Header = 0,
		CustomText = 0,
		ConversationList = 0
	}
	local padding

	if customText then
		padding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, 10) })
	end

	children.Padding = padding

	children.Header = Roact.createElement(Header, {
		deviceLayout = deviceLayout,
		size = UDim2.new(1, 0, 0, customText and 40 or 60),
		layoutOrder = 0,
		zIndex = zIndex,
		closePage = props.onClosePage,
		searchAreaActive = searchAreaActive,
		toggleSearchIcon = true,
		iconType = BackButton.IconType.Cross
	})

	if customText then
		customText = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, v4),
			TextYAlignment = Enum.TextYAlignment.Top,
			TextSize = textSize,
			TextColor3 = Constants.Color.WHITE,
			Font = Theme.font(Enum.Font.SourceSans),
			BackgroundTransparency = 1,
			Text = not promptMessageFitsFrame and "" or promptMessage,
			[Roact.Change.AbsoluteSize] = props.onCustomTextAreaSizeChange,
			[Roact.Ref] = props.customTextAreaRef
		})
	end

	children.CustomText = customText

	children.ConversationList = Roact.createElement(ConversationList, {
		analytics = analytics,
		size = UDim2.new(1, 0, 1, -v5),
		topPadding = 10,
		layoutOrder = 1,
		zIndex = zIndex,
		searchText = searchText,
		entryHeight = 62,
		entryPadding = 18,
		isVisible = isVisible,
		trigger = Constants.Triggers.DeveloperMultiple,
		inviteMessageId = props.props.inviteMessageId,
		launchData = props.props.launchData
	})
	v7.content = createElement2("Frame", v8, children)
	return createElement("ImageButton", v6, v7)
end

return (RoactRodux.connect(function(p)
	return { deviceInfo = p.DeviceInfo }
end)(extended))
