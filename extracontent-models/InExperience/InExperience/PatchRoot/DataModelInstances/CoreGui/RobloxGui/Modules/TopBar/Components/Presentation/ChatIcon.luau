local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local VRService = game:GetService("VRService")
game:GetService("AppStorageService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Signal = AppCommonLib.Signal

local withStyle = UIBlox.Core.Style.withStyle
local Badge = UIBlox.App.Indicator.Badge
local BadgeStates = UIBlox.App.Indicator.Enum.BadgeStates
local Images = UIBlox.App.ImageSet.Images

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local ChatSelector = require(RobloxGui.Modules.ChatSelector)
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)

local IconButton = require(script.Parent.IconButton)

local parent = script.Parent.Parent.Parent
local Analytics = require(parent.Analytics)
local GetFFlagEnableTopBarAnalytics = require(parent.Flags.GetFFlagEnableTopBarAnalytics)
local fFlagEnableTopBarAnalytics = GetFFlagEnableTopBarAnalytics()
local SetKeepOutArea = require(parent.Actions.SetKeepOutArea)
local RemoveKeepOutArea = require(parent.Actions.RemoveKeepOutArea)
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon.Flags.FFlagTopBarSignalizeKeepOutAreas
local Constants = require(parent.Constants)

require(script.Parent.ChatIconFtuxTooltip)
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local getExperienceChatVisualConfig = ExpChat.getExperienceChatVisualConfig
game:DefineFastInt("InExperienceChatTooltipShowDelayMs", 1000)
game:DefineFastInt("InExperienceChatTooltipDismissDelayMs", 7000)

local gameSettings = UserSettings().GameSettings

local function shouldShowEmptyBadge(): boolean -- 2 equivalent calls inferred from this helper
	local TextChatService = game:GetService("TextChatService")
	return TextChatService.ChatVersion == Enum.ChatVersion.TextChatService
end

local extended = Roact.PureComponent:extend("ChatIcon")

local strictInterface = t.strictInterface
local v = {
	layoutOrder = t.integer,
	chatVisible = t.boolean,
	unreadMessages = t.integer,
	topBarEnabled = t.boolean,
	chatEnabled = t.boolean,
	setKeepOutArea = 0,
	removeKeepOutArea = 0
}
local setKeepOutArea

if not FFlagTopBarSignalizeKeepOutAreas then
	setKeepOutArea = t.callback
end

v.setKeepOutArea = setKeepOutArea
local removeKeepOutArea

if not FFlagTopBarSignalizeKeepOutAreas then
	removeKeepOutArea = t.callback
end

v.removeKeepOutArea = removeKeepOutArea
extended.validateProps = strictInterface(v)

function extended:init()
	self.buttonRef = Roact.createRef()

	function self.chatIconActivated()
		ChatSelector:ToggleVisibility()
		gameSettings.ChatVisible = ChatSelector:GetVisibility()

		if fFlagEnableTopBarAnalytics then
			Analytics.default:onChatButtonActivated(gameSettings.ChatVisible)
		end
	end

	if FFlagTopBarSignalizeKeepOutAreas then
		self.keepOutAreasStore = CoreGuiCommon.Stores.GetKeepOutAreasStore(false)
	end
end

function extended.render(data)
	return withStyle(function(_)
		local visible = data.props.topBarEnabled
			and data.props.chatEnabled
			and not (TenFootInterface:IsEnabled() or VRService.VREnabled)

		local experienceChatVisualConfig = getExperienceChatVisualConfig()
		local iconSize = experienceChatVisualConfig.iconSize
		local icon = Images[experienceChatVisualConfig.icon.on]

		if not data.props.chatVisible then
			icon = Images[experienceChatVisualConfig.icon.off]
		end

		local function fn(current)
			if visible and current then
				if FFlagTopBarSignalizeKeepOutAreas then
					data.keepOutAreasStore.setKeepOutArea(
						Constants.ChatIconKeepOutAreaId,
						current.AbsolutePosition,
						current.AbsoluteSize
					)
				else
					data.props.setKeepOutArea(
						Constants.ChatIconKeepOutAreaId,
						current.AbsolutePosition,
						current.AbsoluteSize
					)
				end
			elseif FFlagTopBarSignalizeKeepOutAreas then
				data.keepOutAreasStore.removeKeepOutArea(Constants.ChatIconKeepOutAreaId)
			else
				data.props.removeKeepOutArea(Constants.ChatIconKeepOutAreaId)
			end
		end

		local function fn2(current)
			if current then
				data.buttonRef.current = current
				fn(data.buttonRef.current)
			end
		end

		if data.buttonRef.current then
			fn(data.buttonRef.current)
		end

		local element = Roact.createElement(IconButton, {
			icon = icon,
			iconSize = iconSize,
			onActivated = data.chatIconActivated,
			[Roact.Change.AbsoluteSize] = fn,
			[Roact.Change.AbsolutePosition] = fn,
			[Roact.Ref] = fn2
		})

		local createElement = Roact.createElement
		local v2 = {
			Text = "",
			Visible = visible,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 44, 1, 0),
			LayoutOrder = data.props.layoutOrder,
			Selectable = false
		}

		local createElement2 = Roact.createElement
		local v3 = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 2 }
		local badge

		if data.props.unreadMessages > 0 then
			badge = Roact.createElement(Badge, {
				position = UDim2.fromOffset(18, shouldShowEmptyBadge() and 6 or 2), -- inferred equivalent call
				anchorPoint = Vector2.new(0, 0),
				hasShadow = false,
				value = shouldShowEmptyBadge() and BadgeStates.isEmpty or data.props.unreadMessages -- inferred equivalent call
			})
		else
			badge = false
		end

		return createElement("TextButton", v2, {
			Background = element,
			BadgeContainer = createElement2("Frame", v3, { Badge = badge })
		})
	end)
end

local function mapStateToProps(data)
	return {
		chatVisible = data.chat.visible,
		unreadMessages = data.chat.unreadMessages,
		topBarEnabled = data.displayOptions.topbarEnabled,
		chatEnabled = data.coreGuiEnabled[Enum.CoreGuiType.Chat]
	}
end

local function mapDispatchToProps(callback)
	if FFlagTopBarSignalizeKeepOutAreas then
		return {}
	end

	return {
		setKeepOutArea = function(p, p2, p3)
			return callback(SetKeepOutArea(p, p2, p3))
		end,
		removeKeepOutArea = function(p)
			return callback(RemoveKeepOutArea(p))
		end
	}
end

local UNSTABLE_connect2 = RoactRodux.UNSTABLE_connect2

if FFlagTopBarSignalizeKeepOutAreas then
	mapDispatchToProps = nil
end

return UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended)
